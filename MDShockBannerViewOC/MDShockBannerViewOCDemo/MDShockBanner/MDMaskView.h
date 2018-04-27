//
//  MDMaskView.h
//  MDShockBannerViewOCDemo
//
//  Created by Alan on 2018/4/27.
//  Copyright © 2018年 MD. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MDBannerSrollDirectionUnknow,
    MDBannerSrollDirectionLeft,
    MDBannerSrollDirectionRight,
} MDBannerSrollDirection;

@interface MDMaskView : UIView

-(void)setRadius:(CGFloat)radius direction:(MDBannerSrollDirection)dir;
@end
