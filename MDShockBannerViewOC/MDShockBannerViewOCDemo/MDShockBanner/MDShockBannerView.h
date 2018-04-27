//
//  MDShockBannerView.h
//  MDShockBannerViewOCDemo
//
//  Created by Alan on 2018/4/27.
//  Copyright © 2018年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MDShockBannerViewDelegate <NSObject>

- (void)clickBanner:(NSInteger)index;


@end

@interface MDShockBannerView : UIView

@property(nonatomic, assign) BOOL infiniteLoop;

@property(nonatomic, assign) BOOL autoScroll;

@property(nonatomic, assign) double scrollInterval;

@property(nonatomic, strong) UIImage *pageSelectImage;

@property(nonatomic, strong) UIImage *pageUnselectImage;


@property(nonatomic, strong) NSArray *banners;





@property(nonatomic, weak) id<MDShockBannerViewDelegate> delegate;

@end
