//
//  FTBoxingBarMainViewController.m
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBoxingBarMainViewController.h"

#import "FTSegmentButtonView.h"//导入二选按钮
#import "FTBoxingBarModuleCollectionView.h"//导入显示模块的collectionView

@interface FTBoxingBarMainViewController ()<FTSegmentButtonViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *segButtonViewContainer;//二选按钮容器view
@property (nonatomic, strong) FTSegmentButtonView *segButtonView;//二选按钮
@property (strong, nonatomic) IBOutlet UIView *mainContentView;//主内容view：根据情况展示collectionView或tableView
@property (nonatomic, strong) FTBoxingBarModuleCollectionView *moduleCollectionView;//显示模块的collectionView


@end

@implementation FTBoxingBarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self setSubViews];
}

#pragma mark 设置默认配置
- (void)initBaseConfig{
    
}

- (void)setSubViews{
    /*
     初始化二选按钮
     */
    [self initSegmentButtonView];
    
    /*
        初始化collectionView
     */
    [self initCollectionView];
}

#pragma mark 初始化二选按钮
- (void)initSegmentButtonView{
    _segButtonView = [[[NSBundle mainBundle]loadNibNamed:@"FTSegmentButtonView" owner:self options:nil] firstObject];
    _segButtonView.frame = _segButtonViewContainer.bounds;
    
    //设置按钮title
    [_segButtonView.buttonLeft setTitle:@"版块分类" forState:UIControlStateNormal];
    [_segButtonView.buttonRight setTitle:@"最新最热" forState:UIControlStateNormal];
    
    _segButtonView.delegate = self;//设置代理
    
    [_segButtonViewContainer addSubview:_segButtonView];
}

- (void)leftButtonClicked{
    [_moduleCollectionView.collectionView reloadData];
}

- (void)rightButtonClicked{
    
}


#pragma mark 显示模块的collectionView
- (void)initCollectionView{
    _moduleCollectionView = [[FTBoxingBarModuleCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 35 - 15)];
    [_mainContentView addSubview:_moduleCollectionView];
}


@end
