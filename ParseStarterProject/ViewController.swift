//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.

// This is SARAH'S COPY OF THE PROJECT1!!!!

import UIKit
import Parse

class ViewController: UIViewController {

  @IBOutlet weak var trailingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var leadingImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottonImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var topImageViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var bottomCollectionViewConstraint: NSLayoutConstraint!
  @IBOutlet weak var snapShot: UIImageView!
  @IBOutlet weak var alertButton: UIButton!
  
  let picker: UIImagePickerController = UIImagePickerController()
  
  let alert = UIAlertController(title: "camera clicked", message: "the camera was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
      
      title = "Snap Shot"
      
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
      
      let chromeAction = UIAlertAction(title: "Chrome", style: UIAlertActionStyle.Default) { (alert) -> Void in
        
        let baseImage = self.snapShot.image
        let x = baseImage!.size.width / 2
        let y = baseImage!.size.height / 2
        
        let sizeForResizing = CGSize(width: x, height: y)
        let newImage = ImageResizer.resizeImage(baseImage!, size: sizeForResizing)
        let image = CIImage(image: self.snapShot.image!)
        let chromeFilter = CIFilter(name: "CIPhotoEffectChrome")
        chromeFilter.setValue(image, forKey: kCIInputImageKey)
        
        let context = CIContext(options: nil)
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        let outputImage = chromeFilter.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.snapShot.image = finalImage
        
      }
      
      let tonalAction = UIAlertAction(title: "Tonal", style: UIAlertActionStyle.Default) { (alert) -> Void in
        let baseImage = self.snapShot.image
        let x = baseImage!.size.width / 2
        let y = baseImage!.size.height / 2
        
        let sizeForResizing = CGSize(width: x, height: y)
        let newImage = ImageResizer.resizeImage(baseImage!, size: sizeForResizing)
        let image = CIImage(image: self.snapShot.image!)
        let tonalFilter = CIFilter(name: "CIPhotoEffectTonal")
        tonalFilter.setValue(image, forKey: kCIInputImageKey)
        
        let context = CIContext(options: nil)
        
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        let outputImage = tonalFilter.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.snapShot.image = finalImage

      }
      
      let sepiaAction = UIAlertAction(title: "Sepia", style: UIAlertActionStyle.Default) { (alert) -> Void in
        let baseImage = self.snapShot.image
        let x = baseImage!.size.width / 2
        let y = baseImage!.size.height / 2
        
        let sizeForResizing = CGSize(width: x, height: y)
        let newImage = ImageResizer.resizeImage(baseImage!, size: sizeForResizing)
        let image = CIImage(image: newImage)
        let sepiaFilter = CIFilter(name: "CISepiaTone")
        sepiaFilter.setValue(image, forKey: kCIInputImageKey)

        //cpu context, not as fast as GPU context
        let context = CIContext(options: nil)
        
        //gpu context
        let options = [kCIContextWorkingColorSpace : NSNull()]
        let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
        let gpuContext = CIContext(EAGLContext: eaglContext, options: options)
        
        
        let outputImage = sepiaFilter.outputImage
        let extent = outputImage.extent()
        let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)
        let finalImage = UIImage(CGImage: cgImage)
        self.snapShot.image = finalImage
        
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
    
//      if snapShot.image = image {
//        alert.addAction(sepiaAction)
//        alert.addAction(tonalAction)
//        alert.addAction(chromeAction)
//      }
      
      alert.addAction(cancelAction)
      alert.addAction(collectionAction)
      alert.addAction(uploadAction)
      alert.addAction(chromeAction)
      alert.addAction(tonalAction)
      alert.addAction(sepiaAction)
      
      
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
    leadingImageViewConstraint.constant = 40
    trailingImageViewConstraint.constant = -40
    topImageViewConstraint.constant = 40
    bottonImageViewConstraint.constant = 70
    bottomCollectionViewConstraint.constant = 8
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
    
    let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "closeFilterMode")
    navigationItem.rightBarButtonItem = doneButton
  }
  
  func closeFilterMode() {
    leadingImageViewConstraint.constant = 20
    trailingImageViewConstraint.constant = -20
    topImageViewConstraint.constant = 20
    bottonImageViewConstraint.constant = 40
    bottomCollectionViewConstraint.constant = -100
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.view.layoutIfNeeded()
    })
  }
  
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
    let image: UIImage = (info[UIImagePickerControllerOriginalImage] as? UIImage)!
    self.snapShot.image = image
    self.picker.dismissViewControllerAnimated(true, completion:nil)

  }
  
  func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.picker.dismissViewControllerAnimated(true, completion:nil)
    println("Picker was cancelled")
  }
}



