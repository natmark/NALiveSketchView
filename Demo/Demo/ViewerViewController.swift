//
//  ViewerViewController.swift
//  Demo
//
//  Created by AtsuyaSato on 2017/04/23.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class ViewerViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else {
            return
        }
        imageView.image = image
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
