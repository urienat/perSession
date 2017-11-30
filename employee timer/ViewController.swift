//BackUP
//  ViewController.swift
//  HP2
//
//  Created by אורי עינת on 1.9.2016.
//  Copyright © 2016 אורי עינת. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import AVFoundation
import Google
import GoogleSignIn
import GoogleAPIClientForREST

class ViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    var window: UIWindow?

    
    
    //database reference

    let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
    var newRegister = ""
    
    let dbRef = FIRDatabase.database().reference().child("fRecords")
    let dbRefEmployer = FIRDatabase.database().reference().child("fEmployers")
    let dbRefEmployee = FIRDatabase.database().reference().child("fEmployees")
    var tableRowHeight:Int?
    var employerRadious:Int?
    
    static var fixedCurrency:String!
    static var fixedName:String!
    static var fixedLastName:String!
    static var fixedemail:String!
    static var dateTimeFormat:String!
    
    var paymentUpdate = String()
    var RateUpdate = 0.0

    
    var alive:Bool?
    static var checkSubOnce: Int?
    var addDog: Int?

    static var refresh:Bool?

    var player : AVAudioPlayer?
    
     var employerlistSub = UIView.self

    
    var savedActiveRecord = ""

    @IBOutlet weak var profile: UIBarButtonItem!
    
    var greenColor = UIColor(red :32.0/255.0, green: 150.0/255.0, blue: 24.0/255.0, alpha: 1.0)
    var redColor = UIColor(red :170.0/255.0, green: 26.0/255.0, blue: 0/255.0, alpha: 1.0)
    var brownColor = UIColor(red :141/255.0, green: 111/255.0, blue: 56/255.0, alpha: 1.0)
    var yellowColor = UIColor(red :225/255.0, green: 235/255.0, blue: 20/255.0, alpha: 1.0)
    var blueColor = UIColor(red :22/255.0, green: 131/255.0, blue: 248/255.0, alpha: 1.0)


    
    let Vimage = UIImage(named: "vNaked")
    let nonVimage = UIImage(named: "emptyV")
    let dogVimage = UIImage(named: "dogshadow")
    let noSign = UIImage(named:"noSign")
    let sandwtchImageBig = UIImage(named: "sandWatchBig")
    let roundImageBig = UIImage(named: "roundBig")
    let pencilImage = UIImage(named: "pencilImage")

   
    var leashImage = UIImage(named:"Leash")?.withRenderingMode(.alwaysTemplate)
    var meluna = UIImage(named:"meluna")?.withRenderingMode(.alwaysTemplate)
    var billsIcon = UIImage(named:"billsIcon")?.withRenderingMode(.alwaysTemplate)
    var walkerProfile = UIImage(named:"walkerProfile")?.withRenderingMode(.alwaysTemplate)

    
    var ImageFromFirebase : UIImage?

    let mydateFormat = DateFormatter()
    let mydateFormat2 = DateFormatter()
    let mydateFormat5 = DateFormatter()
    let mydateFormat6 = DateFormatter()
    let mydateFormat7 = DateFormatter()

    //varibalwds for roundung
    var roundSecond = 0
    var roundMinute = 0
    var roundHour = 0
    var roundDay = 0
    var total = 0
    

    var activeId = ""
    var activeid2 = ""
    var  recordInProcess = ""
    
    var employerItem = ""
    var profileImageUrl = ""
    var dogItem = ""
    var activeItem = ""
    var employerInProcess = ""
    var employerIdRef = ""

     var activeSign = ""
    
    var dOut = ""
    
    var methood = "Normal"
    
    var pickerlabel =  UILabel.self
    

    @IBOutlet weak var thinking2: UIActivityIndicatorView!
    @IBOutlet weak var employerList: UITableView!
    @IBOutlet weak var employerListTop: NSLayoutConstraint!
    
    @IBOutlet weak var emoloyerListBottom: NSLayoutConstraint!
    @IBOutlet weak var employerListHeiget: NSLayoutConstraint!
    @IBOutlet weak var employerListBottom: NSLayoutConstraint!
    
    var listOfEmployers = [String:Int]()
    
    //Choose an employer object
    var pickerData: [String] = [String]()
    var nameData: [String] = [String]()
    var activeData: [String] = [String]()

    var pickerIP: [String] = [String]()
    var employerIdArray: [AnyObject] = []
    var employerIdArray2: [AnyObject] = []

    var imageArray: [String] = [String]()
    
    //variable for Segue
    var employerToS = ""
    var employerIDToS = ""
    var employeeIDToS = ""

    
    
    
    //variables for the Timer
    var employeeTimer = Timer()
    var employeeCounter: Int = 0
    var employeeCounterAsDate = Date()

    var dIn = String (describing: Date())
    var dIn2 = String (describing: Date())

    //var timeOut = Date()
  

   
    
    
    //The  appear
    
    
    
    @IBOutlet weak var googleCalander: UIBarButtonItem!
    @IBAction func googleCalander(_ sender: Any) {
        
    }
    
    @IBOutlet weak var addAccount: UIBarButtonItem!
    @IBAction func addAccount(_ sender: Any) {
        print ("add")
        employerToS = "Add new dog"
        petFileClicked()
    }
    

        @IBOutlet weak var DateIn: UILabel!
        @IBOutlet weak var workedFor: UILabel!
        @IBOutlet weak var addAmanualRecord: UIView!
    
        @IBOutlet weak var records: UIBarButtonItem!
        @IBOutlet weak var bills: UIBarButtonItem!
        @IBOutlet weak var petFile: UIBarButtonItem!

        @IBOutlet weak var setting: UIBarButtonItem!
        @IBOutlet weak var blinker: UILabel!
        @IBOutlet weak var blinker2: UILabel!
        @IBOutlet weak var chooseEmployer: UIButton!
        @IBOutlet weak var animationImage: UIImageView!
    @IBOutlet weak var textAdd: UITextView!
    
    @IBOutlet weak var startImage: UIImageView!
    @IBOutlet weak var stopImage: UIImageView!
    
    
    @IBOutlet weak var toolBar: UIToolbar!
    let btn1 = UIButton(type: .custom)
    let btn2 = UIButton(type: .custom)
    let btn3 = UIButton(type: .custom)
    let btn4 = UIButton(type: .custom)

    
    
  //  @IBOutlet weak var dogFileLbl: UITextField!
   // @IBOutlet weak var fileLbl: UITextField!

    
    //background that helps "add a manual background" disappear after it eas chosen
        @IBOutlet weak var startBackground: UIView!
    
    //start timer action
        @IBAction func Start(_ sender: AnyObject) {
           
                textAdd.text = "Session added: \r\n\r\n\( mydateFormat7.string(from: Date()))"
                self.postRoundView()

               
                self.dbRefEmployee.child(self.employeeIDToS).child("myEmployers").updateChildValues([(self.employerIDToS):1]) //consider chane font color
                
                //intial date and time of the timer
                dIn =  mydateFormat5.string(from: Date()) //brings the a date as a string
                dIn2 = mydateFormat2.string(from: Date()) //brings the a date as a string
               // DateIn.text = "Started:  " + self.dIn2
                
                let record = ["fIn" : dIn, "fOut": dIn,"fIndication3": "↺","fTotal":"-1", "fEmployer": String (describing : employerToS),"fEmployeeRef": employeeIDToS,"fEmployerRef": employerIDToS,"fStatus" : "Pre"]
                let fInRef = dbRef.childByAutoId()
                fInRef.setValue(record)
                print(fInRef)
                
                print (String(describing:self.chooseEmployer.currentTitle!))
                                
                self.dbRefEmployee.child(self.employeeIDToS).child("fEmployeeRecords").updateChildValues([fInRef.key:Int(-(self.mydateFormat5.date(from: self.dIn)?.timeIntervalSince1970)!)])
                self.dbRefEmployer.child(self.employerIDToS).child("fEmployerRecords").updateChildValues([fInRef.key:Int(-(self.mydateFormat5.date(from: self.dIn)?.timeIntervalSince1970)!)])

                

        }//end of start
    

        @IBOutlet weak var startButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {  //view did load/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    super.viewDidLoad()
        
        
print ("started view did load")
        ViewController.checkSubOnce = 1
        
        //check if user not deleted
     checkUserAgainstDatabase { (alive, error3) in
       
        }
        
        employerList.dataSource = self
        employerList.delegate = self
        
        records.isEnabled = false

        //connectivity
        if Reachability.isConnectedToNetwork() == true
        {
            print("Internet Connection Available!")
        }
        else
        {
            print("Internet Connection not Available!")
            alert50()
        }
        
        employerList.backgroundColor = UIColor.clear
        
        
        //application did become active
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive(notification:)), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomeActive(notification:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
       
        //application stop active
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomePassive(notification:)), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.applicationDidBecomePassive(notification:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        let currentUser = FIRAuth.auth()?.currentUser
        print (currentUser as Any)
           if currentUser != nil {
            print(currentUser!.uid)
            self.employeeIDToS = (currentUser!.uid)
            print ("employerIDTOS\(self.employeeIDToS)")
            print ("employeridref\(self.employerIdRef)")
            print ("employeridref2\(self.employerIdRef)")
            self.fetchEmployers()
            self.dbRefEmployee.removeAllObservers()

        
        
        if methood == "Normal" {print ("Normal!!!!!!!!")}
       
        //formating the date
        mydateFormat.dateFormat = DateFormatter.dateFormat(fromTemplate: " EEE-dd-MMM-yyyy, (HH:mm)", options: 0, locale: nil)!
        mydateFormat2.dateFormat = DateFormatter.dateFormat(fromTemplate:  " HH:mm", options: 0, locale: nil)!
        mydateFormat5.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM/dd/yy, (HH:mm)"
                ,options: 0, locale: nil)!
            mydateFormat7.dateFormat = DateFormatter.dateFormat(fromTemplate: " EEE-dd MMM, (HH:mm)"
                ,options: 0, locale: nil)!
        mydateFormat6.dateFormat = DateFormatter.dateFormat(fromTemplate: " EEE-dd-MMM-yyyy, (HH:mm)", options: 0, locale: nil)!
        
        DateIn.text = ""
       
        self.dbRefEmployee.queryOrderedByKey().queryEqual(toValue: currentUser?.uid).observeSingleEvent(of: .childAdded, with: { (snapshot) in
        ViewController.fixedCurrency = String(describing: snapshot.childSnapshot(forPath: "fCurrency").value!) as String
            ViewController.fixedName =  String(describing: snapshot.childSnapshot(forPath: "fName").value!) as String
            ViewController.fixedLastName =  String(describing: snapshot.childSnapshot(forPath: "fLastName").value!) as String
            ViewController.fixedemail =  String(describing: snapshot.childSnapshot(forPath: "femail").value!) as String
            ViewController.dateTimeFormat =  String(describing: snapshot.childSnapshot(forPath: "fDateTime").value!) as String


        })
            
           } else {
            
            print ("i am here")
            print ("newreg\(newRegister)")
            if  newRegister == "YES" {
                self.navigationController? .pushViewController(self.storyboard!.instantiateViewController(withIdentifier: "setting"), animated: false)
            }//end of Yes
            //no user connected
        }//end of else
        ////////end of firauth
 
        self.thinking2.hidesWhenStopped = true
        self.thinking2.startAnimating()
        
        btn1.setImage(leashImage, for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        btn1.addTarget(self, action:#selector(recordsClicked), for: UIControlEvents.touchDown)
        records.customView = btn1
        
        btn2.setImage(meluna, for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        btn2.addTarget(self, action:#selector(petFileClicked), for: UIControlEvents.touchDown)
        petFile.customView = btn2
        
        btn3.setImage(billsIcon, for: .normal)
        btn3.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        btn3.addTarget(self, action:#selector(billsClicked), for: UIControlEvents.touchDown)
        bills.customView = btn3
        
        btn4.setImage(walkerProfile, for: .normal)
        btn4.frame = CGRect(x: 0, y: 0, width: 60, height: 100)
        btn4.addTarget(self, action:#selector(profileClicked), for: UIControlEvents.touchDown)
        profile.customView = btn4

       
        self.employerList.separatorColor = blueColor



    }// end of viewdidload//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   
    override func viewDidAppear(_ animated: Bool) {

        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                
            
            }

    
            else {
            
                print("Not connected")
               
                
                // Delay 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0){
                connectedRef.observe(.value, with: { snapshot in
                if let connected = snapshot.value as? Bool, connected {
                    print("Connected after all")} else  {print("not connected after all");self.noFB()}
                  })
                }}
            
        })
        
        if ViewController.refresh == true ||  employerToS ==  "Add new dog" {
        chooseEmployer.sendActions(for: .touchUpInside)
        ViewController.refresh = false
            
           
        
            
        }
        

    }//end of view did appear
    
    
        override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if(UIApplication.shared.statusBarOrientation.isLandscape)
        {backgroundImage.frame = self.view.bounds} else   {backgroundImage.frame = self.view.bounds}
        }//end of did rotate
    
    
    //sound
    // let alertSound = audioPlayer.data
    //try audioPlayer = AVAudioPlayer.init(data: alertSound!, fileTypeHint: "wav")
    
    // audioPlayer.prepareToPlay()
    //audioPlayer.play()
    
    func playSound() {
        let url = Bundle.main.url(forResource: "dogBark", withExtension: "wav")
        
        do {
            player = try AVAudioPlayer(contentsOf: url!)
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }//end of palysound
    
    //check subscription
    func checkSubs()
    {
    //    /*
       print(ViewController.checkSubOnce!,self.employerIdArray2.count)
        
        if ViewController.checkSubOnce == 1 && self.employerIdArray2.count > 3 || self.employerIdArray2.count > 2 && addDog == 1 { RebeloperStore.shared.verifyRenewablePurchase(.autoRenewableSubscription1) { (result, resultString) in
            print( result)
            
            if result == false { ViewController.checkSubOnce = 1;print ("no subscription"); self.alert83() //uncomment to make sure there is a subbscription check
            }
            else {ViewController.checkSubOnce = 2} //end of else  meaning there is subscription
            }//end of subscription result check
            
            }else {ViewController.checkSubOnce = 2}// alreadu checked checksubonce = 2 or count <2
        ViewController.checkSubOnce = 2//uncomment to enable check
        addDog = 0
 
// */
    }//end of func
  
    //Check if user does exists
    func checkUserAgainstDatabase(completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        currentUser.getTokenForcingRefresh(true) { (idToken, error) in
            if let error = error {
                completion(false, error as NSError?)
                print(error.localizedDescription)
                
               try! FIRAuth.auth()!.signOut()
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
               // let loginViewController  =  storyboard.instantiateViewController(withIdentifier: "loginScreen")
                //self.window?.rootViewController = loginViewController
                self.present((storyboard.instantiateViewController(withIdentifier: "loginScreen")), animated: true, completion: nil)

                
            } else {
                
                completion(true, nil)
            }
        }
    }

    
    //did become active procedure
    func applicationDidBecomeActive(notification: NSNotification) {
        thinking2.startAnimating()

        //stopButton.sendActions(for: .touchUpInside)
        if petFile.isEnabled == true {
       // self.activeId = idFromSleep
            print ("resumeactiveID\(self.activeId)")
            self.recordInProcess = self.savedActiveRecord
            print ("resumeRecordinprocess\(self.recordInProcess)")
            
            
           
            
            
            
            if recordInProcess != "" {
                bringRecord()
            }
            else{
                preStartView()
            }//end of elsee
           

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {

        self.thinking2.stopAnimating()
        }

    }// end of func application did become
    
    //did stop active procedure
    func applicationDidBecomePassive(notification: NSNotification) {
        
        //stopButton.sendActions(for: .touchUpInside)
        if petFile.isEnabled == true {
            savedActiveRecord =  self.recordInProcess
            print ("resumeactiveID\(self.activeId)")

        }
    }// end of func application did stop
    
    //chose employer
        @IBAction func chooseEmployerBtn(_ sender: AnyObject) {
            
            thinking2.startAnimating()
            
            employerIDToS = ""
            employerToS = ""
        //self.employeeTimer.invalidate() //dismiss func of counter

        fetchEmployers()
        self.dbRefEmployee.removeAllObservers()
            
        postTimerView()
        self.animationImage.alpha = 1


        }//end of choose employerbtn
    
        override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
    
    
    func recordsClicked() {
      performSegue(withIdentifier: "employerforVC", sender: employerToS)
    }
    
    func petFileClicked() {
        performSegue(withIdentifier: "employerForDogFile", sender: employerToS)
    }
    
    func  billsClicked() {
        performSegue(withIdentifier: "employerForBills", sender: employerToS)
    }
    
    func  profileClicked() {
        performSegue(withIdentifier: "setting", sender: employerToS)
    }
    //add record
    
    @IBAction func addManualRecord(_ sender: Any) {
    
            print ("click")
            
            
       // performSegue(withIdentifier: "employerforRecord", sender: employerToS)
        }
  
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "employerforRecord") {
        let secondView = segue.destination as? datePicker2
            secondView?.employerFromMain = employerToS
            secondView?.employerID = employerIDToS
            secondView?.employeeID = employeeIDToS
            secondView?.paymentMethood = paymentUpdate

        }//end of if
        
        else if (segue.identifier == "employerForDogFile"){
        let recordsView = segue.destination as? dogFile
        recordsView?.employerID = employerIDToS
        recordsView?.employerFromMain = employerToS
        recordsView?.employeeID = employeeIDToS
        }//end of else if
            
        else if (segue.identifier == "employerForBills"){
            let recordsView = segue.destination as? biller
            recordsView?.employerID = ""//employerIDToS
            recordsView?.employerFromMain = employerToS
            recordsView?.employeeID = employeeIDToS
        }//end of else if
    
        else{
        let recordsView = segue.destination as? newVCTable
        recordsView?.employerFromMain = employerToS
        recordsView?.employerID = employerIDToS
        recordsView?.employeeID =  employeeIDToS
        }
        }//end of prepare
    
    
    //bring record
        func bringRecord() {

        print (recordInProcess)
        dbRef.child(recordInProcess).observeSingleEvent(of:.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
            let record = recordsStruct()
            record.setValuesForKeys(dictionary)
            print ("Dic:\(dictionary)")
            self.activeId = self.recordInProcess
            
            // bring in process data to record
            self.dIn = record.fIn!
                self.dIn2 = self.mydateFormat2.string(from:self.mydateFormat5.date(from: self.dIn)!)
                self.DateIn.reloadInputViews()
                print ("din from  in process\(self.dIn)")
                                self.DateIn.text = "Started:  " + self.dIn2

                
              
               
            }// end of if let dictionary
        }, withCancel: { (Error) in
            print("error from FB")
        })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                
                self.thinking2.stopAnimating(self.postStartView())

            }

            
            } //end of bring record
    
    //bring record round
    func bringRecordRound() {
        
        
        dbRef.child(activeid2).observeSingleEvent(of:.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: String] {
                let record = recordsStruct()
                record.setValuesForKeys(dictionary)
                print ("Dic:\(dictionary)")
                

                
                // bring in process data to record
                self.dIn = record.fIn!
                print ("din from  in process\(self.dIn)")
                self.DateIn.text = "Started:  " + self.dIn2
                
            
                
                
                }// end of if let dictionary
        }, withCancel: { (Error) in
            print("error from FB")
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            
            self.thinking2.stopAnimating(self.postStartView())
            
        }
        

    } //end of bring recordround
    
    //normal closure
        func normalClosure () {
        print("recordiscomplete")
        let alertController = UIAlertController(title: (dIn) , message: ("Till: \( mydateFormat2.string(from: mydateFormat5.date(from: dOut)!))"), preferredStyle: .alert)
        let resumeAction = UIAlertAction(title: "Resume", style: .default) { (UIAlertAction) in
        print ("resumeactiveID\(self.activeId)")
        self.recordInProcess = self.activeId
        print ("resumeRecordinprocess\(self.recordInProcess)")

            self.bringRecord()
            self.postStartView()

        } //end of resume
            
        let cancelAction = UIAlertAction(title: "Delete", style: .cancel) { (UIAlertAction) in
            self.preStartView()
            
           
            self.dbRef.child(self.activeId).removeValue()
            self.navigationController!.popViewController(animated: true)
            

            self.dbRefEmployee.child(self.employeeIDToS).child("myEmployers").updateChildValues([(self.employerIDToS):5])
            self.dbRefEmployer.child(self.employerIDToS).updateChildValues(["finProcess" : ""])
            //self.employeeCounter = 0
            self.activeId = ""
            self.recordInProcess = self.activeId

        }//end of cancel action
        
            //update action
        let updateDBAction = UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            
            
            //rounding
            let calendar = Calendar.current
            let date2 = calendar.dateComponents([.day, .hour,.minute,.second], from: self.mydateFormat5.date(from: self.dIn)!)
            let date1 = calendar.dateComponents([.day, .hour,.minute, .second], from: self.mydateFormat5.date(from: self.dOut)!)
                
            self.roundSecond = date1.second! - date2.second!
            self.roundMinute = date1.minute! - date2.minute!
            self.roundHour = date1.hour! - date2.hour!
            self.roundDay = date1.day! - date2.day!
            print ("second\(self.roundSecond)")
            print ("roundMinute\(self.roundMinute)")
            print ("hour\(self.roundHour)")
            print ("roundDay\(self.roundDay)")

            if self.roundDay == 0 {  self.total = self.roundMinute*60 + self.roundHour*3600}
            else if self.roundDay == 1 {self.total = ((24-date2.hour!+date1.hour!)*3600 + (self.roundMinute*60))}
            else {self.total = 0            }
            let total2 = self.mydateFormat5.date(from: self.dOut)!.timeIntervalSince((self.mydateFormat5.date(from: self.dIn))!)
            self.dbRefEmployee.child(self.employeeIDToS).child("myEmployers").updateChildValues([(self.employerIDToS):5])

            self.dbRefEmployer.child(self.employerIDToS).updateChildValues(["finProcess" : ""])

            print ("total\(self.total)")
            print ("total2\(total2)")

            let record = [ "fOut" : self.dOut, "fTotal" : String((self.total)),"fIndication3" : "⏳", "fStatus" : "Pre" ]
            
            print ("active in updating statge:\(self.activeId)")
            

            
            self.dbRef.child(self.activeId).updateChildValues(record)
            self.dbRefEmployer.child(self.employerIDToS).updateChildValues(["finProcess" : ""])
            self.dbRefEmployee.child(self.employeeIDToS).child("fEmployeeRecords").updateChildValues([self.activeId:Int(-(self.mydateFormat5.date(from: self.dIn)?.timeIntervalSince1970)!)])
            
            
            self.dbRefEmployer.child(self.employerIDToS).child("fEmployerRecords").updateChildValues([self.activeId:Int(-(self.mydateFormat5.date(from: self.dIn)?.timeIntervalSince1970)!)])
            
            
            
            
            self.navigationController!.popViewController(animated: true)
            
            self.animationImage.center.x -= self.view.bounds.width
            self.animationImage.isHidden = false
            self.animationImage.alpha = 1

           
            UIView.animate(withDuration: 2.0, animations:{
                self.animationImage.center.x += self.view.bounds.width
            })
            UIView.animate(withDuration: 2.0, delay :2.0 ,options:[],animations: {
                self.animationImage.alpha = 0
               // self.preStartView()
                self.startBackground.alpha = 0
                self.addAmanualRecord.alpha = 0
            },completion:nil)
            UIView.animate(withDuration: 1.0, delay :4.0 ,options:[],animations: {
                self.startBackground.alpha = 1
                self.addAmanualRecord.alpha = 1
                self.preStartView()
            },completion:nil)

            self.activeId = ""
            self.recordInProcess = self.activeId

        }//end of update action
            
            print (self.employeeCounter)
            alertController.addAction(cancelAction)
            alertController.addAction(updateDBAction)
            alertController.addAction(resumeAction)
            self.present(alertController, animated: true, completion: nil)
        }//probabaly end of normal closure

 
    
    //check if their is who to connect
    func checkConnection() {
        
        
    }

    
    //fetch employer
        func fetchEmployers() {
       
                self.employerIdArray.removeAll()
                self.employerIdArray2.removeAll()
                
                self.pickerData.removeAll()
                self.imageArray.removeAll()
                self.nameData.removeAll()
                self.activeData.removeAll()
                self.pickerIP.removeAll()
            
 
            print ("pickerData\(self.pickerData)")


        
        print("ihkhih\(employeeIDToS)")
            //self.employerList.reloadData()

        
            self.dbRefEmployee.child(self.employeeIDToS).child("myEmployers").observeSingleEvent(of: .value, with:{(snapshot) in
           // self.employerIdRef = String(describing: snapshot.key)
                self.listOfEmployers = snapshot.value as! [String : AnyObject] as! [String : Int]
                func sortFunc   (_ s1: (key: String, value: Int), _ s2: (key: String, value: Int)) -> Bool {
                    return   s2.value > s1.value
                    }
            //self.employerIdArray.append((self.employerIdRef))
            
                print ("ggggg\(self.listOfEmployers)")
                
                self.employerIdArray = (self.listOfEmployers.sorted(by: sortFunc) as [AnyObject]  )
                print ("ggggg2\(self.employerIdArray)")
                
                for j in 0...(self.employerIdArray.count-1){
                    let splitItem = self.employerIdArray[j] as! (String, Int)
                    print (splitItem)
                    
                    let split2    = splitItem.0
                    print (split2)
                    
                    if split2 != "New Dog" {
                        self.employerIdArray2.append(split2 as AnyObject) } else {//do nothing
                        
                    }
                    
                }
                
                print ("employeridarray2\(self.employerIdArray2)")

                if self.employerIdArray2.isEmpty == true {self.thinking2.stopAnimating()
                    self.googleCalander.isEnabled = false
                // animation to open your first account
                } else {
                    self.googleCalander.isEnabled = true

                for iIndex in 0...(self.employerIdArray2.count-1){
                    self.dbRefEmployer.child(self.employerIdArray2[iIndex] as! String).observeSingleEvent(of: .value, with:{ (snapshot) in
                    self.employerItem = String(describing: snapshot.childSnapshot(forPath: "fEmployer").value!) as String!
                    self.pickerData.append(self.employerItem  )
                    
                    self.employerInProcess = String(describing: snapshot.childSnapshot(forPath: "finProcess").value!) as String!
                    self.pickerIP.append((self.employerInProcess))

                    self.dogItem = String(describing: snapshot.childSnapshot(forPath: "fName").value!) as String!
                    self.nameData.append(self.dogItem  )

                    self.activeItem = String(describing: snapshot.childSnapshot(forPath: "fActive").value!) as String!
                    self.activeData.append(String(describing: self.activeItem) )
                        
                        
                    self.profileImageUrl = snapshot.childSnapshot(forPath: "fImageRef").value as! String!
                    //  self.profileImageUrl = "https://firebasestorage.googleapis.com/v0/b/persession-45987.appspot.com/o/Myprofile.png?alt=media&token=263c8fdb-9cca-4256-9d3b-b794774bf4e1"
                    self.imageArray.append(self.profileImageUrl)
                      
                    if iIndex == (self.employerIdArray2.count-1) {
                     
                    self.thinking2.stopAnimating()

                    self.employerList.isUserInteractionEnabled = true
                    if self.employerIdArray2.count < 5 {self.employerListHeiget.priority = 1000 ;self.employerListBottom.priority = 750;self.employerListTop.constant = 60.0; self.employerListHeiget.constant >= 265;self.employerListBottom.constant = 285} else {self.employerListBottom.priority = 750; self.employerListHeiget.priority = 1000;self.employerListTop.constant = 30.0;self.employerListHeiget.constant >= 315;self.employerListBottom.constant = 285 }
                        self.employerList.reloadData()
                      self.checkSubs()
                        
                    self.employerList.isHidden = false
                    self.dbRefEmployer.removeAllObservers()

                    }

                    self.dbRefEmployee.removeAllObservers()
                    }){(error) in
                    print(error.localizedDescription)} // end of dbrefemployer
                
                    }//end of i loop
                    }//end of idarray2 is empty

                    }){(error) in
                    print(error.localizedDescription)}//end of dbref employee
            
                    }//end of fetch employer
    
                    func preStartView() {
        
                    self.addAmanualRecord.isHidden = false
                    self.DateIn.isHidden = true
                    self.workedFor.isHidden = true
                    self.startBackground.isHidden = false
                    self.petFile.isEnabled = true;
                    self.chooseEmployer.isUserInteractionEnabled = true
                    startBarButtonFadeOut()
                    startBarButtonFadeIn()
                  
                    }//end of func
    
                    func postStartView() {
        
                    self.petFile.isEnabled = true
                  
                    self.animationImage.isHidden = true
                    self.startBackground.isHidden = true
                    self.DateIn.isHidden = false;
                    self.workedFor.isHidden = true
                    self.addAmanualRecord.isHidden = true
                    
                    self.chooseEmployer.isUserInteractionEnabled = true
                    UIView.animate(withDuration: TimeInterval(4.9),delay: 0, options: [.repeat], animations:{
                    self.stopImage.transform = self.stopImage.transform.rotated(by: CGFloat(Double.pi*1))
                    })
      
                    }//end of func
    
                    func postTimerView() {
                    
                    DateIn.isHidden = true
                    records.isEnabled = false
                    petFile.isEnabled = false
                   
                    chooseEmployer.isHidden = true
                    startBackground.isHidden = true
                    addAmanualRecord.isHidden = true
                    animationImage.isHidden = true
                    
                    }//end of func
    
    func postRoundView() {
        
        self.petFile.isEnabled = true
        
        self.animationImage.isHidden = false
        self.startBackground.isHidden = true
        self.DateIn.isHidden = false;
        self.workedFor.isHidden = true
        self.addAmanualRecord.isHidden = true
        
        self.chooseEmployer.isUserInteractionEnabled = true
        
                self.navigationController!.popViewController(animated: true)
        
       
        ///
        self.animationImage.center.x -= self.view.bounds.width
        self.animationImage.isHidden = false
        self.animationImage.alpha = 1
       

        
        UIView.animate(withDuration: 2.0, animations:{
            self.animationImage.center.x += self.view.bounds.width
        })
        UIView.animate(withDuration: 2.0, delay :2.0 ,options:[],animations: {
            self.animationImage.alpha = 0
            self.startBackground.alpha = 0
            self.addAmanualRecord.alpha = 0

        },completion:nil)
        
        UIView.animate(withDuration: 1.0, delay :4.0 ,options:[],animations: {
            self.startBackground.alpha = 1
            self.addAmanualRecord.alpha = 1
            
            DispatchQueue.main.asyncAfter(deadline: .now()){
                UIView.animate(withDuration: 2.0, delay :0.0 ,options:[],animations: {
                    self.textAdd.alpha = 1
                },completion:nil)
                UIView.animate(withDuration: 2.0, delay :2.0 ,options:[],animations: {
                    self.textAdd.alpha = 0
                },completion:nil)
            }
            
            self.preStartView()
            self.DateIn.alpha = 0
            
            
        },completion:nil)
    }//end of func oost round view
    
    //no Firebase connection
    
    func noFB() {
       
                self.thinking2.stopAnimating()
               // self.alert30()
            }
    
    func startBarButtonFadeOut(){
        UIView.animate(withDuration: 0.3, animations: {
           
            self.startButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        })
    }
    
    // Fade In Buttons
    func startBarButtonFadeIn(){
        UIView.animate(withDuration: 0.3,delay: 0.3, animations: {
            
            self.startButton.alpha = 1
            
            self.startButton.transform = .identity// CGAffineTransformIdentity
        
            
        })
        
        UIView.animate(withDuration: 0.3, delay: 0.6 ,animations: {
            self.startButton.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            
        })
        UIView.animate(withDuration: 0.3, delay: 0.9,animations: {
            self.startButton.transform = .identity
        })
        
    }

    
    
