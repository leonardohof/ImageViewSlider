//
//  ViewController.swift
//  ImageViewSliderDemo
//
//  Created by Leonardo Hofling on 15/06/15.
//  Copyright (c) 2015 Leonardo Hofling. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageViewSlider: ImageViewSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.imageViewSlider = ImageViewSlider(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        self.imageViewSlider.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageViewSlider.addImage(UIImage(named: "example-1.jpg")!)
        self.imageViewSlider.addImage(UIImage(named: "example-2.jpg")!)
        self.imageViewSlider.addImage(UIImage(named: "example-3.jpg")!)
        
        self.view.addSubview(self.imageViewSlider)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

