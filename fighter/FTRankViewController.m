//
//  FTRankViewController.m
//  fighter
//
//  Created by kang on 16/5/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankViewController.h"
#import "FTButton.h"
#import "FTRankTableView.h"
#import "FTHeightPickerView.h"
#import "FTRankTableVIewCell.h"
#import "FTRankHeaderCell.h"
#import "NetWorking.h"
#import "DBManager.h"
#import "UIWindow+MBProgressHUD.h"
#import "FTBoxerCenter.h"
#import "JHRefresh.h"
#import "FTHomepageMainViewController.h"

@interface FTRankViewController ()  <FTSelectCellDelegate>

@property (nonatomic, strong) FTButton *kindBtn;
@property (nonatomic, strong) FTButton *matchBtn;
@property (nonatomic, strong) FTButton *levelBtn;

@property (nonatomic, strong) NSArray *kingArray;
@property (nonatomic, strong) NSArray *matchArray;
@property (nonatomic, strong) NSArray *levelArray;

@property (nonatomic, copy) NSString *selectKind;
@property (nonatomic, copy) NSString *selectMatch;
@property (nonatomic, copy) NSString *selectLevel;
@property (nonatomic, assign) NSInteger pageNum;

@property (nonatomic, strong) UITableView *headerTableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UIImageView *shadow;
@end

@implementation FTRankViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    self.title = @"排行榜";
    
    [self getRankListLabelArray];
    
    [self initArray];
    [self getContentDataFromWeb];
    
    [self initSubViews];
    
}

//从数据库取筛选标签数据
- (void) initArray {
    
    _kingArray = [[NSArray alloc]init];
    _matchArray = [[NSArray alloc]init];
    _levelArray = [[NSArray alloc]init];
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    _kingArray = [dbManager searchLabel];
    
    if (_kingArray.count > 0) {
        
        _matchArray = [dbManager searchItem:[_kingArray objectAtIndex:0] type:1];
        _levelArray = [dbManager searchItem:[_kingArray objectAtIndex:0] type:2];
        
    }
    [dbManager close];
    
    
    [self updateSelectTitle];
    
    if(_dataArray.count > 0) {
        [self fixViewSize];
    }
}

//更新筛选标签
-(void) updateSelectTitle {

    if (_kingArray.count > 0) {
        _selectKind = [_kingArray objectAtIndex:0];
        [_kindBtn setTitle:_selectKind forState:UIControlStateNormal];
    }else {
        _selectKind = @"类别";
    }
    if (_matchArray.count > 0) {
        _selectMatch = [_matchArray objectAtIndex:0];
        [_matchBtn setTitle:_selectMatch forState:UIControlStateNormal];
        
    }else {
        _selectMatch = @"赛事";
    }
    
    if (_levelArray.count > 0) {
        _selectLevel = [_levelArray objectAtIndex:0];
        [_levelBtn setTitle:_selectLevel forState:UIControlStateNormal];
        
    }else {
        _selectLevel = @"级别";
    }

}

-(void) getContentDataFromWeb {

    NetWorking *net = [[NetWorking alloc]init];
    [net getRankListWithLabel:_selectKind
                         race:_selectMatch
                FeatherWeight:_selectLevel
                      pageNum:_pageNum
                       option:^(NSDictionary *dict) {
                           
                           [self checkNetWokingStatus];
                           if (dict != nil) {
                               
                               if ([dict[@"status"] isEqualToString:@"success"]) {
                                   
                                   if (_pageNum == 0|| _pageNum == 1) {
                                       _dataArray = dict[@"data"];
                                   }else {
                                       [_dataArray addObjectsFromArray:dict[@"data"]];
                                   }
                                   
                                   [self fixViewSize];
                                   
                                   [self.scrollView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                                   [self.scrollView  footerEndRefreshing];
                               }else {
                               
                                   [self.scrollView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                                   [self.scrollView  footerEndRefreshing];
                                   
                               }
                           }else {
                           
                               [self.scrollView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                               [self.scrollView  footerEndRefreshing];
                               
                           }
                           
        
                       }];
}

//检查网络连接情况
- (void) checkNetWokingStatus {
//    self.netStatus = [GLobalRealReachability currentReachabilityStatus];
    if (self.netStatus == RealStatusNotReachable || self.netStatus == RealStatusUnknown ) {
        if(self.placeholderImageView ) {
            [self.placeholderImageView setImage:[UIImage imageNamed:@"无网络"]];
        }
    }else {
        if(self.placeholderImageView ) {
            [self.placeholderImageView setImage:[UIImage imageNamed:@"无数据"]];
        }
    }
    
}
- (FTButton *) selectButton:(NSString *)title {

    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    FTButton *selectBtn = [FTButton buttonWithType:UIButtonTypeCustom option:^(FTButton *button) {
        
        button.imageH = 10;
        button.imageW = 13;
        button.buttonModel = FTButtonModelRightImage;
        button.space = 10.0;
        button.bounds = CGRectMake(0, 0, buttonW, 40);
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:Main_Text_Color forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"下拉-下箭头pre"] forState:UIControlStateHighlighted];
        
        CGSize size =  [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}];

        if (size.width > buttonW - 30-10-13) {
            size = CGSizeMake(buttonW - 30-10-13, size.height);
        }
        
        button.textH = size.height;
        button.textW = size.width;

    }];
    
    return selectBtn;
}



