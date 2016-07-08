//
//  FTChooseGymListViewController.m
//  fighter
//
//  Created by Liyz on 6/30/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTChooseGymOrOpponentListViewController.h"
#import "FTGymCell.h"
#import "FTButton.h"
#import "FTRankTableView.h"
#import "FTGymDetailViewController.h"
#import "FTDefaultFullMatchingTableViewCell.h"
#import "FTOpponentCell.h"
#import "FTLaunchNewMatchViewController.h"
#import "FTHomepageMainViewController.h"

@interface FTChooseGymOrOpponentListViewController ()<UITableViewDelegate, UITableViewDataSource, FTSelectCellDelegate, FTDefaultFullyMatchingCellSelected, opponentSelectedDelegate>
@property (weak, nonatomic) IBOutlet UITableView *gymsTableview;
@property (nonatomic, assign)NSInteger curOpponentIndex;
@property (assign, nonatomic) FTMatchType matchType;
@end

@implementation FTChooseGymOrOpponentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self initSubViews];
}

- (void)initBaseData{
    _curOpponentIndex = 0;//默认选择同匹配度任何人
    _matchType = FTMatchTypeFullyMatch;
}
//初始化subviews
- (void)initSubViews{
    self.bottomGradualChangeView.hidden = YES;//隐藏底部的遮罩
    
    [self setNavigationBar];//设置导航栏
    [self setTableView];
}

- (void)setNavigationBar{
    if (_listType == FTGymListType) {
        self.navigationItem.title = @"选择拳馆";//设置默认标题
    }else if (_listType == FTOpponentListType){
        self.navigationItem.title = @"选择对手";//设置默认标题
    }
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    FTButton *rightButton;
    
    //格斗种类（匹配级别）筛选按钮
    if (_listType == FTGymListType) {
        rightButton = [self selectButton:@"按项目"];
    }else if (_listType == FTOpponentListType){
        if (_matchType == FTMatchTypeFullyMatch) {
            rightButton = [self selectButton:@"完全匹配"];
        }else if (_matchType == FTMatchTypeOverOneLevel){
            rightButton = [self selectButton:@"跨越1级别"];
        }else if (_matchType == FTMatchTypeOverTwoLevel){
            rightButton = [self selectButton:@"跨越2级别"];
        }else{
            rightButton = [self selectButton:@"完全匹配"];
        }
        
    }
    

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
    
    if (_listType == FTGymListType) {
    [_gymsTableview registerNib:[UINib nibWithNibName:@"FTGymCell" bundle:nil] forCellReuseIdentifier:@"gymCell"];
    }else if (_listType == FTOpponentListType){
        [_gymsTableview registerNib:[UINib nibWithNibName:@"FTOpponentCell" bundle:nil] forCellReuseIdentifier:@"opponentCell"];
        [_gymsTableview registerNib:[UINib nibWithNibName:@"FTDefaultFullMatchingTableViewCell" bundle:nil] forCellReuseIdentifier:@"fullyMatchingOpponentCell"];
    }
    
    [_gymsTableview reloadData];
}
#pragma -mark -设置tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_listType == FTGymListType) {
        return 108;
    }else if(_listType == FTOpponentListType){
        return 77;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_listType == FTGymListType) {
        FTGymCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gymCell"];
        return cell;
    }else if (_listType == FTOpponentListType){
        if (indexPath.row == 0) {
            FTDefaultFullMatchingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fullyMatchingOpponentCell"];
            cell.delegate = self;
            _curOpponentIndex == 0 ? [cell.checkButton setImage:[UIImage imageNamed:@"弹出框用-类别选择-选中"] forState:UIControlStateNormal] : [cell.checkButton setImage:[UIImage imageNamed:@"弹出框用-类别选择-空"] forState:UIControlStateNormal];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FTOpponentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"opponentCell"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            _curOpponentIndex == indexPath.row ? [cell.challengeButton setImage:[UIImage imageNamed:@"弹出框用-类别选择-选中"] forState:UIControlStateNormal] : [cell.challengeButton setImage:[UIImage imageNamed:@"挑战"] forState:UIControlStateNormal];
            cell.tag = indexPath.row;
            return cell;
        }
    }
    
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index.path.row : %ld", indexPath.row);
    if (_listType == FTGymListType) {
        FTGymDetailViewController *gymDetailViewController = [FTGymDetailViewController new];
        [self.navigationController pushViewController:gymDetailViewController animated:YES];
    }else if (_listType == FTOpponentListType){
        if (indexPath.row == 0) {
            
        }else{
            FTHomepageMainViewController *homepageMainVC = [FTHomepageMainViewController new];
//            homepageMainVC.boxerId = boxerId;
            homepageMainVC.olduserid = @"855bd9552ff0488aa0d0765e9ccd46cc";
            [self.navigationController pushViewController:homepageMainVC animated:YES];
        }
    }

}

