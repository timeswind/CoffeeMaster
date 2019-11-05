//
//  BuildingDetailViewController.swift
//  CampusWalk
//
//  Created by Mingtian Yang on 11/1/19.
//  Copyright © 2019 Mingtian Yang. All rights reserved.
//

import UIKit

class BuildingDetailViewController: UIViewController, UITextViewDelegate, ImagePickerDelegate {
    
    var scrollView:UIScrollView!
    var imagePicker: ImagePicker!
    var building: Building!
    var customizeImage: UIImage?
    var imageView: UIImageView!
    var buildingDetail: BuildingDetail!
    var descriptionTextview: UITextView!
    var keyboardHeight:CGFloat = 0
    var isKeyboardShow:Bool = false
    
    let mapModel = MapModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = nil
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.setEditing(true, animated: true)
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        print("viewDidLayoutSubviews")
        let size = self.view.bounds.size
        let scrollviewFrame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        self.scrollView = UIScrollView(frame: scrollviewFrame)
        self.scrollView.backgroundColor = .white
        self.scrollView.isScrollEnabled = true
        let buildingNameLabelFrame = CGRect(x: 20, y: 20, width: size.width-40, height: 20)
        let buildingNameLabel = UILabel(frame: buildingNameLabelFrame)
        buildingNameLabel.text = self.building.name
        
        let buildingYearLabelFrame = CGRect(x: 20, y: 50, width: size.width-40, height: 20)
        let buildingYearLabel = UILabel(frame: buildingYearLabelFrame)
        
        if (self.building.year_constructed != 0) {
            buildingYearLabel.text = String(self.building.year_constructed)
        } else {
            buildingYearLabel.text = ""
        }
        
        imageView = UIImageView(frame: CGRect(x: 20, y: 80, width: size.width-40, height: size.width-40))
        
        if let image = self.customizeImage {
            let imageViewFrame = CGRect(x: 20, y: 80, width: size.width-40, height: size.width-40)
            imageView = UIImageView(frame: imageViewFrame)
            imageView.image = image
        } else if let image = self.buildingDetail.customizeImage {
            let imageViewFrame = CGRect(x: 20, y: 80, width: size.width-40, height: size.width-40)
            imageView = UIImageView(frame: imageViewFrame)
            imageView.image = image
        } else if (!self.building.photo.isEmpty) {
            let image = UIImage(named: "\(self.building.photo).jpg")
            let imageViewFrame = CGRect(x: 20, y: 80, width: size.width-40, height: size.width-40)
            imageView = UIImageView(frame: imageViewFrame)
            imageView.image = image
        }
        
        self.scrollView.addSubview(imageView)

        let buttonFrame = CGRect(x: 20, y: 80 + imageView.frame.size.height + 20, width: size.width-40, height: 40)
        let button = UIButton(frame: buttonFrame)
        button.backgroundColor = .black
        button.setTitle("Select Image or Take Photo", for: .normal)
        button.addTarget(self, action: #selector(selectPhoto(sender:)), for: .touchUpInside)

        self.scrollView.addSubview(button)

        let descriptionTextviewFrame = CGRect(x: 20, y: imageView.frame.origin.y  + imageView.frame.size.height + buttonFrame.height + 40, width: size.width-40, height: 40)
        
        self.descriptionTextview = UITextView(frame: descriptionTextviewFrame)
        self.descriptionTextview.delegate = self
        descriptionTextview.font = .systemFont(ofSize: 20)
        descriptionTextview.isScrollEnabled = false
        if (self.buildingDetail.description.isEmpty) {
            descriptionTextview.text = "Enter description here"
            descriptionTextview.textColor = UIColor.lightGray
        } else {
            descriptionTextview.text = self.buildingDetail.description
            descriptionTextview.textColor = UIColor.black
        }
        descriptionTextview.keyboardType = .asciiCapable
        descriptionTextview.keyboardDismissMode = .onDrag
        self.scrollView.addSubview(descriptionTextview)
        
        self.scrollView.addSubview(buildingNameLabel)
        self.scrollView.addSubview(buildingYearLabel)
        

        self.view.addSubview(scrollView)
        self.updateScrollViewConteneSize()
        self.scrollView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    @objc func selectPhoto(sender: UIButton!) {
      self.imagePicker.present(from: sender)
    }
    
    func didSelect(image: UIImage?) {
        if let selectedImage = image {
            self.customizeImage = selectedImage
            self.imageView.image = selectedImage
//            self.view.setNeedsLayout()
//            self.scrollView.setNeedsLayout()
            self.updateBuilding()
        }
    }
    
    func initialize(building: Building, buildingDetail: BuildingDetail) {
        self.building = building
        self.buildingDetail = buildingDetail
        self.customizeImage = buildingDetail.customizeImage
        self.title = building.name
    }
    
    @objc func doneEdit() {
        self.descriptionTextview.resignFirstResponder()
    }
    
    //MARK: Notification Handlers
    @objc func keyboardWillShow(notification:Notification) {
        self.isKeyboardShow = true
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//        let contentInsets =  UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)

        self.keyboardHeight = keyboardSize.height
        self.adjustScrollviewOffesetForDesctiptionViewInput()
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        self.isKeyboardShow = false
        self.updateScrollViewConteneSize()
    }
    
    func adjustScrollviewOffesetForDesctiptionViewInput() {
        // move if keyboard hide input field
        let distanceToBottom = self.scrollView.bounds.size.height - (self.descriptionTextview.frame.origin.y) - (descriptionTextview.frame.size.height) - 80
        let collapseSpace = keyboardHeight - distanceToBottom
        if collapseSpace < 0 {
            // no collapse
            return
        }
        
        // set new offset for scroll view
        UIView.animate(withDuration: 0.3, animations: {
            // scroll to the position above keyboard 10 points
            self.scrollView.contentOffset = CGPoint(x: 0, y: collapseSpace - 40)
        })
    }
    
    //MARK: - TEXTVIEW DELEGDATE
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (self.buildingDetail.description.isEmpty) {
            self.descriptionTextview.text = ""
            self.descriptionTextview.textColor = UIColor.black
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneEdit))
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if (self.descriptionTextview.text.isEmpty) {
            self.descriptionTextview.text = "Enter description here"
            self.descriptionTextview.textColor = UIColor.gray
        }
        self.navigationItem.rightBarButtonItem = nil
        self.updateBuilding()
        
        print(self.scrollView.contentSize)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateScrollViewConteneSize()
        self.adjustScrollviewOffesetForDesctiptionViewInput()
    }
    
    func updateBuilding() {
        if (self.descriptionTextview.text == "Enter description here") {
            self.buildingDetail.description = ""
        } else {
            self.buildingDetail.description = self.descriptionTextview.text
        }
        if (self.customizeImage != nil) {
            self.buildingDetail.customizeImage = self.customizeImage
        }
        mapModel.updateBuildingDetail(building: self.building, newBuildingDetail: self.buildingDetail)
    }
    
    func resizeDescriptionTextView() {
        let size = self.view.bounds.size
        descriptionTextview.sizeToFit()
        let newSize = CGSize(width: size.width - 40, height: descriptionTextview.frame.size.height)
        descriptionTextview.frame = CGRect(origin: descriptionTextview.frame.origin, size: newSize)
    }
    
    func updateScrollViewConteneSize() {
        resizeDescriptionTextView()
        var contentRect = CGRect.zero

        for view in scrollView.subviews {
           contentRect = contentRect.union(view.frame)
        }
        self.scrollView.contentSize = contentRect.size
    }
    

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
