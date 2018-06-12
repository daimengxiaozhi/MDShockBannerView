//
//  ViewController.swift
//  MDShockAnimate
//
//  Created by Alan on 2018/4/17.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIScrollViewDelegate,MDShockBannerViewDelegate {
    

    var banner:MDShockBannerView?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        banner?.adjustWhenControllerViewWillAppera()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        banner = MDShockBannerView.init(frame: CGRect(x: 0, y: 0, width: mainW, height: mainW * 47 / 75))
        banner?.selectImage = #imageLiteral(resourceName: "home_banner_select")
        banner?.unselectImage = #imageLiteral(resourceName: "home_banner_unselect")
        banner?.delegate = self

        self.view.addSubview(banner!)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.5) {
            self.setBanner()
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func setBanner(){
        let model1 = MDBannerModel()
        model1.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/6265b5b9bf8686f009cf44c366cfa4abd26b1a79.png"
        model1.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png"
        
        
        let model2 = MDBannerModel()
        model2.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/16f7ab6124ae4688f0adef43ff3ab3b1f09ccc67.png"
        model2.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png"
        
        let model3 = MDBannerModel()
        model3.img = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180605/5f9c08df32dc9ef8bc477a1d0ba33c47b6977df9.png"
        model3.bgImg = "http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180605/a14b5d38137e33e765f6f5174aa99f59b2c285cf.png"
        
        banner?.setBanner(banners: [model1,model2,model3])

    }
    
    
    func clickBanner(index: Int) {
        print(index)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

