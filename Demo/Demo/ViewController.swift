//
//  ViewController.swift
//  Demo
//
//  Created by AtsuyaSato on 2017/04/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var liveSketchView: NALiveSketchView!

    override func viewDidLoad() {
        super.viewDidLoad()
        liveSketchView.drawableView.penColor = UIColor(hue: 0.5, saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    @IBAction func switchPenMode(_ sender: UIButton) {
        if liveSketchView.drawableView.penMode == .pen {
            liveSketchView.drawableView.penMode = .eraser
            sender.setImage(UIImage(named: "btn_eraser"), for: .normal)
        }else{
            liveSketchView.drawableView.penMode = .pen
            sender.setImage(UIImage(named: "btn_pencil"), for: .normal)
        }
    }
    @IBAction func changeColor(_ sender: UISlider) {
        liveSketchView.drawableView.penColor = UIColor(hue: CGFloat(sender.value), saturation: 1.0, brightness: 1.0, alpha: 1.0)
    }
    @IBAction func takeSketchPhoto(_ sender: Any) {
        liveSketchView.takeSketchPhoto(completionHandler: { image in
            let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let nextView = mainStoryboard.instantiateViewController(withIdentifier: "ViewerViewController") as! ViewerViewController
            nextView.image = image
            self.navigationController?.pushViewController(nextView, animated: true)
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

