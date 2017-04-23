//
//  LiveSketchView.swift
//  NALiveSketchView
//
//  Created by AtsuyaSato on 2017/04/17.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import Foundation
import UIKit

public class NALiveSketchView : UIView {
    private lazy var cameraView : NACameraView = {
        return NACameraView(frame: self.frame)
    }()
    public lazy var drawableView : NADrawableView = {
        return NADrawableView(frame: self.frame)
    }()
    public override var frame: CGRect{
        didSet{
            cameraView.frame = frame
            drawableView.frame = frame
        }
    }
    public init() {
        super.init(frame: CGRect.zero)
        initialize()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    private func initialize(){
        cameraView.isUserInteractionEnabled = true
        drawableView.isUserInteractionEnabled = true
        self.addSubview(cameraView)
        self.addSubview(drawableView)
    }
    public func takeSketchPhoto(completionHandler: @escaping (_ image: UIImage) -> ()){
        cameraView.takePhoto(completionHandler: { photoImage in
            guard let sketchImage = self.drawableView.image else{
                completionHandler(photoImage)
                return
            }

            //combine image
            let photoRect:(width:Int,height:Int) = ((photoImage.cgImage?.width)!,(photoImage.cgImage?.height)!)

            UIGraphicsBeginImageContext(CGSize(width: photoRect.width, height: photoRect.height))
            photoImage.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))
            sketchImage.draw(in: CGRect(x: 0, y: 0, width: photoRect.width, height: photoRect.height))

            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completionHandler(combinedImage!)
        })
    }
}
