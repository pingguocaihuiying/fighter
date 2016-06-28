//
//  FTCoachView.m
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCoachView.h"
#import "FTCycleScrollView.h"
#import "FTCoachCell.h"
#import "FTButton.h"

@interface FTCoachView () <UITableViewDelegate, UITableViewDataSource,FTCycleScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)FTCycleScrollView *cycleScrollView;
@property (nonatomic, strong)NSArray *cycleDataSourceArray;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
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
        
        [self initSubviews];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void) initSubviews {
    
    [self initCycleScrollView];
    [self initTableView];
     
}
- (void)initCycleScrollView{
    
    NSMutableArray *imagesURLStrings = [NSMutableArray new];
    NSMutableArray *titlesArray = [NSMutableArray new];
    if (self.cycleDataSourceArray) {
        for(int i = 0; i< 4;i++){
            [imagesURLStrings addObject:[NSURL URLWithString:@"http://www.gogogofight.com/img/news/news1461918192107.jpg"]];
            [titlesArray addObject:@"title"];
            
        }
    }
    _cycleScrollView = [FTCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180 * SCREEN_WIDTH / 375)
                                                          delegate:self
                                                  placeholderImage:[UIImage imageNamed:@"空图标大"]
                                                         cellStyle:FTCycleScrollViewCoach];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    
    //    _cycleScrollView.titlesGroup = titlesArray;
    _cycleScrollView.backgroundColor = [UIColor clearColor];
    
    _cycleScrollView.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"轮播点pre"];
    _cycleScrollView.pageDotImage = [UIImage imageNamed:@"轮播点"];
    _cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    
}

- (void) initTableView {
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(6, 0, self.frame.size.width-12, self.frame.size.height)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:@"FTCoachCell" bundle:nil]  forCellReuseIdentifier:@"coachCell"];
    _tableView.tableHeaderView = _cycleScrollView;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];

}


#pragma mark - delegates
#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 120;
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
