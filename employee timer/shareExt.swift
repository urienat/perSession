//
//  shareExt.swift
//  perSession
//
//  Created by uri enat on 30/01/2018.
//  Copyright © 2018 אורי עינת. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI

extension(UIViewController){

    func pdfDataWithTableView(tableView: UITableView) -> NSMutableData {
        let frameRect = CGRect(x: 72, y: 72, width: 468, height: 600);
        let imageRect = CGRect(x: 500, y: 660, width: 100, height: 100);
        let paperA4 = CGRect(x: 0, y: 0, width: 712, height: 992);
        let pageWithMargin = CGRect(x: 0, y: -50, width: paperA4.width-50, height: (paperA4.height-50));
        let paperRect = CGRect(x: 30, y: 30, width: 512, height:(781.8))
        /////////
        let priorBounds = tableView.bounds
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:frameRect.width, height:frameRect
            .height)
        let pdfDataTable = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfDataTable, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("myDocument.pdf")
        pdfDataTable.write(to: docURL as URL, atomically: true)
        
        return pdfDataTable
    }

    
    ////////////alerts/////////////////////////////////////
    
    func alert101(printItem:NSMutableData){
        let alertController5 = UIAlertController(title: ("Share") , message: "", preferredStyle: .alert)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            //do nothing
        }
        /*
         let mailAction = UIAlertAction(title: "Mail", style: .default) { (UIAlertAction) in
         let mailComposeViewController1 = configuredMailComposeViewController2()
         if MFMailComposeViewController.canSendMail() {
         self.present(mailComposeViewController1, animated: true, completion: nil)
         } //end of if
         else{ //self.showSendmailErrorAlert()
         
         }
         // navigationController!.popViewController(animated: true)
         }
         */
        let printAction = UIAlertAction(title: "Print", style: .default) { (UIAlertAction) in
            let printInfo = UIPrintInfo(dictionary:nil)
            printInfo.outputType = UIPrintInfoOutputType.general
            printInfo.jobName = "My Print Job"
            
            let printController = UIPrintInteractionController.shared
            printController.printInfo = printInfo
            printController.printingItem =  printItem
            
            
            //var viewpf:UIViewPrintFormatter = self.documentsFileName.viewPrintFormatter()
            // var viewpf:UIViewPrintFormatter = self.billerConnect.viewPrintFormatter()
            //printController.printFormatter = viewpf
            printController.present(animated: true) { (controller, success, error) -> Void in
                if success {
                    // Printed successfully
                    
                    self.navigationController!.popViewController(animated: true)
                    
                    
                } else {
                    // Printing failed, report error ...
                }
            }//end of present
            
        }
        
        //alertController5.addAction(mailAction)
        alertController5.addAction(printAction)
        alertController5.addAction(CancelAction)
        self.present(alertController5, animated: true, completion: nil)
    }
}//end of ext

