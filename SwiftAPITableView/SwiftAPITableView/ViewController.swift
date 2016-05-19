//
//  ViewController.swift
//  SwiftAPITableView
//
//  Created by Bereket Ghebremedhin on 5/19/16.
//  Copyright © 2016 Bereket Ghebremedhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var json_data_url = "http://www.kaleidosblog.com/tutorial/json_table_view_images.json"
    var image_base_url = "http://www.kaleidosblog.com/tutorial/"
    
    
    var TableData:Array< datastruct > = Array < datastruct >()
    
    enum ErrorHandler:ErrorType
    {
        case ErrorFetchingResults
    }
    
    
    struct datastruct
    {
        var imageurl:String?
        var description:String?
        var image:UIImage? = nil
        
        init(add: NSDictionary)
        {
            imageurl = add["url"] as? String
            description = add["description"] as? String
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        get_data_from_url(json_data_url)

        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let data = TableData[indexPath.row]
        
        
        cell.textLabel?.text = data.description
        
        if (data.image == nil)
        {
            cell.imageView?.image = UIImage(named:"image.jpg")
            load_image(image_base_url + data.imageurl!, imageview: cell.imageView!, index: indexPath.row)
        }
        else
        {
            cell.imageView?.image = TableData[indexPath.row].image
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return TableData.count
    }
    
    
    
    
    
    
    
    func get_data_from_url(url:String)
    {
        
        
        let url:NSURL = NSURL(string: url)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        
        
        let task = session.dataTaskWithRequest(request) {
            (
            let data, let response, let error) in
            
            guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                self.extract_json(data!)
                return
            })
            
        }
        
        task.resume()
        
    }
    
    
    func extract_json(jsonData:NSData)
    {
        let json: AnyObject?
        do {
            json = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
        } catch {
            json = nil
            return
        }
        
        if let list = json as? NSArray
        {
            for (var i = 0; i < list.count ; i++ )
            {
                if let data_block = list[i] as? NSDictionary
                {
                    
                    TableData.append(datastruct(add: data_block))
                }
            }
            
            do
            {
            }
            catch
            {
                print("woops")
            }
            
            do_table_refresh()
            
        }
        
        
    }
    
    
    
    
    func do_table_refresh()
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
            return
        })
    }
    
    
    func load_image(urlString:String, imageview:UIImageView, index:NSInteger)
    {
        
        let url:NSURL = NSURL(string: urlString)!
        let session = NSURLSession.sharedSession()
        
        let task = session.downloadTaskWithURL(url) {
            (
            let location, let response, let error) in
            
            guard let _:NSURL = location, let _:NSURLResponse = response  where error == nil else {
                print("error")
                return
            }
            
            let imageData = NSData(contentsOfURL: location!)
            
            dispatch_async(dispatch_get_main_queue(), {
                
                
                self.TableData[index].image = UIImage(data: imageData!)
                
                imageview.image = self.TableData[index].image
                return
            })
            
            
        }
        
        task.resume()
        
        
    }
    
    
    
    


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
