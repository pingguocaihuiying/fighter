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

@interface FTCoachView () <UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, FTCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FTCycleScrollView *coachCycleScrollView;
@property (nonatomic, strong)NSMutableArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;

@property (nonatomic, copy) NSString *address;  //地址
@property (nonatomic, copy) NSString *order;    //排序
@property (nonatomic, copy) NSString *kind;     //格斗项目

@property (assign) NSInteger currentPage;

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
        [self initSubviews];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}


- (void) initialization {
    
    _currentPage = 0;
    
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
//    _coachCycleScrollView.itemCount = _cycleDataSourceArray.count;
     _coachCycleScrollView.dataArray = _cycleDataSourceArray;
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
                }
                _coachCycleScrollView.dataArray = _cycleDataSourceArray;
                [_coachCycleScrollView.mainView reloadData];
            }else {
                
            }
            
        }else {
            
        }
        
    }];

    
}

// 获取tableView 数据
- (void) getTableViewDataFromWeb {

    NSMutableDictionary *dic = [NSMutableDictionary new];
    [dic setObject:@"time" forKey:@"order"];
    [NetWorking getCoachsByDic:dic option:^(NSDictionary *dict) {
        
        NSLog(@"table dict:%@",dict);
        if (dict != nil) {
        
           if ([dict[@"status"] isEqualToString:@"success"] ) {
                
                NSArray *tempArray = dict[@"data"];
                if (_currentPage == 0) {
                    _tableViewDataSourceArray = [NSMutableArray arrayWithArray:tempArray];
                }else {
                
                    [_tableViewDataSourceArray addObjectsFromArray:tempArray];
                }
               
               [_tableView reloadData];
            }else {
            
                
            }
            
        }else {
        
        }
        
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
    
    NSDictionary *dic = [_cycleDataSourceArray objectAtIndex:indexPath.row%3];
    
        FTCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"coachScrollCell" forIndexPath:indexPath];
    
    [cell.title setText:dic[@"name"]];
    [cell.subtitle setText:dic[@""]];
    [cell.brief setText:dic[@"brief"]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:dic[@"background"]] placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
    
    

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"---点击了第%ld张图片", (long)index);
    //
    //    FTNewsDetail2ViewController *newsDetailViewController = [FTNewsDetail2ViewController new];
    //
    //    //获取对应的bean，传递给下个vc
    //    NSDictionary *newsDic = self.cycleDataSourceArray[index];
    //    FTNewsBean *bean = [FTNewsBean new];
    //    [bean setValuesWithDic:newsDic];
    //
    //    newsDetailViewController.newsBean = bean;
    //
    //    [self.navigationController pushViewController:newsDetailViewController animated:YES];

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

///** 图片滚动回调 */
//- (void)cycleScrollView:(FTCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
//
//    
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _tableViewDataSourceArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 100;
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
    
    //格斗种类筛选按钮
    FTButton *kindBtn = [FTButton buttonWithtitle:@"地域"];
    kindBtn.frame = CGRectMake((buttonW+12)* 0, 0, buttonW, 40);
    [kindBtn addTarget:self action:@selector(searchFighterKinds:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:kindBtn];
    
    //格斗赛事筛选按钮
    FTButton *matchBtn = [FTButton buttonWithtitle:@"人气"];
    matchBtn .frame = CGRectMake((buttonW+12)* 1, 0, buttonW, 40);
    [matchBtn addTarget:self action:@selector(searchFighterMatchs:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:matchBtn];
    
    //格斗重量级筛选按钮
    FTButton *levelBtn = [FTButton buttonWithtitle:@"项目"];
    levelBtn .frame = CGRectMake((buttonW+12)* 2, 0, buttonW, 40);
    [levelBtn addTarget:self action:@selector(searchFighterLevels:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:levelBtn ];
    
    
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
    return cell;
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
