


//
//  MDShockBannerView.swift
//  MDShockAnimate
//
//  Created by Alan on 2018/4/17.
//  Copyright © 2018年 MD. All rights reserved.
//

import UIKit
import SDWebImage

let mainW = UIScreen.main.bounds.width
let mainH = UIScreen.main.bounds.height

var navH:CGFloat = 64

let cellID = "MDBannerCollectionViewCell"

class MDShockBannerView: UIView {

    lazy var topImage:UIImageView = {
        let topImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 30))
        topImage.contentMode = .scaleAspectFill
        return topImage
    }()
    
    lazy var bottomImage:UIImageView = {
        let bottomImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.width, height: self.height - 30))
        bottomImage.contentMode = .scaleAspectFill
        return bottomImage
    }()
    
    
    lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: self.width, height: self.height - navH - 10)
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var banner:UICollectionView = {
        let banner = UICollectionView.init(frame: CGRect(x:0, y: navH + 10, width: self.width, height: self.height - navH - 10), collectionViewLayout: flowLayout)
        banner.backgroundColor = .clear
        banner.isPagingEnabled = true
        banner.showsHorizontalScrollIndicator = false
        banner.delegate = self
        banner.dataSource = self
        self.addSubview(banner)
        self.bringSubview(toFront: banner)
        return banner
    }()
    
    lazy var pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.center = CGPoint(x: self.center.x, y: self.y + self.height - 20)
        pageControl.sizeToFit()
        self.addSubview(pageControl)
        return pageControl
    }()
    
    lazy var leftView:MDMaskView = {
        let leftView = MDMaskView(frame:CGRect(x: -10, y: 0, width: self.width + 10, height: self.height - 30))
        return leftView
    }()
    
    lazy var rightView:MDMaskView = {
        let rightView = MDMaskView(frame:CGRect(x: 0, y: 0, width: self.width + 10, height: self.height - 30))
        return rightView
    }()
    
    lazy var bannerMaskView:UIView = {
        let bannerMaskView = UIView(frame:CGRect(x: 0, y: 0, width: self.width, height: self.height))
        return bannerMaskView
    }()
    
    
    

    var banners:[MDBannerModel]!
    
    var infiniteLoop:Bool = true
    
    var autoScroll:Bool = true
    
    private var timers:Timer?
    
    private var lastContentOffset:CGFloat = 0

    private var  totalItemCount:Int = 0
    
    private var draggingIndex:Int = 0 // 拖动时的索引
    
    private var autoScrollIndex:Int = 0 // 自动滚动时的索引
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUI(){
        self.addSubview(self.bottomImage)
        self.addSubview(self.topImage)
        
        self.topImage.mask = bannerMaskView
        
        bannerMaskView.addSubview(rightView)
        bannerMaskView.addSubview(leftView)

        self.banner.register(UINib.init(nibName: "MDBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellID)
    }
    
    
    func setBanner(banners:[MDBannerModel]){
        if banners.count > 1{
            self.totalItemCount = self.infiniteLoop ? banners.count * 100 : banners.count
            self.banners = banners
            self.banner.reloadData()
            self.banner.scrollToItem(at: IndexPath.init(row: totalItemCount/2, section: 0), at: [], animated: false)
            
            let index = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
            
            self.pageControl.numberOfPages = banners.count
            self.pageControl.currentPage = index
            self.setPageControlImage()
            
            if index + 1 > banners.count - 1{
                self.bottomImage.sd_setImage(with: URL.init(string: banners[0].bgImg!), completed: nil)
            }else{
                self.bottomImage.sd_setImage(with: URL.init(string: banners[index + index + 1].bgImg!), completed: nil)
            }
            
            self.topImage.sd_setImage(with: URL.init(string: banners[index].bgImg!), completed: nil)
            
            
            self.startTimer()
        }
        
    }
    
    func setPageControlImage(){
        // 初始化一个属性列表数组
//        var ivarName_pageControl: [String] = []
//        var count: uint = 0
//        // 获取属性列表
//        let list = class_copyIvarList(UIPageControl.classForCoder(), &count)
//
//        for index in 0 ... count-1 {
//            // 获取属性名称，ivar_getTypeEncoding 可获取属性类型
//            let ivarName = ivar_getName( list![ Int(index) ] )
//            let name = String.init(cString: ivarName!)
//            print(name)
//            ivarName_pageControl.append(name)
//        }
//        // 判断是否包含这两个属性
//        if ivarName_pageControl.contains("_pageImage") && ivarName_pageControl.contains("_currentPageImage")
//        {
//            pageControl.setValue(UIImage.init(named: "banner_unselect"), forKey: "_pageImage")
//            pageControl.setValue(UIImage.init(named: "banner_select"), forKey: "_currentPageImage")
//            pageControl.layoutIfNeeded()
//        }
    }
    
    func startTimer(){
        self.invalidateTimer()
        self.autoScrollIndex  = self.currentIndex()
        timers = Timer.init(timeInterval: 3, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.main.add(timers!, forMode: .commonModes)
    }
    
    func invalidateTimer(){
        if timers != nil{
            timers?.invalidate()
            timers = nil
        }
    }
    
    @objc func automaticScroll(){
        if totalItemCount == 0{return}
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        self.scrollToIndex(targetIndex: targetIndex)
    }
    
    
    func scrollToIndex(targetIndex:Int){
        if targetIndex >= totalItemCount{
            banner.scrollToItem(at: IndexPath.init(row: totalItemCount / 2, section: 0), at: [], animated: false)
            return
        }
        banner.scrollToItem(at: IndexPath.init(row: targetIndex, section: 0), at: [], animated: true)
    }
    
    func pageControlIndexWithCurrentCellIndex(index:Int) ->Int{
        return index % self.banners.count
    }
}



extension MDShockBannerView:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalItemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as!MDBannerCollectionViewCell
        let itemIndex =  self.pageControlIndexWithCurrentCellIndex(index: indexPath.item)
        let banner = self.banners[itemIndex]
        cell.i_image.sd_setImage(with: URL.init(string: banner.img!), completed: nil)
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let curretContentOffset = scrollView.contentOffset.x
        self.pageControl.currentPage = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
        if scrollView.isDragging || scrollView.isDecelerating{
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: draggingIndex)
        
            if lastContentOffset > curretContentOffset{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex - 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                
                
                let topIndex = itemIndex - 1 < 0 ? self.banners.count - 1 : itemIndex - 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                    self.leftView.setRadius(radius: (mainW * CGFloat(self.draggingIndex) - curretContentOffset) * 2, direction: .right)
                    self.rightView.setRadius(radius: 0, direction: .left)
                })
                
            }else{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.draggingIndex + 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                
                let topIndex = itemIndex + 1 > self.banners.count - 1 ? 0 : itemIndex + 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                    self.leftView.setRadius(radius: 0, direction: .right)
                    self.rightView.setRadius(radius: (mainW * CGFloat(self.draggingIndex) - curretContentOffset) * 2, direction: .left)
                })
            }
        }else{
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: autoScrollIndex)
            if lastContentOffset > curretContentOffset{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex - 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                
                let topIndex = itemIndex - 1 < 0 ? self.banners.count - 1 : itemIndex - 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                    self.leftView.setRadius(radius: (curretContentOffset - mainW * CGFloat(itemIndex)) * 2, direction: .right)
                    self.rightView.setRadius(radius: 0, direction: .left)
                })
                
            }else{
                
                let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex, section: 0))
                let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex + 1, section: 0))
                
                UIView.animate(withDuration: 0.1) {
                    cell1?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                    cell2?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
                }
                
                let topIndex = (itemIndex + 1) > self.banners.count - 1 ? 0 : itemIndex + 1
                let bottomIndex = itemIndex
                self.topImage.sd_setImage(with: URL.init(string: banners[topIndex].bgImg!), completed: nil)
                self.bottomImage.sd_setImage(with: URL.init(string: banners[bottomIndex].bgImg!), completed: nil)
                UIView.animate(withDuration: 0.5, animations: {
                    self.leftView.setRadius(radius: 0, direction: .right)
                    self.rightView.setRadius(radius: (curretContentOffset - mainW * CGFloat(self.autoScrollIndex)) * 2, direction: .left)
                })
            }
             lastContentOffset = scrollView.contentOffset.x
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

    }
    

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.draggingIndex = self.currentIndex()
        if self.autoScroll{
            self.invalidateTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll{
            self.startTimer()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //拖动结束后
        lastContentOffset = scrollView.contentOffset.x
        self.autoScrollIndex = self.currentIndex()
    
        let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex - 1 , section: 0))
        let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex , section: 0))
        let cell3 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex  + 1, section: 0))
        
        UIView.animate(withDuration: 0.1) {
            cell1?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell2?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell3?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.autoScrollIndex = self.currentIndex()
        
        let cell1 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex - 1 , section: 0))
        
        let cell2 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex , section: 0))
        let cell3 = banner.cellForItem(at: IndexPath.init(row: self.autoScrollIndex  + 1, section: 0))
        
        UIView.animate(withDuration: 0.1) {
            cell1?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell2?.transform = CGAffineTransform(scaleX: 1, y: 1)
            cell3?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    
    
    func currentIndex() ->Int{
        if banner.width == 0 || banner.height == 0{
            return 0
        }
        var index:Int = 0
        index = Int((banner.contentOffset.x + flowLayout.itemSize.width / 2) / flowLayout.itemSize.width)
        return max(0, index)
    }
    
}
