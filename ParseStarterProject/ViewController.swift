//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.

// This is SARAH'S COPY OF THE PROJECT1!!!!

import UIKit
import Parse

class ViewController: UIViewController {
  
  @IBOutlet weak var snapShot: UIImageView!
  
  @IBOutlet weak var alertButton: UIButton!
  
  let picker: UIImagePickerController = UIImagePickerController()
  
  let alert = UIAlertController(title: "camera clicked", message: "the camera was clicked", preferredStyle: UIAlertControllerStyle.ActionSheet)

    override func viewDidLoad() {
        super.viewDidLoad()
      
      if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
        
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (alert) -> Void in
        println("alert cancelled")
      }
      
      let albumAction = UIAlertAction(title: "Photo Album", style: UIAlertActionStyle.Default) { (alert) -> Void in
        self.presentViewController(self.picker, animated: true, completion: nil)
        println("phot album clicked")
      }
      
      let chromeAction = UIAlertAction(title: "Chrome", style: UIAlertActionStyle.Default) { (alert) -> Void in
       
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
        
        let image = CIImage(image: self.snapShot.image!)
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
      
      alert.addAction(cancelAction)
      alert.addAction(albumAction)
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



