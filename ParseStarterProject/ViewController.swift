//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.

// This is SARAH'S COPY OF THE PROJECT!!!!

import UIKit
import Parse

class ViewController: UIViewController {
  
//  buffer constants
  let kTrailingImageViewConstraintBuffer: CGFloat = 40
  let kLeadingImageViewConstraintBuffer: CGFloat = -40
  let kTopImageViewConstraintBuffer: CGFloat = 40
  let kBottonImageViewConstraintBuffer: CGFloat = 70
  let kBottomCollectionViewConstraintBuffer: CGFloat = 8
  let kThumbnailSize = CGSize(width: 45, height: 45)


//all outlets
  @IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottonImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var snapShot: UIImageView!
  @IBOutlet weak var alertButton: UIButton!
  @IBOutlet weak var collectionView: UICollectionView!
 
  let picker: UIImagePickerController = UIImagePickerController()
  
  var filters : [(UIImage, CIContext) -> (UIImage!)] = [FilterService.sepiaImageFromOriginalImage, FilterService.tonalImageFromOriginalImage, FilterService.chromeImageFromOriginalImage, FilterService.sepiaImageFromOriginalImage, FilterService.tonalImageFromOriginalImage, FilterService.chromeImageFromOriginalImage]
  
  let context = CIContext(options: nil)
  
//  let options = [kCIContextWorkingColorSpace : NSNull()]
//  let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
//  let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
//  
  var thumbnail : UIImage?
  
  let alert = UIAlertController(title: "camera clicked", message: "the camera was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)
  
  var displayImage : UIImage! {
    didSet {
      snapShot.image = displayImage
      thumbnail = ImageResizer.resizeImage(displayImage, size:kThumbnailSize)
      collectionView.reloadData()
    }
  }

    override func viewDidLoad() {
        super.viewDidLoad()
      
      title = "Snap Shot"
      collectionView.dataSource = self
      displayImage = UIImage(named: "flatLandPic.jpg")
      
      if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
        
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        println("alert cancelled")
      }
      
      let collectionAction = UIAlertAction(title: "Photo Collection", style: UIAlertActionStyle.Default) { (alert) -> Void in
        self.presentViewController(self.picker, animated: true, completion: nil)
        println("phot album clicked")
      }
      
      if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
        let cameraAction = UIAlertAction(title: "Take a Picture", style: UIAlertActionStyle.Default) { (alert) -> Void in
        }
        alert.addAction(cameraAction)
      }
      
      
      if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
          
        let filterAction = UIAlertAction(title: "Filter", style: UIAlertActionStyle.Default) { (alert) -> Void in
          self.enterFilterMode()
        }
        alert.addAction(filterAction)
      }
      
      let uploadAction = UIAlertAction(title: "Upload", style: UIAlertActionStyle.Default) { (alert) -> Void in
        
        let post = PFObject(className: "Post")
        post["text"] = "post description"
        
        if let image = self.snapShot.image,
          data = UIImageJPEGRepresentation(image, 1.0)
        {
          let file = PFFile(name: "post.jpeg", data: data)
          post["image"] = file
        }
        
        post.saveInBackgroundWithBlock({ (succeeded, error) -> Void in
          
        })
      }
      
      alert.addAction(cancelAction)
      alert.addAction(collectionAction)
      alert.addAction(uploadAction)

      
      self.picker.delegate = self
      self.picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  
  @IBAction func buttonPressed(sender: AnyObject) {
    
    alert.modalPresentationStyle = UIModalPresentationStyle.Popover
    
    if let popover = alert.popoverPresentationController {
      popover.sourceView = view
      popover.sourceRect = alertButton.frame
    }
    self.presentViewController(alert, animated: true, completion: nil)
    
  }
  
  func enterFilterMode() {
    leadingImageViewConstraint.constant = kLeadingImageViewConstraintBuffer
    trailingImageViewConstraint.constant = kTrailingImageViewConstraintBuffer
    topImageViewConstraint.constant = kTopImageViewConstraintBuffer
    bottonImageViewConstraint.constant = kBottonImageViewConstraintBuffer
    bottomCollectionViewConstraint.constant = kBottomCollectionViewConstraintBuffer
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode() {
    leadingImageViewConstraint.constant = kLeadingImageViewConstraintBuffer - 40
    trailingImageViewConstraint.constant = kTrailingImageViewConstraintBuffer + 40
    topImageViewConstraint.constant = kTopImageViewConstraintBuffer - 40
    bottonImageViewConstraint.constant = kBottonImageViewConstraintBuffer - 70
    bottomCollectionViewConstraint.constant = kBottomCollectionViewConstraintBuffer - 100

    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
}

//*** Image Picker Extension below ***
extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    displayImage = image
    self.picker.dismissViewControllerAnimated(true, completion:nil)

  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion:nil)
    println("Picker was cancelled")
  }
}

//*** Collection view functionality below ***
extension ViewController : UICollectionViewDataSource {
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return filters.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ThumbnailCell", forIndexPath: indexPath) as! ThumbnailCell
    
    let filter = filters[indexPath.row]
    if let thumbnail = thumbnail {
      let filteredImage = filter(thumbnail, context)
      cell.thumbnailImage.image = filteredImage
      }
    
    
    return cell
  }
}



