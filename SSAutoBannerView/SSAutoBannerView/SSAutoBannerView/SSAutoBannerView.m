//
//  SSAutoBannerView.m
//  SSAutoBannerView
//
//  Created by 孙铭健 on 19/8/13.
//  Copyright © 2019年 SunSatan. All rights reserved.
//

#import "SSAutoBannerView.h"

#define SELF_WIDTH  self.bounds.size.width
#define SELF_HEIGHT self.bounds.size.height

#define WeakSelf(type)    __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;

@interface SSAutoBannerView () <UIScrollViewDelegate>

@property(nonatomic, strong) NSTimer *timer; //定时器滚动

@property(nonatomic, strong) UIScrollView *scrollView;

@property(nonatomic, strong) UIPageControl *pageControl; //页数控制器

@property(nonatomic, strong) NSMutableArray *imgMutArray;//用于显示图片的数组

@end

@implementation SSAutoBannerView

#pragma mark - dealloc

- (void)dealloc
{
    NSLog(@"SSAutoBannerView dealloc");
    [self stopTimer];
    _delegate    = nil;
    _pageControl = nil;
    _scrollView  = nil;
    _imgMutArray = nil;
    _dataArray   = nil;
}

#pragma mark - init

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self basicConfig];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self basicConfig];
    }
    return self;
}

- (void)layoutSubviews
{
    [self addSubview:self.scrollView];
    [self addSubview:self.pageControl];
}

#pragma mark - 初始化设置

- (void)basicConfig
{
    self.backgroundColor = [UIColor whiteColor];
    self.clipsToBounds = YES;
    self.opaque = YES;
}

#pragma mark - 主要逻辑

- (void)reloadBannerView
{
    if (!self.dataArray || self.dataArray.count == 0) {
        return;
    }
    //根据数据，创建显示所需的数组
    [self.imgMutArray removeAllObjects];
    [self.imgMutArray addObject:self.dataArray.lastObject];
    [self.imgMutArray addObjectsFromArray:self.dataArray];
    [self.imgMutArray addObject:self.dataArray.firstObject];
    //设置相关参数：page个数、scrollView的可偏移量和当前偏移值
    self.pageControl.numberOfPages = self.imgMutArray.count - 2; //真实数量要减去首尾两张
    self.scrollView.contentSize    = CGSizeMake(SELF_WIDTH * self.imgMutArray.count, SELF_HEIGHT);
    self.scrollView.contentOffset  = CGPointMake(SELF_WIDTH, 0);
    //将之间所有视图移除，再重新加载视图
    [self removeImageSubview];
    [self loadImageView];
    //然后关闭再开启定时器
    [self stopTimer];
    [self openTimer];
}

#pragma mark - 加载和移除子视图

- (void)loadImageView
{
    for (int i=0; i < self.imgMutArray.count; i++) {
        CGRect frame;
        frame.origin.x = SELF_WIDTH * i;
        frame.origin.y = 0;
        frame.size.width = SELF_WIDTH;
        frame.size.height = SELF_HEIGHT;
        //这里使用btn来显示，也可以用imgView，视情况而定
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.scrollView addSubview:btn];
        btn.frame = frame;
        btn.opaque = YES;
        btn.tag = i - 1;//标记数据下标，要-1才对
        [btn setImage:[UIImage imageNamed:self.imgMutArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickToBanner:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)removeImageSubview
{
    for (id subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - 点击跳转代理事件

- (void)clickToBanner:(UIButton *)button
{
    NSLog(@"点击跳转！");
    NSInteger index = button.tag;//下标去取数据，返回传给代理info，不过我这没数据就不传了
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToBanner:info:)]) {
        [self.delegate clickToBanner:self info:nil];
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat currentContentOffsetX = self.scrollView.contentOffset.x;//当前x偏移量
    //最大偏移量，假设有五张图，那么最大偏移量就是五张图的X坐标
    CGFloat maxContentOffsetX = SELF_WIDTH * (self.imgMutArray.count - 1);
    //向左滚动，偏移量为0时，重新设置偏移量为倒数第二张
    if (currentContentOffsetX <= 0) {
        CGFloat willOffsetX = SELF_WIDTH * (self.imgMutArray.count - 2);
        [self.scrollView setContentOffset:CGPointMake(willOffsetX, 0) animated:NO];
    }
    //向右滚动，偏移量为最大时，重新设置偏移量为顺数第二张
    else if (currentContentOffsetX >= maxContentOffsetX) {
        [self.scrollView setContentOffset:CGPointMake(SELF_WIDTH, 0) animated:NO];
    }
    //根据偏移量设置当前页数
    self.pageControl.currentPage = self.scrollView.contentOffset.x/SELF_WIDTH - 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];//开始拖动停止定时器
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self stopTimer];//停止拖动 先关闭定时器再开启定时器
    [self openTimer];//避免出现问题
}

#pragma mark - 开/关定时器

- (void) openTimer
{
    WeakSelf(self);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        StrongSelf(self);
        CGFloat contentOffsetX = self.scrollView.contentOffset.x + SELF_WIDTH;
        [self.scrollView setContentOffset:CGPointMake(contentOffsetX, 0) animated:YES];
    }];
}

- (void) stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - lazy load

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame         = CGRectMake(0, 0, SELF_WIDTH, SELF_HEIGHT);
        _scrollView.contentSize   = CGSizeMake(SELF_WIDTH, SELF_HEIGHT);
        _scrollView.contentOffset = CGPointMake(SELF_WIDTH, 0);

        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;

        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.alwaysBounceVertical   = NO;

        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.opaque = YES;
        _scrollView.bounces  = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.frame = CGRectMake(0, SELF_HEIGHT-24, SELF_WIDTH, 24);
        _pageControl.opaque = YES;
        _pageControl.currentPage   = 0;
        _pageControl.numberOfPages = 4;
        _pageControl.pageIndicatorTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    }
    return _pageControl;
}

- (NSMutableArray *)imgMutArray
{
    if (!_imgMutArray) {
        _imgMutArray = [[NSMutableArray alloc]init];
    }
    return _imgMutArray;
}

@end