- (void) initSubViews {

    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor colorWithHex:0x131313];
    [self.view addSubview:headerView];
    
    UIView *sepataterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sepataterView.backgroundColor = [UIColor colorWithHex:0x282828];
    [headerView addSubview:sepataterView];
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    
    //格斗种类筛选按钮
    self.kindBtn = [self selectButton:_selectKind];
    self.kindBtn.frame = CGRectMake((buttonW+12)* 0, 0, buttonW, 40);
    [self.kindBtn addTarget:self action:@selector(searchFighterKinds:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.kindBtn];
    
    //格斗赛事筛选按钮
    self.matchBtn = [self selectButton:_selectMatch];
    self.matchBtn .frame = CGRectMake((buttonW+12)* 1, 0, buttonW, 40);
     [self.matchBtn addTarget:self action:@selector(searchFighterMatchs:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.matchBtn];
    
    //格斗重量级筛选按钮
    self.levelBtn = [self selectButton:_selectLevel];
    self.levelBtn .frame = CGRectMake((buttonW+12)* 2, 0, buttonW, 40);
     [self.levelBtn addTarget:self action:@selector(searchFighterLevels:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.levelBtn ];

    
    
    
    for (int i = 1; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"斜线分割"];
        imageView.frame = CGRectMake((buttonW+12)*i -12 , 8, 12, 24);
        [headerView addSubview:imageView];
        
    }
    
    @try {
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.frame = CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104);
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.scrollView.delegate = self;
        self.scrollView.bounces = YES;
        [self jHRefreshAction];//加载上下拉刷新
        [self.view addSubview:self.scrollView];
        
        //第一名视图
        self.headerTableView = [[UITableView alloc]init];
        self.headerTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH,180);
        self.headerTableView.backgroundColor = [UIColor clearColor];
        self.headerTableView.scrollEnabled = NO;
        
        [self.headerTableView registerNib:[UINib nibWithNibName:@"FTRankHeaderCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        self.headerTableView.dataSource = self;
        self.headerTableView.delegate = self;
        [self.headerTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.scrollView addSubview:self.headerTableView];
        
        //tableView 背景阴影
        self.shadow = [[UIImageView alloc]initWithFrame:CGRectMake(0, 179, SCREEN_WIDTH, 50)];
        [self.shadow setImage:[UIImage imageNamed:@"排行第一名底部向下渐变"]];
        self.shadow.backgroundColor = [UIColor clearColor];
        [self.scrollView addSubview:self.shadow];
        
        //tableView 背景
        self.tableImageView = [[UIImageView alloc]init];
        self.tableImageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
        self.tableImageView.frame = CGRectMake(0, 180, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.tableImageView.userInteractionEnabled = YES;
        [self.scrollView addSubview:self.tableImageView];
        
        
        //排名tableView
        self.tableView = [[UITableView alloc]init];
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 180-104);
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.scrollEnabled = NO;
        
        [self.tableView registerNib:[UINib nibWithNibName:@"FTRankTableVIewCell" bundle:nil] forCellReuseIdentifier:@"cellId"];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        
        [self.tableImageView addSubview:self.tableView];
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
    
    
    self.placeholderImageView = [[UIImageView alloc]init];
//    [self.placeholderImageView setBounds:CGRectMake(0, 0, 240, 240)];
//    self.placeholderImageView.center = self.scrollView.center;
    [self.scrollView addSubview:self.placeholderImageView];
    [self.placeholderImageView setFrame:CGRectMake((SCREEN_WIDTH- 240)/2, (SCREEN_HEIGHT-240)/2-104, 240, 240)];
    
//    [self.placeholderImageView setFrame:CGRectMake((SCREEN_WIDTH- 240)/2, (SCREEN_HEIGHT-240)/2, 240, 240)];
//    [self.placeholderImageView setImage:[UIImage imageNamed:@"无数据"]];
//    [self.view addSubview:self.placeholderImageView];
//    [self.placeholderImageView setBackgroundColor:[UIColor whiteColor]];
    [self.placeholderImageView setHidden:YES];
}


- (void) fixViewSize {
    
    
    [self checkNetWokingStatus];
    @try {
        NSInteger count = self.dataArray.count;
        if (count > 0) {
            self.headerTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 180);
            self.tableImageView.frame  = CGRectMake(0, 180, SCREEN_WIDTH, 56*(count-1)+5);
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 56*(count-1));
            
            CGFloat h = 180+56*count;
            
            if (h <= self.scrollView.frame.size.height) {
                h = self.scrollView.frame.size.height+1;
            }
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,h);
            
            [self.headerTableView reloadData];
            [self.tableView reloadData];
//            [self.scrollView setHidden:NO];
            [self.placeholderImageView setHidden:YES];
//            [self.headerTableView setHidden:NO];
//            [self.tableView setHidden:NO];
            [self.shadow setHidden:NO];

        }else {
            self.headerTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            self.tableImageView.frame  = CGRectMake(0, 180, SCREEN_WIDTH, 0);
            self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);
            self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH,self.scrollView.frame.size.height+1);
            
            [self.placeholderImageView setHidden:NO];
