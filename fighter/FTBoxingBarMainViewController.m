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
#import "FTPostListViewController.h"//导入帖子列表（按摩快）vc
#import "FTPostListTableView.h"//导入帖子列表tableView

@interface FTBoxingBarMainViewController ()<FTSegmentButtonViewDelegate, FTCollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *segButtonViewContainer;//二选按钮容器view
@property (nonatomic, strong) FTSegmentButtonView *segButtonView;//二选按钮
@property (strong, nonatomic) IBOutlet UIView *mainContentView;//主内容view：根据情况展示collectionView或tableView
@property (nonatomic, strong) FTBoxingBarModuleCollectionView *moduleCollectionView;//显示模块的collectionView
@property (nonatomic, strong) FTPostListTableView *postListTableView;//显示帖子列表的tableView

@end

@implementation FTBoxingBarMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];//初始化一些基本配置
    [self setSubViews];//设置子view
    [self loadDataFromServer];//从服务器加载数据
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
    
    //初始化tableView
    [self initTableView];
    
    //默认显示模块列表
    [self leftButtonClicked];
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
    _moduleCollectionView.hidden = NO;//显示模块列表
    _postListTableView.hidden = YES;//隐藏帖子列表
    
    [_moduleCollectionView.collectionView reloadData];
}

- (void)rightButtonClicked{
    _moduleCollectionView.hidden = YES;//隐藏模块列表
    _postListTableView.hidden = NO;//显示帖子列表
    
    [_postListTableView reloadData];
}

#pragma mark 加载数据
- (void)loadDataFromServer{
    
}

#pragma mark 显示模块的collectionView
- (void)initCollectionView{
    _moduleCollectionView = [[FTBoxingBarModuleCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44 - 35 - 15)];
    _moduleCollectionView.delegate = self;//设置代理
    [_mainContentView addSubview:_moduleCollectionView];
    _moduleCollectionView.hidden = YES;
}

- (void)initTableView{
    _postListTableView = [[FTPostListTableView alloc]initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 6 * 2, SCREEN_HEIGHT - 64 - 44 - 35 - 15)];//6为边距
    
    [_mainContentView addSubview:_postListTableView];
    _postListTableView.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    FTPostListViewController *postListViewController = [FTPostListViewController new];
    [self.navigationController pushViewController:postListViewController animated:YES];
}

@end
