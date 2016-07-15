//
//  FTCoachView.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCoachView.h"
#import "FTCoachCell.h"
#import "FTButton.h"
#import "FTCycleScrollView.h"
#import "FTCycleScrollViewCell.h"
#import "FTRankTableView.h"
#import "FTHomepageMainViewController.h"
#import "JHRefresh.h"

@interface FTCoachView () <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, FTCycleScrollViewDelegate,FTSelectCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FTCycleScrollView *coachCycleScrollView;
//@property (nonatomic, strong)TestCycleView *coachCycleScrollView;

@property (nonatomic, strong)NSMutableArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;

@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *order;    //排序
@property (nonatomic, copy) NSString *label;     //格斗项目
@property (nonatomic, copy) NSString *label_ZH;     //格斗项目

@property (nonatomic, copy) NSString * coachCurrId;
@property (nonatomic, copy) NSString * getType;

@property (assign) NSInteger currentPage;
@property (assign) NSInteger pageSize;

@end

@implementation FTCoachView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id) initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialization];
//        [self initSubviews];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


- (void) initialization {
    
    _currentPage = 1;
    
    _order = @"time";
    _label = @"ALL";
    _label_ZH = @"全部";
    _coachCurrId = @"-1";
    _getType = @"new";
    
    _currentPage = 1;
    _pageSize = 10;
    
    [self getCycleScrollViewDataFromWeb];
    [self getTableViewDataFromWeb];
    
}

- (void) initSubviews {
    
    [self initCycleScrollView];
    [self initTableView];
   
}

- (void)initCycleScrollView{
    

    _coachCycleScrollView = [FTCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375)
                                                                delegate:self
                                                        placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
    _coachCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    _coachCycleScrollView.backgroundColor = [UIColor clearColor];
    _coachCycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _coachCycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _coachCycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
    _coachCycleScrollView.cycleCount = _cycleDataSourceArray.count;
//     _coachCycleScrollView.dataArray = _cycleDataSourceArray;
    [_coachCycleScrollView.mainView registerNib:[UINib nibWithNibName:@"FTCycleScrollViewCell" bundle:nil] forCellWithReuseIdentifier:@"coachScrollCell"];
    _coachCycleScrollView.mainView.dataSource = self;
    _coachCycleScrollView.mainView.delegate = self;

}

- (void) initTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, self.frame.size.width-12, self.frame.size.height)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"FTCoachCell" bundle:nil]  forCellReuseIdentifier:@"coachCell"];
//    _tableView.tableHeaderView = _cycleScrollView;
    _tableView.tableHeaderView = _coachCycleScrollView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    [self setJHRefresh];//设置上下拉刷新
}

#pragma mark - get data from web

// 获取轮播图数据
- (void) getCycleScrollViewDataFromWeb {
    
    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"hot" forKey:@"order"];
    [dic setObject:@"1" forKey:@"hot"];
    
    [NetWorking getCoachsByDic:dic option:^(NSDictionary *dict) {
        
       
        NSLog(@"cycle dict:%@",dict);
        if (dict != nil) {
            
            if ([dict[@"status"] isEqualToString:@"success"] ) {
                
                NSMutableArray *tempArray = dict[@"data"];
                if (tempArray.count > 0) {
                    _cycleDataSourceArray = tempArray;
                    [self initCycleScrollView];
                }
                
            }
            
        }
        
        [self initTableView];
        
    }];

}

// 获取tableView 数据
- (void) getTableViewDataFromWeb {

    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:_order forKey:@"order"];
    
    NSNumber *pageSize = [NSNumber numberWithInteger:_pageSize];
    NSNumber *pageNum = [NSNumber numberWithInteger:_currentPage];
    
    [dic setObject:pageSize forKey:@"pageSize"];
    [dic setObject:pageNum forKey:@"pageNum"];
    
    if (_label && _label.length > 0 && ![_label isEqualToString:@"ALL"]) {
        [dic setObject:_label forKey:@"labels"];
    }
    
    if (_address && _address.length > 0) {
        [dic setObject:_address forKey:@"address"];
    }
    
    [NetWorking getCoachsByDic:dic option:^(NSDictionary *dict) {
        
        [self.tableView footerEndRefreshing];
        NSLog(@"table dict:%@",dict);
        if (dict != nil) {
        
           if ([dict[@"status"] isEqualToString:@"success"] ) {
                
                NSArray *tempArray = dict[@"data"];
                if (_currentPage == 1) {
                    _tableViewDataSourceArray = [NSMutableArray arrayWithArray:tempArray];
                }else {
                
                    [_tableViewDataSourceArray addObjectsFromArray:tempArray];
                }
               
               [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
               [_tableView reloadData];
            }else {
            
                [self.tableView headerEndRefreshingWithResult:JHRefreshResultNone];
            }
            
        }else {
            [self.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
        }
        
    }];
}


#pragma mark - 上下拉刷新
- (void)setJHRefresh{
    //设置下拉刷新
    __block typeof(self) sself = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        //发请求的方法区域
        NSLog(@"触发下拉刷新headerView");
        sself.currentPage = 1;
        [sself getTableViewDataFromWeb];
        
    }];
    //设置上拉刷新
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        NSLog(@"触发上拉刷新headerView");
        sself.currentPage ++;
