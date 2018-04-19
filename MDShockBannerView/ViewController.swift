//
//  ViewController.swift
//  MDShockAnimate
//
//  Created by Alan on 2018/4/17.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,MDShockBannerViewDelegate {
    
    var topImage:UIImageView?
    var bottomImage:UIImageView?
    
    var vMask:UIView?
    
    var letfView:MDMaskView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
            
//        bottomImage = UIImageView.init(frame: CGRect(x: 0, y: 100, width: mainW, height: 200))
//        bottomImage?.image = #imageLiteral(resourceName: "banner2-bg")
//        self.view.addSubview(bottomImage!)
//
//        topImage = UIImageView.init(frame: CGRect(x: 0, y: 100, width: mainW, height: 200))
//        topImage?.image = #imageLiteral(resourceName: "banner1-bg")
//
//        self.view.addSubview(topImage!)
//
//
//
//
//
//
//        vMask = UIView.init(frame: CGRect(x: 0, y: 0, width: mainW, height: 200))
//
////        vMask?.backgroundColor = .white
//        topImage?.mask = vMask
        
       
        let banner = MDShockBannerView.init(frame: CGRect(x: 0, y: 100, width: mainW, height: 300))
        banner.delegate = self
        let model1 = MDBannerModel()
        model1.img = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        model1.bgImg = "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg"
        
        let model2 = MDBannerModel()
        model2.img = "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg"
        model2.bgImg = "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg"

        let model3 = MDBannerModel()
        model3.img = "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        model3.bgImg = "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        
        banner.setBanner(banners: [model1,model2,model3])
        
        self.view.addSubview(banner)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func clickBanner(index: Int) {
        print(index)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

