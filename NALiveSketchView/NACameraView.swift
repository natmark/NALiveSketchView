//
//  CameraView.swift
//  ARCamera
//
//  Created by AtsuyaSato on 2017/03/07.
//  Copyright © 2017年 Atsuya Sato. All rights reserved.
//

import UIKit
import AVFoundation

public class NACameraView: UIView, AVCaptureVideoDataOutputSampleBufferDelegate, UIGestureRecognizerDelegate {
    private var input:AVCaptureDeviceInput!
    private var imageOutput: AVCaptureStillImageOutput!
    private var session:AVCaptureSession!
    private var camera:AVCaptureDevice!

    public init() {
        super.init(frame: CGRect.zero)
        setupCamera()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupCamera()
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupCamera()
    }
    public func startCapturing(){
        session.startRunning()
    }
    public func stopCapturing(){
        session.stopRunning()
    }
    private func setupCamera(){
        session = AVCaptureSession()

        session.beginConfiguration()
        session.sessionPreset = AVCaptureSessionPresetHigh
        session.commitConfiguration()

        let devices = AVCaptureDevice.devices()

        for device in devices! {
            if((device as AnyObject).position == .back){
                camera = device as! AVCaptureDevice
            }
        }

        do {
            input = try AVCaptureDeviceInput(device: camera) as AVCaptureDeviceInput
        } catch let error as NSError {
            print(error)
        }

        if(session.canAddInput(input)) {
            session.addInput(input)
        }

        imageOutput = AVCaptureStillImageOutput()
        
        if(session.canAddOutput(imageOutput)) {
            session.addOutput(imageOutput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer?.frame = self.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(previewLayer!)

        session.startRunning()

        do {
            try camera.lockForConfiguration()
            camera.activeVideoMinFrameDuration = CMTimeMake(1, 30)
            camera.unlockForConfiguration()
        } catch _ {
        }
    }
    public func takePhoto(completionHandler: @escaping (_ image: UIImage) -> ()){
        let output:AVCaptureStillImageOutput! = imageOutput
        if let connection:AVCaptureConnection? = output.connection(withMediaType: AVMediaTypeVideo) {
            connection?.videoOrientation = AVCaptureVideoOrientation.portrait

            output.captureStillImageAsynchronously(from: connection,
                                                   completionHandler: {
                                                    (imageDataBuffer, error) -> Void in
                                                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataBuffer)
                                                    let image = UIImage(data: imageData!)!
                                                    let fixed_image = self.fixImageOrientation(image: image)
                                                    completionHandler(fixed_image!)
            })
        }
    }
    private func fixImageOrientation(image: UIImage) -> UIImage? {
        if image.imageOrientation == .up {
            return image
        }
        var transform = CGAffineTransform.identity

        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: .pi / 2.0)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(.pi / 2.0))
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: -CGFloat(.pi / 2.0))
        default:
            break
        }

        switch image.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue) else {
            return nil
        }

        context.concatenate(transform)

        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            context.draw(image.cgImage!, in: CGRect(origin: .zero, size: image.size))
        }

        // And now we just create a new UIImage from the drawing context
        guard let CGImage = context.makeImage() else {
            return nil
        }

        return UIImage(cgImage: CGImage)
    }
    private func captureImage(sampleBuffer:CMSampleBuffer) -> UIImage{
        let imageBuffer:CVImageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags(rawValue: 0))

        let baseAddress:UnsafeMutableRawPointer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer, 0)!

        let bytesPerRow:Int = CVPixelBufferGetBytesPerRow(imageBuffer)
        let width:Int = CVPixelBufferGetWidth(imageBuffer)
        let height:Int = CVPixelBufferGetHeight(imageBuffer)

        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()

        let newContext:CGContext = CGContext(data: baseAddress, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace,  bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue|CGBitmapInfo.byteOrder32Little.rawValue)!

        let imageRef:CGImage = newContext.makeImage()!
        let resultImage = UIImage(cgImage: imageRef, scale: 1.0, orientation: UIImageOrientation.right)

        return resultImage
    }
}