//        NSString *currId;
//        if (sself.tableViewDataSourceArray && sself.tableViewDataSourceArray.count > 0) {
//            FTUserBean *bean = [sself.tableViewDataSourceArray lastObject];
//            currId = bean.userid;
//        }else{
//            return;
//        }
        
        [sself getTableViewDataFromWeb];
    }];
}


#pragma mark - delegates

#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cycleDataSourceArray.count *100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = [_cycleDataSourceArray objectAtIndex:indexPath.row%_cycleDataSourceArray.count];
    
    FTCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"coachScrollCell" forIndexPath:indexPath];
    
    [cell.title setText:dic[@"name"]];
    [cell.subtitle setText:dic[@"brief"]];
    [cell.brief setText:dic[@"remark"]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"background"]] placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *coachId;
    NSString *userId;
    
    NSDictionary *dic = [_cycleDataSourceArray objectAtIndex:indexPath.row%_cycleDataSourceArray.count];
    coachId = dic[@"id"];
    userId= dic[@"userId"];
    
    NSLog(@"boxerId : %@", coachId);
    NSLog(@"userId : %@", userId);
    
    //如果名字等于“暂时空缺“，不响应点击事件
    if ([dic[@"name"] isEqualToString:@"暂时空缺"]) {
        return;
    }
    
    FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
    homepageMainVC.coachId = coachId;
    homepageMainVC.olduserid = userId;
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:homepageMainVC];
    }
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @try {
        
    if (scrollView == _coachCycleScrollView.mainView) {
        
        [_coachCycleScrollView mainViewDidScroll:scrollView];
    }
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == _coachCycleScrollView.mainView) {
        
        [_coachCycleScrollView mainViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _coachCycleScrollView.mainView) {
        
        [_coachCycleScrollView mainViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
//    if (scrollView == _coachCycleScrollView.mainView) {
//        
//        [_coachCycleScrollView mainViewDidEndScrollingAnimation:scrollView];
//    }
}


#pragma mark SDCycleScrollViewDelegate

/** 图片滚动回调 */
- (void)cycleScrollView:(FTCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {

    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewDataSourceArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    static FTCoachCell * cell =nil;
    static dispatch_once_t tonceToken;
    dispatch_once(&tonceToken, ^{
        cell = [tableView dequeueReusableCellWithIdentifier:@"coachCell"];
    });
    
    NSDictionary *dic = [_tableViewDataSourceArray objectAtIndex:indexPath.row];
    CGFloat labelView_H = [cell caculateHeight:dic[@"labels"]];
    if (labelView_H == 0) {
        return 88;
    }
    return 95 + labelView_H;
}

//headerView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    
    return 50;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    sectionHeader.backgroundColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headerView.backgroundColor = [UIColor colorWithHex:0x131313];
    
    UIView *sepataterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    sepataterView.backgroundColor = [UIColor colorWithHex:0x282828];
    [headerView addSubview:sepataterView];
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    
    // 教练地址筛选按钮
    FTButton *addressBtn = [FTButton buttonWithtitle:@"北京"];
    addressBtn.frame = CGRectMake((buttonW+12)* 0, 0, buttonW, 40);
    [addressBtn addTarget:self action:@selector(addressBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addressBtn];
    
    // 教练排序按钮
    FTButton *orderBtn = [FTButton buttonWithtitle:@"按时间"];
    orderBtn .frame = CGRectMake((buttonW+12)* 1, 0, buttonW, 40);
    [orderBtn addTarget:self action:@selector(orderBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:orderBtn];
    
    // 教练项目按钮
    FTButton *kindBtn = [FTButton buttonWithtitle:_label_ZH];
    kindBtn .frame = CGRectMake((buttonW+12)* 2, 0, buttonW, 40);
    [kindBtn addTarget:self action:@selector(kindBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:kindBtn ];
    
    
    for (int i = 1; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"斜线分割"];
        imageView.frame = CGRectMake((buttonW+12)*i -12 , 8, 12, 24);
        [headerView addSubview:imageView];
        
    }
    
    [sectionHeader addSubview:headerView];
    return sectionHeader;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
        
    
    FTCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coachCell"];
    cell.backgroundColor = [UIColor clearColor];
    @try {
    NSDictionary *dic = [_tableViewDataSourceArray objectAtIndex:indexPath.row];

    [cell.title setText:dic[@"name"]];
    [cell.subtitle setText:dic[@"brief"]];
    NSInteger fansCount = [dic[@"fansCount"] integerValue];
    [cell.fansNum setText:[NSString stringWithFormat:@"%ld",(long)fansCount ]];
    
    [cell.avatarImageView.layer setMasksToBounds:YES];
    cell.avatarImageView.layer.cornerRadius = 20;
    
    [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"headUrl"]] placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    
    [cell clearLabelView];
    [cell labelsViewAdapter:dic[@"labels"]];
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    } @finally {
        
    }
  
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    NSString *coachId;
    NSString *userId;
    
    NSDictionary *dic = [_tableViewDataSourceArray objectAtIndex:indexPath.row];
    coachId = dic[@"id"];
    userId= dic[@"userId"];
    
    NSLog(@"boxerId : %@", coachId);
    NSLog(@"userId : %@", userId);
    
    //如果名字等于“暂时空缺“，不响应点击事件
    if ([dic[@"name"] isEqualToString:@"暂时空缺"]) {
        return;
    }
    
    FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
    homepageMainVC.coachId = coachId;
    homepageMainVC.olduserid = userId;
    if ([self.delegate respondsToSelector:@selector(pushToController:)]) {
        [self.delegate pushToController:homepageMainVC];
    }
}

#pragma mark -FTSelectCellDelegate

- (void) selectedValue:(NSDictionary *)dic {

   
    _label = dic[@"itemValueEn"];
    _label_ZH = dic[@"itemValue"];
    
    [self getTableViewDataFromWeb];
}
- (void) selectedValue:(NSString *)value style:(FTRankTableViewStyle)style {
    
    if (style == FTRankTableViewStyleLeft) {
        if ([value isEqualToString:@"全部"]) {
            _address = nil;
            
        }else {
        
            _address = value;
        }
        
    }else if (style == FTRankTableViewStyleCenter) {
        _order = value;

    }else if (style == FTRankTableViewStyleRight) {
        
        if ([value isEqualToString:@"全部"]) {
            _label = nil;
        }else {
            _label = value;
        }
    }
    
    [self getTableViewDataFromWeb];
}

#pragma mark - response 

- (void) addressBtnAction:(id) sender {

    
}

- (void) orderBtnAction:(id) sender {

//    UIButton *button = sender;
//    CGRect frame = [self convertRect:button.frame fromView:button.superview];
//    
//    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleCenter option:^(FTRankTableView *searchTableView) {
//        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
//        [tempArray insertObject:@{@"itemValue":@"按时间", @"itemValueEn":@"time"} atIndex:0];
//        [tempArray insertObject:@{@"itemValue":@"按人气", @"itemValueEn":@"fansCount"} atIndex:1];
//        searchTableView.dataArray = tempArray;
//        searchTableView.dataType = FTDataTypeDicArray;
//        searchTableView.Btnframe = frame;
//        searchTableView.tableW =frame.size.width;
//        
//        searchTableView.tableH = 40*5;
//        
//        searchTableView.offsetY = 40;
//        searchTableView.offsetX = 0;
//        
//        searchTableView.cellH = 40;
//        [searchTableView caculateTableHeight];
//        
//    }];
//    kindTableView.selectDelegate = self;
//    [self addSubview:kindTableView];

}


- (void) kindBtnAction:(id) sender {

    
    
    UIButton *button = sender;
    CGRect frame = [self convertRect:button.frame fromView:button.superview];
    
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleRight option:^(FTRankTableView *searchTableView) {
        
        NSMutableArray *array = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
        
        NSMutableDictionary *dic = [NSMutableDictionary new];
        [dic setObject:@"ALL" forKey:@"itemValueEn"];
        [dic setObject:@"全部" forKey:@"itemValue"];
        [array insertObject:dic atIndex:0];
        
        searchTableView.dataArray = array;
        searchTableView.dataType = FTDataTypeDicArray;
        searchTableView.Btnframe = frame;
        searchTableView.tableW =frame.size.width;
        
        searchTableView.offsetY = 40;
        searchTableView.offsetX = -5;
        
        searchTableView.cellH = 40;
        if (array.count * 40 > self.frame.size.height-40-frame.origin.y) {
        
            searchTableView.tableH = self.frame.size.height-40-frame.origin.y;
        }else {
            searchTableView.tableH = array.count * 40;
        }
        
//        [searchTableView caculateTableHeight];
        
    }];
    kindTableView.selectDelegate = self;
    [self addSubview:kindTableView];
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

@end
