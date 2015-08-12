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
  
//  var posts = [Post]()
  
  @IBOutlet weak var tableView: UITableView!
  
  
//  @IBOutlet weak var tableView: UITableView!
//  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
      
//      tableView.estimatedRowHeight = 70
//      tableView.rowHeight = UITableViewAutomaticDimension
//      
//      tableView.registerNib(UINib(nibName: "PostCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "PostCell")

      let query = PFQuery(className: "Post")
      
      query.findObjectsInBackgroundWithBlock { (results, error) -> Void in
        if let error = error {
          println(error.localizedDescription)
        } else if let posts = results as? [PFObject] {
          println(posts.count)
          for post in posts {
            if let imageFile = post["image"] as? PFFile {
              imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                if let error = error {
                  println(error.localizedDescription)
                } else if let data = data,
                  image = UIImage(data: data){
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                      let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
                      self.view.addSubview(imageView)
                      imageView.image = image
                    })
                }
              })
            }
          }
        }
      }
//      tableView.dataSource = self
//      tableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

//  extension PhotoFeedViewController : UITableViewDataSource, UITableViewDelegate {
//  
//  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return posts.count
//}
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//      let cell = tableView.dequeueReusableCellWithIdentifier("PostCell", forIndexPath: indexPath) as! PostCell
//      cell.tag++
//      let tag = cell.tag
//      var post = posts[indexPath.row]
//      cell.snapShot.image = nil
//      cell.snapShotDescription.text = post.snapShotDescription
//      
//      if let snapShot = post.snapShot {
//        cell.snapShot.image = snapShot
//      }else {
//        imageQueue.addOperationWithBlock({ () -> Void in
//          if let imageData = NSData(contentsOfURL: imageURL),
//            image = UIImage(data: imageData) {
//              var size : CGSize
//              switch UIScreen.mainScreen().scale {
//              case 2:
//                size = CGSize(width: 140, height: 140)
//              case 3:
//                size = CGSize(width: 210, height: 210)
//              default:
//                size = CGSize(width: 70, height: 70)
//                
//              }
//              let resizedImage = ImageResizer.resizeImage(image, size: size)
//              
//              NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
//                post.snapShot = resizedImage
//                self.posts[indexPath.row] = post
//                if cell.tag == tag {
//                  cell.snapShot.image = resizedImage
//                }
//              })
//          }
//        })
//      }
//}
//}