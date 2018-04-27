//
//  ViewController.m
//  MDShockBannerViewOCDemo
//
//  Created by Alan on 2018/4/27.
//  Copyright © 2018年 MD. All rights reserved.
//

#import "ViewController.h"

#import "MDShockBannerView.h"
#import "MDBannerModel.h"

@interface ViewController ()<MDShockBannerViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDShockBannerView *banner = [[MDShockBannerView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.width * 47 / 75)];
    banner.delegate = self;
    banner.pageSelectImage = [UIImage imageNamed:@"home_banner_select"];
    banner.pageUnselectImage = [UIImage imageNamed:@"home_banner_unselect"];
    MDBannerModel *model1 = [[MDBannerModel alloc] init];
    model1.img = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/6265b5b9bf8686f009cf44c366cfa4abd26b1a79.png";
    model1.bgImg = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/9bc42ce40490c854eab2e9969ac8e328caab0a17.png";
    
    MDBannerModel *model2 = [[MDBannerModel alloc] init];
    model2.img = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/16f7ab6124ae4688f0adef43ff3ab3b1f09ccc67.png";
    model2.bgImg = @"http://md-juhe.oss-cn-hangzhou.aliyuncs.com/upload/ad/20180417/81e9ad49cba8dc479a09d146a1fabf4b9ef3504d.png";

    
    banner.banners = @[model1,model2];
    
    [self.view addSubview:banner];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)clickBanner:(NSInteger)index{
    NSLog(@"点击了第%ld个banner",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