//            [self.headerTableView setHidden:YES];
//            [self.tableView setHidden:YES];
            
            [self.shadow setHidden:YES];
//            [self.scrollView setHidden:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
    
}

- (void) viewWillAppear:(BOOL)animated {

    [self fixViewSize];
}

#pragma mark - 获取列表信息

- (void) jHRefreshAction {

    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.scrollView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.pageNum = 0;
        [sself getContentDataFromWeb];
        
    }];
    //设置上拉刷新
    [self.scrollView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.pageNum ++;
        [sself getContentDataFromWeb];
    }];
}

//获取列表筛选标签
- (void) getRankListLabelArray {
    
    NetWorking *net = [[NetWorking alloc]init];
    [net getRankLabels:^(NSDictionary *dict) {
        NSLog(@"Labels:%@",dict);
        if (dict != nil) {
             NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            if ([dict[@"status"] isEqualToString:@"success"]) {
                
                DBManager *dbManager = [DBManager shareDBManager];
                [dbManager connect];
                [dbManager createLabelsTable];
                
                NSArray *labels= dict[@"data"];
                for (NSDictionary *dic in labels) {
//                    NSLog(@"item:%@",[dic[@"item"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//                    NSLog(@"label:%@",[dic[@"label"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
//                    NSLog(@"label:%@",[dic[@"label"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                    
                   
                    [dbManager insertDataIntoLabels:dic];
                    
                }
                
                [dbManager close];
                [self initArray];
            }
        }
    }];
}

#pragma mark - response
//格斗项目检索
- (void) searchFighterKinds:(id)sender {
    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
//    NSLog(@"frame(%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:button
                                                                      style:FTRankTableViewStyleLeft
                                                                     option:^(FTRankTableView *searchTableView) {
                                                                         
                                                
                                                                         searchTableView.dataArray = _kingArray;
                                                                         
                                                                         //设置数据类型
                                                                          searchTableView.dataType = FTDataTypeStringArray;
                                                                         
                                                                         searchTableView.Btnframe = frame;
                                                                         searchTableView.tableW =frame.size.width;
                                                                         searchTableView.tableH = 40*5;
                                                                         
                                                                         searchTableView.offsetY = 40;
                                                                         searchTableView.offsetX = 5;
                                                                         
                                                                         
                                                                         searchTableView.cellH = 40;
                                                                         [searchTableView caculateTableHeight];
                                                                         
                                                                         
                                                                     }];
    
    [self.view addSubview:kindTableView];
    kindTableView.selectDelegate = self;
    [kindTableView  setAnimation];
    
    [kindTableView setDirection:FTAnimationDirectionToTop];
    
    
}


//赛事检索
- (void) searchFighterMatchs:(id)sender {
    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
//    NSLog(@"frame(%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    FTRankTableView *matchableView = [[FTRankTableView alloc]initWithButton:sender
                                                                       style:FTRankTableViewStyleCenter
                                                                     option:^(FTRankTableView *searchTableView) {
                                                                         
                                                                        searchTableView.dataArray = _matchArray;
                                                                         //设置数据类型
                                                                          searchTableView.dataType = FTDataTypeStringArray;
                                                                         
                                                                         searchTableView.Btnframe = frame;
                                                                         searchTableView.tableW =frame.size.width;
                                                                         searchTableView.tableH = 40*5;
                                                                         
                                                                         searchTableView.offsetY = 40;
                                                                         searchTableView.offsetX = 0;
                                                                         
                                                                         searchTableView.cellH = 40;
                                                                         [searchTableView caculateTableHeight];
                                                                     
                                                                         
                                                                     }];
    
    [self.view addSubview:matchableView];
    matchableView.selectDelegate = self;
    [matchableView  setAnimation];
    
    [matchableView setDirection:FTAnimationDirectionToTop];
    
    
}


