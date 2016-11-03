//
//  FTTraineeSkillViewController.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillViewController.h"
#import "FTTraineeSkillCell.h"

@interface FTTraineeSkillViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation FTTraineeSkillViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbarStyle];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - 设置


/**
 设置到导航栏样式
 */
- (void) setNavigationbarStyle {
    
    
    //导航栏右侧按钮
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"发表"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(submitAction:)];
    
    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = rightBarButton;
    
}


- (void) setSubView {
    
    [self setTableView];
}

- (void) setTableView {
    
    
}

#pragma mark  - delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 90;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headerView = [[UIView alloc]init];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    UIView *bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    
    topLine.backgroundColor = Cell_Space_Color;
    bottomLine.backgroundColor = Cell_Space_Color;
    
    
    
    return headerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    return nil;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - response
- (void) backBtnAction:(id) sender {
    
}
- (void) submitAction:(id) sender {
    
}



@end
