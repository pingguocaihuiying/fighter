//
//  FTMembershipGymView.m
//  fighter
//
//  Created by kang on 2016/11/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTMembershipGymView.h"
#import "FTGymBean.h"
#import "FTGymVIPCellTableViewCell.h"
#import "FTGymDetailBean.h"
#import "FTGymDetailWebViewController.h"
#import "FTGymSourceViewController2.h"
#import "MJRefresh.h"

@interface FTMembershipGymView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataSourceArray;

@property (assign) NSInteger currentPage;
@property (nonatomic, copy) NSString * gymCurrId;
@property (nonatomic, copy) NSString * getType;
@property (nonatomic, copy) NSString *gymTag;    //排序
@property (nonatomic, copy) NSString *gymType;     //格斗项目
@property (nonatomic, copy) NSString *gymType_ZH;     //格斗项目
@end

@implementation FTMembershipGymView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialization];
        [self setNotification];
        
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - init

- (void) initialization {
    
    _currentPage = 1;
    _gymTag = @"1";
    _gymType = @"ALL";
    _gymType_ZH = @"全部";
    _gymCurrId = @"-1";
    _getType = @"new";
    
    [self getTableViewDataFromWeb];
    
}


- (void) setNotification {
    
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void) initSubviews {
    
    
    [self initTableView];
    
}

- (void) initTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, self.frame.size.width-12, self.frame.size.height)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [_tableView registerNib:[UINib nibWithNibName:@"FTGymVIPCellTableViewCell" bundle:nil]  forCellReuseIdentifier:@"gymVIPCell"];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    [self setMJRefresh];
}

#pragma mark - 上下拉刷新
- (void)setMJRefresh{
    //设置下拉刷新
    __weak typeof(self) weakSelf = self;
    // 下拉刷新
    self.tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.mj_header setHidden:NO];
        
        NSLog(@"触发下拉刷新headerView");
        weakSelf.currentPage = 1;
        weakSelf.getType = @"new";
        weakSelf.gymCurrId = @"-1";
        
        [weakSelf getTableViewDataFromWeb];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakSelf.tableView.mj_footer.hidden = NO;
        
        NSLog(@"触发上拉刷新headerView");
        weakSelf.currentPage ++;
        weakSelf.getType = @"old";
        
        if (weakSelf.dataSourceArray && weakSelf.dataSourceArray.count > 0) {
            NSDictionary *dic = [weakSelf.dataSourceArray lastObject];
            weakSelf.gymCurrId = dic[@"gymId"];
        }
        [weakSelf getTableViewDataFromWeb];
    }];

}

#pragma mark - get data from web

// 获取tableView 数据
- (void) getTableViewDataFromWeb {
    
    NSString *showType  = [FTNetConfig showType];
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:_gymType forKey:@"gymType"];
    [dic setObject:_gymCurrId forKey:@"gymCurrId"];
    [dic setObject:_gymTag forKey:@"gymTag"];
    [dic setObject:_getType forKey:@"getType"];
    [dic setObject:showType forKey:@"showType"];
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    // 判断用户登录
    if (userId && userId.length >0) {
        [dic setObject:userId forKey:@"userId"];
    }
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",_gymType,_gymCurrId,_gymTag, _getType, ts, @"quanjijia222222"]];
    
    [dic setObject:ts forKey:@"ts"];
    [dic setObject:checkSign forKey:@"checkSign"];
    
    NSString *urlString = [NSString stringWithFormat:@"gymType=%@&gymCurrId=%@&gymTag=%@&getType=%@&ts=%@&checkSign=%@",_gymType,_gymCurrId,_gymTag,_getType, ts,checkSign];
    NSLog(@"urlstring:%@",urlString);
    [NetWorking getGymsByDic:dic option:^(NSDictionary *dict) {
        self.tableView.mj_footer.hidden = YES;
        self.tableView.mj_header.hidden = YES;
        
        SLog(@"table dic:%@",dict);
        
        //        NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        if (dict == nil) {
            return ;
        }
            
        NSArray *tempArray = dict[@"data"];
        SLog(@"gymType：%@",[tempArray[0][@"gymType"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        
        if ([_getType isEqualToString:@"new"]) {
            _dataSourceArray = [NSMutableArray arrayWithArray:tempArray];
            
        }else {
            [_dataSourceArray addObjectsFromArray:tempArray];
            [self sortArray];
        }
        
        [_tableView reloadData];
        
    }];
}

/**
 拳馆列表数据排重
 */
- (void) sortArray {
    
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    
    for (unsigned i = 0; i < [_dataSourceArray count]; i++){
        
        if ([categoryArray containsObject:[_dataSourceArray objectAtIndex:i]] == NO){
            
            [categoryArray addObject:[_dataSourceArray objectAtIndex:i]];
        }
    }
    
    [_dataSourceArray removeAllObjects];
    [_dataSourceArray addObjectsFromArray:categoryArray];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataSourceArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   return 400;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = [_dataSourceArray objectAtIndex:indexPath.row];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:dic];
    
    
    FTGymVIPCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gymVIPCell"];
    
    [cell setValueWithBean:bean];
    // 进入拳馆按钮
    cell.gymAccessButton.tag = [indexPath row];
    [cell.gymAccessButton addTarget:self action:@selector(enterGymBUttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;

}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = [self.dataSourceArray objectAtIndex:indexPath.row];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:newsDic];
    
    FTGymDetailBean *detailBean = [FTGymDetailBean new];
    detailBean.gym_name = bean.gymName;
    detailBean.corporationid = [bean.corporationid intValue];
    
    FTGymDetailWebViewController *gymDetailWebViewController = [FTGymDetailWebViewController new];
    gymDetailWebViewController.gymBean = bean;
    gymDetailWebViewController.gymDetailBean = detailBean;
    
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:gymDetailWebViewController];
    }
}

#pragma mark - response

- (void) enterGymBUttonAction:(UIButton *) sender {
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = [self.dataSourceArray objectAtIndex:sender.tag];
    FTGymBean *bean = [FTGymBean new];
    [bean setValuesWithDic:newsDic];
    
    FTGymSourceViewController2 *gymSourceViewController = [FTGymSourceViewController2 new];
    FTGymDetailBean *detailBean = [FTGymDetailBean new];
    detailBean.gym_name = bean.gymName;
    detailBean.corporationid = [bean.corporationid intValue];
    gymSourceViewController.gymDetailBean = detailBean;
    
    
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:gymSourceViewController];
    }
}


#pragma mark - 通知事件

// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    
    // 退出登录
    if ([userInfo[@"type"] isEqualToString:@"Logout"]) {
        self.currentPage = 1;
        self.getType = @"new";
        self.gymCurrId = @"-1";
        
        [self getTableViewDataFromWeb];
        
        return;
    }
    
    // 登录
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self getTableViewDataFromWeb];
    }
    
}


@end
