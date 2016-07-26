//
//  FTBoxerCenterViewController.m
//  fighter
//
//  Created by kang on 16/5/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBoxerCenter.h"
#import "FTBoxerHeaderView.h"
#import "BoxerInfoController.h"
#import "BoxerMatchController.h"
#import "BoxerVideoController.h"

@interface FTBoxerCenter () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;



@property (nonatomic, assign) CGFloat headerH;
@property (nonatomic, assign) CGFloat scrollH;
@property (nonatomic, assign) CGFloat topContentInset;

@end

@implementation FTBoxerCenter

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 249)];
    
    
    [self initSubviews];
}

- (void) initSubviews {
//    [self createScaleHeadView];
    [self initScrollView];
    
    [self.view insertSubview:self.headerView belowSubview:self.scrollView];
    
//    FTBoxerHeaderView * header = [FTBoxerHeaderView headerView];
////    UIView *headerView =  [[[NSBundle mainBundle] loadNibNamed:@"BoxerCenterHeader" owner:nil options:nil]];
//    header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 249);
//    [header setBackgroundColor:[UIColor whiteColor]];
    
//    [self.scrollView addSubview:header];
}

- (void) initScrollView {
    
    _headerH = 249;
    _scrollH = SCREEN_HEIGHT - _headerH;
    _topContentInset = 114;
    
    self.scrollView = [[UIScrollView alloc]init];
    [self.scrollView setFrame:CGRectMake(0, 135, SCREEN_WIDTH,_scrollH )];
    //    self.scrollView.backgroundColor = [UIColor blueColor];
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake( SCREEN_WIDTH,_scrollH+10);
    [self.view addSubview:self.scrollView];
    
    //
//    UIView *scrollHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 114, SCREEN_WIDTH, 40)];
//    scrollHeader.backgroundColor = [UIColor colorWithHex:0x000000];
//    [self.view addSubview:scrollHeader];
//    
//    UIView *sepataterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    sepataterView.backgroundColor = [UIColor colorWithHex:0x282828];
//    [scrollHeader addSubview:sepataterView];
//    
//    [self.scrollView addSubview:scrollHeader];
    
//    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
}

#pragma mark - 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y + self.scrollView.contentInset.top;//注意
    //    NSLog(@"%lf", offsetY);
    
    if (offsetY > _topContentInset && offsetY <= _topContentInset * 2) {
        
//        _statusBarStyleControl = YES;
//        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//            [self setNeedsStatusBarAppearanceUpdate];
//        }
//        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//        
//        _alphaMemory = offsetY/(_topContentInset * 2) >= 1 ? 1 : offsetY/(_topContentInset * 2);
//        
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:_alphaMemory];
        
    }
    else if (offsetY <= _topContentInset) {
        
//        _statusBarStyleControl = NO;
//        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
//            [self setNeedsStatusBarAppearanceUpdate];
//        }
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        
//        _alphaMemory = 0;
//        [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
    }
    else if (offsetY > _topContentInset * 2) {
      
    }
    
    if (offsetY < 0) {
        
        CGFloat h = self.headerBackground.frame.size.height;
//        self.headerBackground.transform = CGAffineTransformMakeScale(1 + offsetY/(-SCREEN_WIDTH), 1 + offsetY/(-h));
        NSLog(@"self.headerBackground.frame.size.height= %f",self.headerBackground.frame.size.height);
        
        
        self.headerBackground.transform = CGAffineTransformMake(1 + offsetY/(-SCREEN_WIDTH), 0, 0, 1 + offsetY/(-h), 0, -offsetY/2);
//        CGPoint point = self.headerBackground.center;
//        point.x = self.headerView.center.x;
//        point.y = self.headerBackground.frame.size.height/2 ;
//        self.headerBackground.center = point;
        
//        self.headerBackground.transform = CGAffineTransformTranslate(self.headerBackground.transform, 0, -offsetY/2);
        
//        self.headerBackground.transform = CGAffineTransformMakeTranslation(1,1);
//        CGRect frame = self.headerBackground.frame;
//        frame.size.height = frame.size.height - offsetY;
//        self.headerBackground.frame = frame;
        NSLog(@"offsetY= %f",offsetY);
        
    }
   
//    CGRect frame = self.headerBackground.frame;
//    frame.origin.y = 0;
//    self.headerBackground.frame = frame;
    
//    CGPoint point = self.headerBackground.center;
//    point.x = self.headerView.center.x;
//    point.y = (1 + offsetY/(-300)) * self.headerBackground.center.y;
//    self.headerBackground.center = point;
    
    
    
    
    
//    NSLog(@"offsetY:%f",offsetY);
    _headerH = _headerH + offsetY;
    _scrollH = _scrollH - offsetY;
//    [self.scrollView setFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT )];
//    self.scrollView.contentSize = CGSizeMake( SCREEN_WIDTH,_scrollH+10 );

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
