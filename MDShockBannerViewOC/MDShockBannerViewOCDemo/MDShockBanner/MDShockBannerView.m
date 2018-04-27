//
//  MDShockBannerView.m
//  MDShockBannerViewOCDemo
//
//  Created by Alan on 2018/4/27.
//  Copyright © 2018年 MD. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "MDShockBannerView.h"
#import "UIView+MD.h"
#import "MDMaskView.h"
#import "MDBannerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MDBannerCollectionViewCell.h"

#define mainW [[UIScreen mainScreen] bounds].size.width
#define mainH [[UIScreen mainScreen] bounds].size.height
#define cellID @"MDBannerCollectionViewCell"


@interface MDShockBannerView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property(nonatomic,assign)CGFloat naxH;

@property(nonatomic, strong) UIImageView *topImage;
@property(nonatomic, strong) UIImageView *bottomImage;

@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property(nonatomic, strong) UICollectionView *banner;

@property(nonatomic, strong) MDMaskView *leftView;
@property(nonatomic, strong) MDMaskView *rightView;

@property(nonatomic, strong) UIView *bannerMaskView;

@property(nonatomic, strong) UIPageControl *pageControl;



@property(nonatomic, strong) NSTimer *timers;

@property(nonatomic, assign) CGFloat lastContentOffset;
@property(nonatomic, assign) NSInteger totalItemCount;
@property(nonatomic, assign) NSInteger draggingIndex;
@property(nonatomic, assign) NSInteger autoScrollIndex;

@end

@implementation MDShockBannerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initShockBannerView];
    }
    return self;
}


-(void)initShockBannerView{
    self.autoScroll = YES;
    self.infiniteLoop = YES;
    self.scrollInterval = 3;
    
    [self addSubview:self.bottomImage];
    [self addSubview:self.topImage];
    [self addSubview:self.banner];
    [self addSubview:self.pageControl];

    self.topImage.maskView = self.bannerMaskView;
    
    [self.bannerMaskView addSubview:self.rightView];
    [self.bannerMaskView addSubview:self.leftView];
    
    [self.banner registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}







-(void)startTimer{
    [self invalidateTimer];
    self.autoScrollIndex = [self currentIndex];
    _timers = [NSTimer timerWithTimeInterval:_scrollInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timers forMode:NSRunLoopCommonModes];
}


-(void)invalidateTimer{
    if (_timers != nil){
        [_timers invalidate];
        _timers = nil;
    }
}



-(void)automaticScroll{
    if (_totalItemCount == 0){return;}
    NSInteger currentIndex = [self currentIndex];
    NSInteger targetIndex = currentIndex + 1;
    UICollectionViewCell *cell = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]];
    [UIView animateWithDuration:0.2 animations:^{
        cell.transform = CGAffineTransformMakeScale(0.85, 0.85);
    } completion:^(BOOL finished) {
        [self scrollToIndex:targetIndex];
    }];
 
}

