//
//  FTSlideTabBar.m
//  fighter
//
//  Created by kang on 16/5/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSlideTabBar.h"


@interface FTSlideTabBar()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>


@end


@implementation FTSlideTabBar

-(instancetype)initWithFrame:(CGRect)frame
                      titles:(NSArray *) titles{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _tabCount = titles.count;
        _btnTitles = titles;
       
        
        
        [self initScrollView];
        
        [self initSlideView];
        
        [self initBtns];
    }
    
    return self;
}


#pragma mark -- 初始化滑动的指示View
-(void) initScrollView {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.frame];
    
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.showsVerticalScrollIndicator = YES;
    
    _scrollView.bounces = NO;
    
    _scrollView.delegate = self;
    
    _scrollView.contentSize = self.frame.size;
    
    [self addSubview:_scrollView];
}


#pragma mark -- 初始化滑动的指示View
-(void) initSlideView{
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height-_sliderH, _sliderW, _sliderH)];
    [_slideView setBackgroundColor:[UIColor redColor]];
    [_scrollView addSubview:_slideView];

}


#pragma mark -- 初始tab 按钮
- (void) initBtns {

    
    for(int i = 0; i < _btnTitles.count ; i++) {
    
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(_sliderW*i, 0, _sliderW, self.frame.size.height)];
        [button setTitle:[_btnTitles objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
        
        [_scrollView addSubview:button];
    }
    
}


@end
