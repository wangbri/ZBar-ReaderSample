//
//  ViewController.swift
//  ReaderSample
//
//  Created by Brian Wang on 3/14/16.
//  Copyright © 2016 wangco. All rights reserved.
//

import UIKit
import ZBarSDK

extension ZBarSymbolSet: SequenceType {
    public func generate() -> NSFastGenerator {
        return NSFastGenerator(self)
    }
}

class ViewController: UIViewController, ZBarReaderDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var ZBarReader: ZBarReaderViewController?

    @IBOutlet weak var resultText: UITextField!
    @IBOutlet weak var resultImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resultText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onScan(sender: AnyObject) {
        
        if (self.ZBarReader == nil) {
            self.ZBarReader = ZBarReaderViewController()
        }
        //self.ZBarReader = ZBarReaderViewController()
        self.ZBarReader?.readerDelegate = self
        self.ZBarReader?.scanner.setSymbology(ZBAR_UPCA, config: ZBAR_CFG_ENABLE, to: 1)
        self.ZBarReader?.readerView.zoom = 1.0
        self.ZBarReader?.modalInPopover = false
        self.ZBarReader?.showsZBarControls = false
        navigationController?.pushViewController(self.ZBarReader!, animated:true)
        

        //reader.supportedOrientationsMask = ZBarOrientationMaskAll //can't get #define to work in swift
        
        /*UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation
        
        if (UIDeviceOrientationLandscapeLeft == orientation) {
            //Rotate 90
            reader.cameraViewTransform = CGAffineTransformMakeRotation (3*M_PI/2.0);
        } else if (UIDeviceOrientationLandscapeRight == orientation) {
            //Rotate 270
            reader.cameraViewTransform = CGAffineTransformMakeRotation (M_PI/2.0);
        }*/
 
        
    }
    
    func imagePickerController(reader: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String: AnyObject]) {
            // ADD: get the decode results
            var results: NSFastEnumeration = info[ZBarReaderControllerResults] as! NSFastEnumeration
            
            var symbolFound : ZBarSymbol?
            
            for symbol in results as! ZBarSymbolSet {
                symbolFound = symbol as? ZBarSymbol
                break
            }
            var resultString = NSString(string: symbolFound!.data)
            self.resultText.text = resultString as String    //set barCode
            self.resultImage.image = info[UIImagePickerControllerOriginalImage] as! UIImage
            
            navigationController?.popViewControllerAnimated(true)
    }
    
    /*deinit {
        self.resultImage = nil
        self.resultText = nil
        //super.dealloc is called automatically
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }*/
}