-(void)scrollToIndex:(NSInteger)targetIndex{
    if (targetIndex >= _totalItemCount){
        [self.banner scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemCount/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
    [self.banner scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}


-(NSInteger)currentIndex{
    if (_banner.width == 0 || _banner.height == 0){return 0;}
    NSInteger index;

    index = (_banner.contentOffset.x + _flowLayout.itemSize.width/2)/_flowLayout.itemSize.width;
    return MAX(0, index);
}

-(NSInteger)pageControlIndexWithCurrentCellIndex:(NSInteger)index{
    return index % self.banners.count;
}



#pragma UICollectionViewDelegate,UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _totalItemCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MDBannerCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSInteger index = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    MDBannerModel *model = self.banners[index];
    [cell.i_img sd_setImageWithURL:[NSURL URLWithString:model.img]];
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickBanner:)]){
        [self.delegate clickBanner:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat curretContentOffset = scrollView.contentOffset.x;
    self.pageControl.currentPage = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    if (scrollView.isDragging || scrollView.isDecelerating){
        NSInteger itemIndex = [self pageControlIndexWithCurrentCellIndex:_draggingIndex];
        if (_lastContentOffset > curretContentOffset){
            UICollectionViewCell *cell1 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_draggingIndex inSection:0]];
            UICollectionViewCell *cell2 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_draggingIndex - 1 < 0) ? _totalItemCount : _draggingIndex - 1 inSection:0]];
            
            [UIView animateWithDuration:0.1 animations:^{
                cell1.transform = CGAffineTransformMakeScale(0.85, 0.85);
                cell2.transform = CGAffineTransformMakeScale(0.85, 0.85);
            }];
            
            NSInteger topIndex = (itemIndex - 1 < 0) ? self.banners.count - 1 : itemIndex - 1;
            NSInteger bottomIndex = itemIndex;
            
            MDBannerModel *model1 = _banners[topIndex];
            [self.topImage sd_setImageWithURL:[NSURL URLWithString:model1.bgImg]];
            MDBannerModel *model2 = _banners[bottomIndex];
            [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model2.bgImg]];
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftView setRadius:(mainW * _draggingIndex - curretContentOffset)*2  direction:MDBannerSrollDirectionRight];
                [self.rightView setRadius:0  direction:MDBannerSrollDirectionLeft];
            }];
            
        }else{
            UICollectionViewCell *cell1 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_draggingIndex inSection:0]];
            UICollectionViewCell *cell2 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_draggingIndex + 1 >= _totalItemCount) ? _totalItemCount/2 : _draggingIndex + 1 inSection:0]];
            
            [UIView animateWithDuration:0.1 animations:^{
                cell1.transform = CGAffineTransformMakeScale(0.85, 0.85);
                cell2.transform = CGAffineTransformMakeScale(0.85, 0.85);
            }];
            
            NSInteger topIndex = (itemIndex + 1 >= self.banners.count) ? 0 : itemIndex + 1;
            NSInteger bottomIndex = itemIndex;
            
            MDBannerModel *model1 = _banners[topIndex];
            [self.topImage sd_setImageWithURL:[NSURL URLWithString:model1.bgImg]];
            MDBannerModel *model2 = _banners[bottomIndex];
            [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model2.bgImg]];
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftView setRadius:0 direction:MDBannerSrollDirectionRight];
                [self.rightView setRadius:(mainW * _draggingIndex - curretContentOffset)*2   direction:MDBannerSrollDirectionLeft];
            }];
        }
    }else{
        NSInteger itemIndex = [self pageControlIndexWithCurrentCellIndex:_autoScrollIndex];
        if (_lastContentOffset > curretContentOffset){
           
            //上一个cell
            UICollectionViewCell *cell = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex - 1 < 0) ? _totalItemCount : _autoScrollIndex inSection:0]];
            
            [UIView animateWithDuration:0.1 animations:^{
                cell.transform = CGAffineTransformMakeScale(0.85, 0.85);
            }];
            
            NSInteger topIndex = (itemIndex - 1 < 0) ? self.banners.count - 1 : itemIndex - 1;
            NSInteger bottomIndex = itemIndex;
            
            MDBannerModel *model1 = _banners[topIndex];
            [self.topImage sd_setImageWithURL:[NSURL URLWithString:model1.bgImg]];
            MDBannerModel *model2 = _banners[bottomIndex];
            [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model2.bgImg]];
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftView setRadius:(curretContentOffset - mainW * _autoScrollIndex)*2  direction:MDBannerSrollDirectionRight];
                [self.rightView setRadius:0  direction:MDBannerSrollDirectionLeft];
            }];
            
        }else{
            UICollectionViewCell *cell2 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex + 1 >= _totalItemCount) ? _totalItemCount/2 : _autoScrollIndex + 1 inSection:0]];
            
            [UIView animateWithDuration:0.1 animations:^{
                cell2.transform = CGAffineTransformMakeScale(0.85, 0.85);
            }];
            
            NSInteger topIndex = (itemIndex + 1 >= self.banners.count) ? 0 : itemIndex + 1;
            NSInteger bottomIndex = itemIndex;
            
            MDBannerModel *model1 = _banners[topIndex];
            [self.topImage sd_setImageWithURL:[NSURL URLWithString:model1.bgImg]];
            MDBannerModel *model2 = _banners[bottomIndex];
            [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model2.bgImg]];
            
            [UIView animateWithDuration:0.5 animations:^{
                [self.leftView setRadius:0 direction:MDBannerSrollDirectionRight];
                [self.rightView setRadius:(curretContentOffset - mainW * _autoScrollIndex)*2   direction:MDBannerSrollDirectionLeft];
            }];
        }
        _lastContentOffset = curretContentOffset;
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.draggingIndex = [self currentIndex];
    if (_autoScroll){
        [self invalidateTimer];
    }
}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (_autoScroll){
        [self startTimer];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _lastContentOffset = scrollView.contentOffset.x;
    
    _autoScrollIndex = [self currentIndex];
    
    
    UICollectionViewCell *cell1 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_autoScrollIndex inSection:0]];
    UICollectionViewCell *cell2 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex + 1 >= _totalItemCount) ? _totalItemCount/2 : _autoScrollIndex + 1 inSection:0]];
    UICollectionViewCell *cell3 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex - 1 < 0) ? _totalItemCount : _autoScrollIndex - 1 inSection:0]];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell1.transform = CGAffineTransformMakeScale(1, 1);
        cell2.transform = CGAffineTransformMakeScale(1, 1);
        cell3.transform = CGAffineTransformMakeScale(1, 1);
    }];
}


