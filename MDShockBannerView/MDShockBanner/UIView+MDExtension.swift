//
//  UIView+MDExtension.swift
//  MDStarCircle
//
//  Created by Alan on 2018/2/5.
//

import UIKit

extension UIView {
    
    var x : CGFloat {
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.origin.x
        }
    }
    
    var y : CGFloat {
        set {
            var frame = self.frame
            frame.origin.y = y
            self.frame = frame
        }
        
        get {
            return self.frame.origin.y
        }
    }
    
    var width : CGFloat {
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.width
        }
    }
    
    var height : CGFloat {
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
        
        get {
            return self.frame.size.height
        }
    }
    
    var size : CGSize {
        set {
            var frame = self.frame
            frame.size = size
            self.frame = frame
        }
        
        get {
            return self.frame.size
        }
    }
    
    var centerX : CGFloat {
        set {
            var center = self.center
            center.x = newValue
            self.center = center
        }
        
        get {
            return self.center.x
        }
    }
    
    var centerY : CGFloat {
        set {
            var center = self.center
            center.y = centerY
            self.center = center
        }
        
        get {
            return self.center.y
        }
    }
    
    func borderWidth(borderWidth:CGFloat) {
        if (borderWidth < 0) {
            return
        }
        self.layer.borderWidth = borderWidth
    }
    
    func borderColor(borderColor:CGColor) {
        self.layer.borderColor = borderColor
    }
    
    var cornerRadius : CGFloat {
        set {
            self.layer.cornerRadius = newValue;
            self.layer.masksToBounds = true;
        }
        
        get {
            return self.layer.cornerRadius
        }
    }
}
