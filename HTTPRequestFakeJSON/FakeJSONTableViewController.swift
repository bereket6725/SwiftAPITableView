//
//  FakeJSONTableViewController.swift
//  HTTPRequestFakeJSON
//
//  Created by Bereket Ghebremedhin on 5/26/16.
//  Copyright © 2016 Bereket Ghebremedhin. All rights reserved.
//

import UIKit
//import DetailImageViewController




class FakeJSONTableViewController: UITableViewController {

    var urlString: String = "http://jsonplaceholder.typicode.com/photos"
    var bodyArray:[String] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let URL = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        
        sendHTTPRequest(request)
        

    }
    
    
    
    func sendHTTPRequest(let request:NSMutableURLRequest) {
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
           // let responseString = NSString(data: data! , encoding: NSUTF8StringEncoding)
            self.convertJSONintoDict(data!)

            
           // print("responseString = \(responseString)")

         
//            do {
//                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
//                    
//                    // Print out dictionary
//                    print(convertedJsonIntoDict)
////                    
////                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
////                    print(firstNameValue!)
//                    
//                }
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
           }
//        
       task.resume()
            
            
//        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func convertJSONintoDict(data: NSData){
        
        do {
        if let convertedJsonIntoArr = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSArray {
            
            for dict in convertedJsonIntoArr {
                self.bodyArray.append(dict["thumbnailUrl"] as! String)
                //self.bodyArray.append(convertedJsonIntoDict["body"] as! String)
                self.tableView.reloadData()
            }
            print(self.bodyArray)
            
        }
        
    } catch let error as NSError{
        print(error.localizedDescription)
        }
    }
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.bodyArray.count 
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //NSData* imgData =
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        //let URL = NSURL(string: self.imageLinkArray[indexPath.row])
        let imageURL = NSURL(string: self.bodyArray[indexPath.row])
        
        let image = UIImage(data: NSData(contentsOfURL:imageURL!)!)
       
        cell.imageView?.image = image 
        cell.textLabel!.text = self.bodyArray[indexPath.row]
    
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        
        
        
    }


}