-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    _autoScrollIndex = [self currentIndex];
    
    UICollectionViewCell *cell1 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:_autoScrollIndex inSection:0]];
    UICollectionViewCell *cell2 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex + 1 >= _totalItemCount) ? _totalItemCount/2 : _autoScrollIndex + 1 inSection:0]];
    UICollectionViewCell *cell3 = [_banner cellForItemAtIndexPath:[NSIndexPath indexPathForItem:(_autoScrollIndex - 1 < 0) ? _totalItemCount : _autoScrollIndex - 1 inSection:0]];
    
    [UIView animateWithDuration:0.2 animations:^{
        cell1.transform = CGAffineTransformMakeScale(1, 1);
        cell2.transform = CGAffineTransformMakeScale(1, 1);
        cell3.transform = CGAffineTransformMakeScale(1, 1);
    }];
}


#pragma Get
-(CGFloat)naxH{
    if (mainH == 812){
        return 88;
    }
    return 64;
}


-(UIImageView *)topImage{
    if (_topImage == nil){
        _topImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 30)];
    }
    return _topImage;
}

-(UIImageView *)bottomImage{
    if (_bottomImage == nil){
        _bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 30)];
    }
    return _bottomImage;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.itemSize = CGSizeMake(self.width, self.height - self.naxH - 10);
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

-(UICollectionView *)banner{
    if (_banner == nil){
        _banner = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.naxH + 10, self.width, self.height - self.naxH - 10) collectionViewLayout:self.flowLayout];
        _banner.backgroundColor = [UIColor clearColor];
        _banner.pagingEnabled = YES;
        _banner.showsHorizontalScrollIndicator = NO;
        _banner.delegate = self;
        _banner.dataSource = self;
    }
    return _banner;
}

-(MDMaskView *)leftView{
    if (_leftView == nil){
        _leftView = [[MDMaskView alloc] initWithFrame:CGRectMake(-10, 0, self.width + 10, self.height - 30)];
    }
    return _leftView;
}

-(MDMaskView *)rightView{
    if (_rightView == nil){
        _rightView = [[MDMaskView alloc] initWithFrame:CGRectMake(0, 0, self.width + 10, self.height - 30)];
    }
    return _rightView;
}

-(UIView *)bannerMaskView{
    if (_bannerMaskView == nil){
        _bannerMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height - 30)];
    }
    return _bannerMaskView;
}


-(UIPageControl *)pageControl{
    if (_pageControl == nil){
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.center = CGPointMake(self.center.x, self.y + self.height - 20);
        [_pageControl sizeToFit];
    }
    return _pageControl;
}



#pragma Set
-(void)setBanners:(NSArray *)banners{
    if (banners.count == 0){return;}
    self.totalItemCount = (self.infiniteLoop) ? banners.count * 200 : banners.count;
    
    _banners = banners;
    [self.banner reloadData];
    
    [self.banner scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalItemCount/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    NSInteger index = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    self.pageControl.numberOfPages = banners.count;
    self.pageControl.currentPage = index;
    
    if (index + 1 > banners.count - 1){
        MDBannerModel *model = banners[0];
        [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model.bgImg]];
    }else{
        MDBannerModel *model = banners[index + 1];
        [self.bottomImage sd_setImageWithURL:[NSURL URLWithString:model.bgImg]];
    }

    MDBannerModel *model = banners[index];
    [self.topImage sd_setImageWithURL:[NSURL URLWithString:model.bgImg]];

    if (_autoScroll){
        [self startTimer];
    }
}

-(void)setPageSelectImage:(UIImage *)pageSelectImage{
    if (pageSelectImage) {
        [self.pageControl setValue:pageSelectImage forKeyPath:@"_currentPageImage"];
    }else{
        NSLog(@"您设置的pageSelectImage图片是空的");
    }
}

-(void)setPageUnselectImage:(UIImage *)pageUnselectImage{
    if (pageUnselectImage){
        [self.pageControl setValue:pageUnselectImage forKeyPath:@"_pageImage"];
    }else{
        NSLog(@"您设置的pageUnselectImage图片是空的");
    }
}



@end
