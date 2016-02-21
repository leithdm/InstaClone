//
//  PostImageViewController.swift
//  ParseStarterProject
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
	
	@IBOutlet var message: UITextField!
	@IBOutlet var imageToPost: UIImageView!
	var activityIndicator = UIActivityIndicatorView()
	
	func displayAlert(title: String, message: String) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
		alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
			self.dismissViewControllerAnimated(true, completion: nil)
		})))
		self.presentViewController(alert, animated: true, completion: nil)
	}
	
	@IBAction func chooseImage(sender: AnyObject) {
		
		let image = UIImagePickerController()
		image.delegate = self
		image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
		image.allowsEditing = false
		
		self.presentViewController(image, animated: true, completion: nil)
		
	}
	
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		self.dismissViewControllerAnimated(true, completion:nil)
		imageToPost.image = image
		
	}
	
	@IBAction func postImage(sender: AnyObject) {
		activityIndicator = UIActivityIndicatorView(frame: self.view.frame)
		activityIndicator.backgroundColor = UIColor(white: 1.0, alpha: 0.5)
		activityIndicator.center = self.view.center
		activityIndicator.hidesWhenStopped = true
		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
		view.addSubview(activityIndicator)
		activityIndicator.startAnimating()
		
		UIApplication.sharedApplication().beginIgnoringInteractionEvents()
		
		let post = PFObject(className: "Post")
		post["message"] = message.text
		post["userId"] = PFUser.currentUser()!.objectId!
		let imageData = UIImagePNGRepresentation(imageToPost.image!)
		let imageFile = PFFile(name: "image.png", data: imageData!)
		post["imageFile"] = imageFile
		post.saveInBackgroundWithBlock{(success, error) -> Void in
			self.activityIndicator.stopAnimating()
			UIApplication.sharedApplication().endIgnoringInteractionEvents()
			
			if error == nil {
				self.displayAlert("Image Posted!", message: "Your image has been posted successfully")
				self.imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg.png")
				self.message.text = ""
				
			} else {
				self.displayAlert("Could not post image", message: "Please try again later")
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
}
