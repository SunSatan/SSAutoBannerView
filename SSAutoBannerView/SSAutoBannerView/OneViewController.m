//
//  OneViewController.m
//  SSAutoBannerView
//
//  Created by 孙铭健 on 19/8/16.
//  Copyright © 2019年 SunSatan. All rights reserved.
//

#import "OneViewController.h"

#import "SSAutoBannerView.h"

@interface OneViewController ()

@property(nonatomic, strong) SSAutoBannerView *bannerView;

@end

@implementation OneViewController

//验证SSAutoBannerView能被正确释放，不存在循环引用

- (void)dealloc
{
    NSLog(@"OneViewController dealloc");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    self.bannerView = [[SSAutoBannerView alloc]init];
    [self.view addSubview:self.bannerView];
    self.bannerView.frame = CGRectMake(0, 64, self.view.bounds.size.width, 100);
    self.bannerView.dataArray = @[@"1.jpg", @"2.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
    [self.bannerView reloadData];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.view addSubview:backBtn];
    backBtn.frame = CGRectMake(self.view.bounds.size.width - 60, 20, 50, 24);
    [backBtn setTitle:@"关闭" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(clickToBack:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickToBack:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    static BOOL isMore = NO;
    if (isMore) {
        self.bannerView.dataArray = @[@"1.jpg", @"2.jpg", @"3.jpg", @"2.jpg", @"1.jpg"];
        [self.bannerView reloadData];
    } else {
        self.bannerView.dataArray = @[@"5.jpg", @"4.jpg", @"3.jpg", @"4.jpg", @"5.jpg"];
        [self.bannerView reloadData];
    }
}

@end
