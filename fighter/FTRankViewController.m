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

@interface FTRankViewController ()

@property (nonatomic, strong) FTButton *kindBtn;
@property (nonatomic, strong) FTButton *matchBtn;
@property (nonatomic, strong) FTButton *levelBtn;

@end

@implementation FTRankViewController

- (void) loadView {
    [super loadView];
    NSLog(@"loadView");
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSLog(@"viewDidLoad");

    self.title = @"格斗之王";
    
    
    
    
//    [self setButton];
    [self initSubViews];
    
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
//    headerView.backgroundColor = [UIColor blackColor];
//    [headerView  setTintColor:[UIColor blackColor]];
//    headerView.backgroundColor = self.navigationController.navigationBar.backgroundColor;
    [self.view addSubview:headerView];
    
    UIView *sepataterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    sepataterView.backgroundColor = [UIColor colorWithHex:0x282828];
    [headerView addSubview:sepataterView];
    
    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    
    //格斗种类筛选按钮
    self.kindBtn = [self selectButton:@"拳击"];
    self.kindBtn.frame = CGRectMake((buttonW+12)* 0, 0, buttonW, 40);
    [self.kindBtn addTarget:self action:@selector(searchFighterKinds:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:self.kindBtn];
    
    //格斗赛事筛选按钮
    self.matchBtn = [self selectButton:@"WBA"];
    self.matchBtn .frame = CGRectMake((buttonW+12)* 1, 0, buttonW, 40);
    [headerView addSubview:self.matchBtn ];
    
    //格斗重量级筛选按钮
    self.levelBtn = [self selectButton:@"50kg级"];
    self.levelBtn .frame = CGRectMake((buttonW+12)* 2, 0, buttonW, 40);
    [headerView addSubview:self.levelBtn ];

    
    
    
    for (int i = 1; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"斜线分割"];
        imageView.frame = CGRectMake((buttonW+12)*i -12 , 8, 12, 24);
        [headerView addSubview:imageView];
        
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"viewWillAppear");
}

- (void) viewDidAppear:(BOOL)animated {
    NSLog(@"viewDidappear");
}


#pragma mark - response 
- (void) searchFighterKinds:(id)sender {
    UIButton *button = sender;

    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender
                                                                       type:FTRankTableViewTypeKind
                                                                     option:^(FTRankTableView *searchTableView) {
                                                                         
                                                                         searchTableView.dataArray = [[NSArray alloc] initWithObjects:@"拳击",@"综合格斗综合格斗综合格斗",@"散打",@"自由搏击",@"跆拳道",@"截拳道",@"sadasdfasdfasdfsadfsafsadfsa",nil];
                                                                         
                                                                         searchTableView.tableW = button.frame.size.width;
                                                                         searchTableView.offsetY = 40;
                                                                          searchTableView.offsetX = 5;
                                                                         
                                                                         
    }];
    
    [self.view addSubview:kindTableView];
    
    [kindTableView  setAnimation];
    
    [kindTableView setDirection:FTAnimationDirectionToTop];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