///////////////////////////////////////alerts
    func       alert83(){
    let alertController83 = UIAlertController(title: ("Subscription alert") , message: " Adding more than two dogs requires subscription and we couldn't find one. please subscribe with free trial or log again if you have one.", preferredStyle: .alert)
    let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.present((storyboard.instantiateViewController(withIdentifier: "subScreen")), animated: true, completion: nil)
     //   self.window?.rootViewController = loginViewController

        
        
    }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            ViewController.checkSubOnce = 0
            self.addDog = 1
           let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
          self.present((storyboard.instantiateViewController(withIdentifier: "subScreen")), animated: true, completion: nil)
        }
        alertController83.addAction(OKAction)
        alertController83.addAction(cancelAction)

    self.present(alertController83, animated: true, completion: nil)
}

    func alert30(){
        let alertController30 = UIAlertController(title: ("No connection") , message: "Currently there is no connection with database. Please try again.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
        }
        
        alertController30.addAction(OKAction)
        self.present(alertController30, animated: true, completion: nil)
    }
    
 
    //Logic alert
    func logicAlert () {
        
        let alertController4 = UIAlertController(title: "Record's limit", message: "Sorry, but  24 hours is record's limit. This record is deleted . Please update with a manual record.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
           self.preStartView()
           
            
            self.dbRef.child(self.activeId).removeValue()
            
            
            self.dbRefEmployee.child(self.employeeIDToS).child("myEmployers").updateChildValues([(self.employerIDToS):5])
            self.dbRefEmployer.child(self.employerIDToS).updateChildValues(["finProcess" : ""])
            self.navigationController!.popViewController(animated: true)

        }
        
        alertController4.addAction(OKAction)
        self.present(alertController4, animated: true, completion: nil)
    }//end of logic alert
    
    func alert50(){
        let alertController50 = UIAlertController(title: ("Internet Connection") , message: " There is no internet - Check communication avilability.", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
        }
        
        alertController50.addAction(OKAction)
        self.present(alertController50, animated: true, completion: nil)
    }
    
}/////////////end!!!!!////////////////////////////////////////////////////////////////////////////////////////////////
