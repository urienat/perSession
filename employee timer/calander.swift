//
//  calanderExt.swift
//  perSession
//
//  Created by uri enat on 26/11/2017.
//  Copyright © 2017 אורי עינת. All rights reserved.
//


import Foundation
import UIKit
import Firebase
import Google
import GoogleSignIn
import GoogleAPIClientForREST

class calander: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
   
    let dbRef = FIRDatabase.database().reference().child("fRecords")
    let dbRefEmployer = FIRDatabase.database().reference().child("fEmployers")
    let dbRefEmployee = FIRDatabase.database().reference().child("fEmployees")
    
    
    let mydateFormat5 = DateFormatter()
    let mydateFormat6 = DateFormatter()
    
    var calIn = ""
    var calInFB = ""
    
    var employerFromMain = ""
    var employeeId = ""
    var employerId = ""
    var employerArray: [String:Int] = [:]
    var employerArray2: [String] = []
    var employerArray3: [String:String] = [:]
    var employerNameForGoogle = ""
    var employerLastNameForGoogle = ""
    var employerNameLastNameForGoogle = ""
    var LastCalander: String?
    var Dictionary = [String: String]()



    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    //private let scopes = [kGTLRAuthScopeCalendarReadonly]
    let scopes = [kGTLRAuthScopeCalendar]
    let service = GTLRCalendarService()
    let output = UITextView()
    let updater = GTLRCalendar_Event()
    var id1: String?

    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mydateFormat5.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM/dd/yy, (HH:mm)"
            ,options: 0, locale: nil)!
        mydateFormat6.dateFormat = DateFormatter.dateFormat(fromTemplate: " EEE-dd-MMM-yyyy, (HH:mm)", options: 0, locale:Locale.autoupdatingCurrent )!
        
        service.shouldFetchNextPages = true

        let currentUser = FIRAuth.auth()?.currentUser
        print (currentUser as Any)
        if currentUser != nil {
            
            print(currentUser!.uid)
            employeeId = (currentUser!.uid)
            //create zugot
            findEmployerId()
        }
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        if GIDSignIn.sharedInstance().hasAuthInKeychain() == true{
            
            GIDSignIn.sharedInstance().signInSilently()
            print ("in")
            
        }
        else{
            print ("out")
            let signInButton = GIDSignInButton()
            view.addSubview(signInButton)
            signInButton.frame = CGRect(x: view.frame.width/2-104, y: 130, width: 208, height: 45)

            //not sign in
            
        }
        
       // GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
       
        
        //Add a UITextView to display output.
        output.frame = view.bounds
        output.isEditable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        output.isHidden = true
        //view.addSubview(output);
        
    }//end of view did load ////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            showAlert(title: "Authentication Error", message: error.localizedDescription)
            self.service.authorizer = nil
        } else {
      //      self.signInButton.isHidden = true
            self.output.isHidden = false
            
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            alert123()
        }
    }
    
    
    
    // Construct a query and get a list of upcoming events
    func fetchEvents() {
        let query = GTLRCalendarQuery_EventsList.query(withCalendarId: "primary")// instard of "primary"
        query.maxResults = 50

        self.dbRefEmployee.child(self.employeeId).observeSingleEvent(of: .value , with: { (snapshot) in
            self.LastCalander = String(describing: snapshot.childSnapshot(forPath: "fLastCalander").value!) as String!
        })//end of dbref
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
        print("0.2 \(self.LastCalander!)")
        
        if self.LastCalander == nil { self.LastCalander = "New"}
        if self.LastCalander! == "New" {query.timeMin = GTLRDateTime(date: (Date()-(3600*24*45)))
            } else {query.timeMin = GTLRDateTime(date: (Date()-(3600*24*45)))//replace to avoid double reading
            }//avoid reread of same period
            print("222")

            query.timeMax = GTLRDateTime(date: Date())
            //query.alwaysIncludeEmail = true
            query.singleEvents = true
            query.orderBy = kGTLRCalendarOrderByStartTime
            self.service.executeQuery(
            query,
            delegate: self,
            didFinish: #selector(self.displayResultWithTicket(ticket:finishedWithObject:error:)))
        }//end of dispatch
       
        }//end of fetchevents
        
    

    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response :  GTLRCalendar_Events,
        error : NSError?) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
            return
        }

        var outputText = ""
        if let events = response.items, !events.isEmpty {
        for event in events {
                let start = event.start!.dateTime ?? event.start!.date!
                //let end = event.end!.dateTime ?? event.start!.date!

                calIn = self.mydateFormat6.string(from: start.date)
                calInFB = self.mydateFormat5.string(from: start.date)
                employerFromMain = event.summary!
                
                _ = DateFormatter.localizedString(
                    from: start.date,
                    dateStyle: .short,
                    timeStyle: .short)

                outputText += "\(calIn) - \(event.summary!)\r\n\r\n"
                print ("\(event.summary!)")
                print (employerArray3)
                 print ([employerArray3[event.summary!]] )
                let keyExists = employerArray3[("\(event.summary!)")]

                if (keyExists)  != nil { print ("CAL");employerId = employerArray3[event.summary!]!
                    saveToDB2()
                  
                //avoid double entry
                id1 = event.identifier
                updater.summary = ("\(event.summary!)+")
                updateRead()
   
                } else { print ("nothing")//do nothing
                }
            
                }
                } else {
                outputText = "No upcoming events found."
                }
                //output.text = outputText
                // save last date
                self.dbRefEmployee.child(employeeId).updateChildValues(["fLastCalander":self.mydateFormat5.string(from: Date())])
                self.navigationController!.popViewController(animated: false)

                }
    
    func updateRead(){
    let query2 = GTLRCalendarQuery_EventsPatch.query(withObject: self.updater , calendarId: "primary", eventId:id1!)
    service.executeQuery(query2) { (ticket: GTLRServiceTicket, Any, error) in
    if let error = error {
    self.showAlert(title: "Error", message: error.localizedDescription)
    return
    }//end of if error
    }
    }//end of func
 
    func saveToDB2() {
    let record = ["fIn" : calInFB,  "fEmployer": String (describing : employerFromMain),"fIndication3" :"📆","fStatus" : "Pre","fEmployeeRef": String (describing : employeeId),"fEmployerRef":  String (describing : employerId)]
            
    let recordRefence = self.dbRef.childByAutoId()
    recordRefence.setValue(record)
        
    self.dbRefEmployee.child(employeeId).child("fEmployeeRecords").updateChildValues([recordRefence.key:Int(-((self.mydateFormat5.date(from: calInFB))?.timeIntervalSince1970)!)])
    self.dbRefEmployer.child(self.employerId).child("fEmployerRecords").updateChildValues([recordRefence.key:Int(-((self.mydateFormat5.date(from: calInFB))?.timeIntervalSince1970)!)])
        
    }//end of save
    
    func findEmployerId(){
        print ("fetch employerId")
        
        employerArray3.removeAll()
        employerArray2.removeAll()
        employerArray.removeAll()
        
        self.dbRefEmployee.child(employeeId).queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapshot) in
            
        self.employerArray = snapshot.childSnapshot(forPath: "myEmployers").value! as! [String:Int]
        self.employerArray2 = Array(self.employerArray.keys) // for Dictionary
        print ("employerArray2\(self.employerArray2)")
          
        print ("match")
        for eachEmployer in 0...(self.employerArray2.count-1){
            
        self.dbRefEmployer.child(self.employerArray2[eachEmployer]).child("fEmployer").observeSingleEvent(of: .value, with: { (snapshot) in
        self.employerLastNameForGoogle = String(describing: snapshot.value!)
        self.employerArray3[self.employerLastNameForGoogle] = self.employerArray2[eachEmployer]
        print ("tttt1\(self.employerLastNameForGoogle)")
        })

        
        self.dbRefEmployer.child(self.employerArray2[eachEmployer]).child("fName").observeSingleEvent(of: .value, with: { (snapshot) in
        self.employerNameForGoogle = String(describing: snapshot.value!)
        if  self.employerNameForGoogle != ""   {self.employerArray3[self.employerNameForGoogle] = self.employerArray2[eachEmployer] }
        print ("tttt2\(self.employerNameForGoogle)")
            
        self.employerNameLastNameForGoogle = ("\(self.employerNameForGoogle) \(self.employerLastNameForGoogle)")
        if  self.employerNameForGoogle != "" {self.employerArray3[self.employerNameLastNameForGoogle] = self.employerArray2[eachEmployer]}
        print ("tttt3\(self.employerNameLastNameForGoogle)")
        print("uuuu4\(self.employerArray3)")
        })

        }//end of loop
        })//end of dbref employeeid
        }//end of find
    
    

   
    
    
    
// alerts/////////////////////////////////////////////////////////////////////////////////////////////////////////
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let ok = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.default,
            handler: nil
        )
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func  alert123(){
        
        let alertController123 = UIAlertController(title: ("Download Calander Session") , message: "You are about to download calander's sessions from last 30 days that use the exact account name as event's name - are you sure?" , preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            //download
            self.fetchEvents()

            
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            //do nothing
        }
        
        alertController123.addAction(OKAction)
        alertController123.addAction(CancelAction)
        
        self.present(alertController123, animated: true, completion: nil)
        
    }
}
