//
//  PhotoFeedViewController.swift
//  ParseStarterProject
//
//  Created by Sarah Hermanns on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PhotoFeedViewController: UIViewController {
  
  var posts = [PFObject]()
  
  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    tableView.estimatedRowHeight = 70
    tableView.rowHeight = UITableViewAutomaticDimension
    
    tableView.registerNib(UINib(nibName: "Cell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "PostCell")
    

    tableView.dataSource = self
    tableView.delegate = self
    
  }
  
  override func viewDidAppear(animated: Bool) {
    let query = PFQuery(className: "Post")
    
    query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
      if let error = error {
        println(error.localizedDescription)
      } else if let posts = results as? [PFObject] {
        println(posts.count)
        self.posts = posts
        self.tableView.reloadData()
      }
    }
    
  }
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
}

extension PhotoFeedViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
    var post = posts[indexPath.row]
    
    if let postDescription = post["text"] as? String {
      cell.snapShotDescription.text = postDescription
    }
    
    if let imageFile = post["image"] as? PFFile {
      imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
        if let  error = error {
          println(error.localizedDescription)
        } else if let data = data, image = UIImage(data: data){
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
              cell.snapShot.image = image
          })
          }
        })
    
    }
  
  return cell
  }

}