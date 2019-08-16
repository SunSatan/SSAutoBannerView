//
//  ViewController.m
//  SSAutoBannerView
//
//  Created by 孙铭健 on 19/8/13.
//  Copyright © 2019年 SunSatan. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"

#import "SSAutoBannerView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self presentViewController:[[OneViewController alloc]init] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
