//
//  SSAutoBannerView.h
//  SSAutoBannerView
//
//  Created by 孙铭健 on 19/8/13.
//  Copyright © 2019年 SunSatan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SSAutoBannerView;

@protocol SSAutoBannerViewDelegate <NSObject>

- (void)clickToBanner:(SSAutoBannerView *)banner info:(NSDictionary *)info;

@end

@interface SSAutoBannerView : UIView

@property (nonatomic, copy) NSArray *dataArray;//数据数组(假设是图片数组)

@property (nonatomic, weak) id<SSAutoBannerViewDelegate> delegate;

/**
 每次给定数据数组后，都需要调用该方法加载或更新视图
 */
- (void)reloadData;

@end