- (void)defaultFullyMatchingSelected{
    NSLog(@"完全匹配");
    _curOpponentIndex = 0;
    NSLog(@"_curOpponentIndex : %ld", _curOpponentIndex);
    [_gymsTableview reloadData];
}

- (void)selectOpponentByIndex:(NSInteger)opponentIndex{
    _curOpponentIndex = opponentIndex;
    NSLog(@"_curOpponentIndex : %ld", _curOpponentIndex);
    [_gymsTableview reloadData];
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
            if (_listType == FTGymListType) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[FTNWGetCategory sharedCategories]];
                [tempArray insertObject:@{@"itemValue":@"全部项目", @"itemValueEn":@"All"} atIndex:0];
                searchTableView.dataArray = tempArray;
                searchTableView.tableH = 350;//高度
                searchTableView.offsetX = -10;//水平偏移
            }else if (_listType == FTOpponentListType){
                searchTableView.dataArray = @[@{@"itemValue":@"完全匹配", @"itemValueEn":@"fullyMatching"}, @{@"itemValue":@"跨越1级别", @"itemValueEn":@"over1Level"}, @{@"itemValue":@"跨越2级别", @"itemValueEn":@"over2Level"}];
                searchTableView.tableH = 125;
                searchTableView.offsetX = 20;//水平偏移
            }

            
            searchTableView.Btnframe = frame;
            searchTableView.tableW =frame.size.width;
            
            
            searchTableView.offsetY = 42;
            searchTableView.tableW = 100;
            
        }];
        kindTableView.selectDelegate = self;
//        [self.view addSubview:kindTableView];
    [[UIApplication sharedApplication].keyWindow addSubview:kindTableView];
    
        [kindTableView  setAnimation];
        
        [kindTableView setDirection:FTAnimationDirectionToTop];
    
    
}

- (void) selectedValue:(NSDictionary *)value{
        NSLog(@"%@", value[@"itemValueEn"]);
    NSString *matchTypeString = value[@"itemValueEn"];
    if ([matchTypeString isEqualToString:@"fullyMatching"]) {
        _matchType = FTMatchTypeFullyMatch;
    }else if([matchTypeString isEqualToString:@"over1Level"]){
        _matchType = FTMatchTypeOverOneLevel;
    }else if([matchTypeString isEqualToString:@"over2Level"]){
        _matchType = FTMatchTypeOverTwoLevel;
    }
}


/**
 *  返回上一个viewController
 */
- (void)popVC{
    if (_listType == FTGymListType) {
            [self.navigationController popViewControllerAnimated:YES];
    }else{
        //返回前一个vc
        FTLaunchNewMatchViewController *launchNewMatchViewController = self.navigationController.viewControllers[1];
        launchNewMatchViewController.opponentLabel.text = @"贪睡之熊";
        launchNewMatchViewController.matchType = _matchType;
        [launchNewMatchViewController displayMatchTypeButtons];
        [self.navigationController popToViewController:launchNewMatchViewController animated:YES];
    }
    
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
