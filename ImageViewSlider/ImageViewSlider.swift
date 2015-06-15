//
//  ImageViewSlider.swift
//  ImageViewSliderDemo
//
//  Created by Leonardo Hofling on 15/06/15.
//  Copyright (c) 2015 Leonardo Hofling. All rights reserved.
//

import UIKit

public class ImageViewSlider: UIView, UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var images: NSMutableArray = NSMutableArray()
    var imagesCtrl = NSMutableArray()
    
    var pageControlUsed: Bool = true
    
    public init() {
        super.init(frame: CGRectZero)
        
        self.applyDefaults()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.applyDefaults()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.applyDefaults()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.contentSize = CGSizeMake(self.bounds.width * CGFloat(self.images.count), self.bounds.height)
        self.scrollView.contentOffset = CGPointMake(self.bounds.width * CGFloat(pageControl.currentPage), 0)
    }
    
    func applyDefaults() {
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth|UIViewAutoresizing.FlexibleHeight
        self.layoutMargins = UIEdgeInsetsZero
        
        self.images = []
        self.imagesCtrl = []
        
        self.scrollView = UIScrollView(frame: CGRectZero) //CGRectMake(0, 0, self.frame.width, self.frame.height)
        //self.scrollView.backgroundColor = UIColor.redColor()
        self.addSubview(self.scrollView)
        
        self.pageControl = UIPageControl(frame: CGRectMake(0, 0, 100, 16))
        self.pageControl.addTarget(self, action: Selector("changePage"), forControlEvents: UIControlEvents.ValueChanged)
        self.addSubview(self.pageControl)
        
        self.pageControl.numberOfPages = self.images.count
        self.pageControl.currentPage = 0

        var pages = self.images.count
        
        self.scrollView.delegate = self
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.scrollsToTop = false
        self.scrollView.scrollEnabled = true
        self.scrollView.pagingEnabled = true
        
        /* Contrainsts */
        
        scrollView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: self, attribute: .Left, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Width, relatedBy: .Equal, toItem: self, attribute: .Width, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 1, constant: 0))
        
        pageControl.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
    }
    
    func changePage() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.scrollView.contentOffset = CGPointMake(self.bounds.width * CGFloat(self.pageControl.currentPage), 0)
        })
    }
    
    func clearImages() {
        
        if self.images.count > 0 {
            
            for ind in 0...self.images.count-1 {
                var imgView = (self.imagesCtrl[ind] as! UIImageView)
                imgView.removeFromSuperview()
            }
            
            self.images.removeAllObjects()
            self.imagesCtrl.removeAllObjects()
            
            self.pageControl.numberOfPages = self.images.count
            self.layoutIfNeeded()
            
        }
    }
    
    func addImage(image: UIImage) {
        
        self.images.addObject(image)
        self.pageControl.numberOfPages = self.images.count
        
        var page = self.images.count - 1
        
        var imgView = UIImageView(frame: CGRectZero)
        imgView.image = image
        imgView.clipsToBounds = true
        imgView.contentMode = self.contentMode
        
        self.scrollView.addSubview(imgView)
        self.imagesCtrl.addObject(imgView)
        
        self.pageControl.hidden = self.pageControl.numberOfPages <= 1

        
        imgView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Top, relatedBy: .Equal, toItem: scrollView, attribute: .Top, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Width, relatedBy: .Equal, toItem: scrollView, attribute: .Width, multiplier: 1, constant: 0))
        scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Height, relatedBy: .Equal, toItem: scrollView, attribute: .Height, multiplier: 1, constant: 0))
        
        if self.images.count == 1 {
            
            scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Left, relatedBy: .Equal, toItem: scrollView, attribute: .Left, multiplier: 1, constant: 0))
            
        } else {
            scrollView.addConstraint(NSLayoutConstraint(item: imgView, attribute: .Left, relatedBy: .Equal, toItem: self.imagesCtrl[self.images.count-2], attribute: .Right, multiplier: 1, constant: 0))
        }
        
        if page == 0 {
            changePage()
        }
        
        self.updateConstraints()
        self.layoutIfNeeded()
        
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if(pageControlUsed) {
            return
        }
        
        var pageWidth = scrollView.frame.size.width;
        var page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
        if page >= 0 && page <= pageControl.numberOfPages {
            
            pageControl.currentPage = page
            self.scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, 0)
            
        }
    }
    
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControlUsed = false
    }
    
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        pageControlUsed = false
    }
    
}