//重量级检索
- (void) searchFighterLevels:(id)sender {
    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
//    NSLog(@"frame(%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    FTRankTableView *levelTableView = [[FTRankTableView alloc]initWithButton:sender
                                                                      style:FTRankTableViewStyleRight
                                                                     option:^(FTRankTableView *searchTableView) {
                                                                         
                                                                         searchTableView.dataArray = _levelArray;
                                                                         //设置数据类型
                                                                         searchTableView.dataType = FTDataTypeStringArray;
                                                                         
                                                                         searchTableView.Btnframe = frame;
                                                                         searchTableView.tableW =frame.size.width;
                                                                         searchTableView.tableH = 40*5;
                                                                         
                                                                         searchTableView.offsetY = 40;
                                                                         searchTableView.offsetX = -5;
                                                                         
                                                                         searchTableView.cellH = 40;
                                                                         [searchTableView caculateTableHeight];
                                                                     }];
    
    [self.view addSubview:levelTableView];
     levelTableView.selectDelegate = self;
    [levelTableView  setAnimation];
    
    [levelTableView setDirection:FTAnimationDirectionToTop];
    
    
}

#pragma mark FTSelectCellDelegate

- (void) selectedValue:(NSString *)value style:(FTRankTableViewStyle) style {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    
    switch (style) {
        case FTRankTableViewStyleLeft:
        {
           
            _matchArray = [dbManager searchItem:value type:1];
            _levelArray = [dbManager searchItem:value type:2];
            
            _selectKind = value;
            
            if (_matchArray.count > 0) {
                _selectMatch = [_matchArray objectAtIndex:0];
                
            }else {
            
                _selectMatch = @"全部";
            }
            
            if (_levelArray.count > 0) {
                _selectLevel = [_levelArray objectAtIndex:0];
            }else {
            
                _selectLevel = @"全部";
            }
            
            [self.matchBtn setTitle:_selectMatch forState:UIControlStateNormal];
            [self.levelBtn setTitle:_selectLevel forState:UIControlStateNormal];
        }
            break;
        case FTRankTableViewStyleCenter:
        {
            _selectMatch = value;
            
        }
            break;
        case FTRankTableViewStyleRight:
        {
            _selectLevel = value;
        }
            break;
            
        default:
            break;
    }
    
    [dbManager close];
    
    _pageNum = 0;
    [self getContentDataFromWeb];
}



#pragma mark - tableView datasouce and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.tableView) {
        return self.dataArray.count -1;
    }else {
    
        return 1;
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tableView) {
        return 56 ;
    }else {
        
        return 180;
    }

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (tableView == self.tableView) {
        
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row+1];
        NSString *headUrl = dic[@"headUrl"];
        NSString *name = dic[@"name"];
        NSString *rank  = [NSString stringWithFormat:@"%@",dic[@"ranking"]] ;
        NSString *height = dic[@"height"];
        NSString *weight = dic[@"weight"];
//        NSLog(@"cell");
        FTRankTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        [cell.avatarImageView  sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
        [cell.nameLabel setText:name];
        [cell.rankLabel setText:rank];
        [cell.heightLabel setText:[height stringByAppendingString:@"cm"]];
        [cell.weightLabel setText:[weight stringByAppendingString:@"kg"]];
        return cell;
    }else {
        NSDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
        NSString *headUrl = dic[@"background"];
        NSString *name = dic[@"name"];
        NSString *brief = dic[@"brief"];
        NSString *height = dic[@"height"];
        NSString *weight = dic[@"weight"];
        
        FTRankHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
        if (brief != nil) {
            [cell setBriefLabelText:brief];
        }
        
        [cell.avatarImageView  sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"第一名-默认图"]];
        [cell.nameLabel setText:name];
        [cell.heightLabel setText:[height stringByAppendingString:@"cm"]];
        [cell.weightLabel setText:[weight stringByAppendingString:@"kg"]];
        return cell;
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"did select cell");
    NSString *boxerId;
    if (tableView == self.tableView) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSelected:NO];
        boxerId = _dataArray[indexPath.row +1][@"boxerId"];
      
    }else {
         boxerId = _dataArray[indexPath.row ][@"boxerId"];
    }
    
    NSLog(@"boxerId : %@", boxerId);
    FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
    homepageMainVC.boxerId = boxerId;
    [self.navigationController pushViewController:homepageMainVC animated:YES];
}



#pragma mark - private methods
- (NSArray *) fetchLabelsFromDatabase {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSArray *dataArray = [dbManager searchItem:@"拳击" type:1];
    [dbManager close];
    
    return dataArray;
}


@end
