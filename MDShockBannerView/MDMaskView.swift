//
//  MDMaskView.swift
//  MDShockAnimate
//
//  Created by Alan on 2018/4/17.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit

enum MDBannerSrollDirection {
    case unknow
    case left
    case right
}

class MDMaskView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    var maskRadius:CGFloat = 0
    var direction:MDBannerSrollDirection = .unknow
    func setRadius(radius:CGFloat,direction:MDBannerSrollDirection){
        self.maskRadius = radius
        self.direction = direction
        if self.direction != .unknow{
            self.setNeedsDisplay()
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        self.backgroundColor = .clear
        if direction != .unknow{
            let ctx = UIGraphicsGetCurrentContext()
            if direction == .left{
                ctx?.addArc(center: CGPoint(x: self.center.x + rect.width/2, y: self.center.y), radius: maskRadius, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            }else{
                ctx?.addArc(center: CGPoint(x: self.center.x - rect.width/2, y: self.center.y), radius: maskRadius, startAngle: 0, endAngle: .pi * 2, clockwise: false)
            }
            ctx?.setFillColor(UIColor.white.cgColor)
            ctx?.fillPath()
        }
    }

}
