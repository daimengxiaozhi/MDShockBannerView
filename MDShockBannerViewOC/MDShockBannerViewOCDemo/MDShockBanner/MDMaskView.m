//
//  MDMaskView.m
//  MDShockBannerViewOCDemo
//
//  Created by Alan on 2018/4/27.
//  Copyright © 2018年 MD. All rights reserved.
//

#import "MDMaskView.h"


@interface MDMaskView()

@property (assign, readonly, nonatomic) CGFloat maskRadius;

@property (assign, readonly, nonatomic) MDBannerSrollDirection direction;

@end

@implementation MDMaskView

-(void)setRadius:(CGFloat)radius direction:(MDBannerSrollDirection)dir{
    _maskRadius = radius;
    _direction = dir;
    
    if (_direction != MDBannerSrollDirectionUnknow) {
        [self setNeedsDisplay];
    }
    
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.backgroundColor = [UIColor clearColor];
    if (_direction != MDBannerSrollDirectionUnknow) {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        if (_direction == MDBannerSrollDirectionLeft){
            CGContextAddArc(ctx, self.center.x + rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
        }else{
            CGContextAddArc(ctx, self.center.x - rect.size.width/2, self.center.y, _maskRadius, 0, M_PI * 2, NO);
        }
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextFillPath(ctx);
//        CGContextRelease(ctx);
    }
}


@end
