//
//  FTChooseGymListViewController.m
//  fighter
//
//  Created by Liyz on 6/30/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTChooseGymListViewController.h"
#import "FTGymCell.h"
#import "FTButton.h"
#import "FTRankTableView.h"
#import "FTGymDetailViewController.h"

@interface FTChooseGymListViewController ()<UITableViewDelegate, UITableViewDataSource, FTSelectCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *gymsTableview;
//@property (nonatomic, strong)  FTRankTableView *kindTableView;
@end

@implementation FTChooseGymListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

//初始化subviews
- (void)initSubViews{
    self.bottomGradualChangeView.hidden = YES;//隐藏底部的遮罩
    
    [self setNavigationBar];//设置导航栏
    [self setTableView];
}

- (void)setNavigationBar{
    self.navigationItem.title = @"选择拳馆";//设置默认标题
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //格斗种类筛选按钮
    FTButton *rightButton = [self selectButton:@"按项目"];

    rightButton.frame = CGRectMake(0, 0, 130, 40);
    [rightButton addTarget:self action:@selector(sortByTypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *sortByTypeButton = [[UIBarButtonItem alloc]initWithCustomView:rightButton];

    self.navigationItem.rightBarButtonItem = sortByTypeButton;
}

//生成右上角的按钮FTButton
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


- (void)setTableView{
    _gymsTableview.delegate = self;
    _gymsTableview.dataSource = self;
    [_gymsTableview registerNib:[UINib nibWithNibName:@"FTGymCell" bundle:nil] forCellReuseIdentifier:@"gymCell"];
    [_gymsTableview reloadData];
}
#pragma -mark -设置tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTGymCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gymCell"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index.path.row : %ld", indexPath.row);
    FTGymDetailViewController *gymDetailViewController = [FTGymDetailViewController new];
    [self.navigationController pushViewController:gymDetailViewController animated:YES];
}

- (void)sortByTypeButtonClicked:(id)sender{
    NSLog(@"sortByTypeButtonClicked");
    [self setDropDown:sender];
}
#pragma -mark -下拉框
- (void)setDropDown:(id)sender{
    
    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];

        FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleLeft option:^(FTRankTableView *searchTableView) {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
            [tempArray insertObject:@{@"itemValue":@"全部项目", @"itemValueEn":@"All"} atIndex:0];
            searchTableView.dataArray = tempArray;
            
            searchTableView.Btnframe = frame;
            searchTableView.tableW =frame.size.width;
            
            searchTableView.offsetX = -10;
            searchTableView.offsetY = 42;
            searchTableView.tableW = 100;
            searchTableView.tableH = 350;
        }];
        kindTableView.selectDelegate = self;
//        [self.view addSubview:kindTableView];
    [[UIApplication sharedApplication].keyWindow addSubview:kindTableView];
    
        [kindTableView  setAnimation];
        
        [kindTableView setDirection:FTAnimationDirectionToTop];
    
    
}

- (void) selectedValue:(NSDictionary *)value{
        NSLog(@"%@", value[@"itemValueEn"]);
}


/**
 *  返回上一个viewController
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
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
