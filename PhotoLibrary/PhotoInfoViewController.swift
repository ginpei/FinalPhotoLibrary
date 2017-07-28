//
//  PhotoInfoViewController.swift
//  PhotoLibrary
//
//  Created by Derrick Park on 2017-07-21.
//  Copyright © 2017 Derrick Park. All rights reserved.
//

import UIKit
import CoreData

class PhotoInfoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var favouriteSwitch: UISwitch!
    let persistentContainer: NSPersistentContainer = {
        let containter = NSPersistentContainer(name: "PhotoLibrary")
        containter.loadPersistentStores { (
            description, error) in
            
            if let error = error {
                print("Error setting up CoreData(\(error)).")
            }
        }
        return containter
    }()
    var photo: Photo! {
        didSet{
            navigationItem.title = photo.title
            favouriteSwitch?.isOn = photo.favourite
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favouriteSwitch.isOn = photo.favourite
        store.fetchImage(for: photo) { (result) in
            switch result {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showTags"?:
            let navController = segue.destination as! UINavigationController
            let tagController = navController.topViewController as! TagsViewController
            
            tagController.store = store
            tagController.photo = photo
        default:
            preconditionFailure("Unexpected Segue Identifier.")
        }
    }
    
    @IBAction func favouriteSwitch_valueChanged(_ sender: UISwitch) {
        photo.favourite = sender.isOn
        
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("ERROR", error)
        }
    }
}
