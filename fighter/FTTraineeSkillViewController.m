//
//  FTTraineeSkillViewController.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillViewController.h"
#import "FTTraineeSkillCell.h"
#import "FTTraineeSkillSectionHeaderView.h"
#import "FTTraineeGradeViewController.h"

@interface FTTraineeSkillViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTTraineeSkillViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbarStyle];
    [self setSubView];
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
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTraineeSkillCell" bundle:nil] forCellReuseIdentifier:@"SkillCell"];
    
    //    self.tableView.estimatedRowHeight = 310; // 设置为一个接近于行高“平均值”的数值
    self.tableView.estimatedSectionHeaderHeight = 90;
}

#pragma mark  - delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 90;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FTTraineeSkillSectionHeaderView *headerView = [[FTTraineeSkillSectionHeaderView alloc]init];
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSKernAttributeName : @(1.5f)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, @"".length)];
    
    headerView.detailAttributeString = attributedString;
    headerView.title = @"";
    
    return headerView;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillCell"];
    cell.skillLabel.text = @"前手直拳：";
    cell.gradeLabel.text = @"8888";
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FTTraineeGradeViewController *gradeVC = [[FTTraineeGradeViewController alloc]init];
    [self.navigationController pushViewController:gradeVC animated:YES];
}

#pragma mark - response
//- (void) backBtnAction:(id) sender {
//    
//}
- (void) submitAction:(id) sender {
    
}



@end
