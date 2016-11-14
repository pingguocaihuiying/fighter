//
//  FTTraineeGradeViewController.m
//  fighter
//
//  Created by kang on 2016/11/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeGradeViewController.h"
#import "FTTraineeSkillSectionHeaderView.h"
#import "FTTraineeGradeCell.h"
#import "FTTraineeSkillBean.h"

@interface FTTraineeGradeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTTraineeGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self setSubViews];
    [self pullDataFromServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark  - 设置


/**
 设置到导航栏样式
 */
- (void) setNavigationbar {
    
    //导航栏右侧按钮
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@"发表"
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(submitAction:)];
    
    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
}


- (void) setSubViews {
    
    [self setTableView];
}

- (void) setTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //    self.tableView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTraineeGradeCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
    //    [self.tableView registerClass:[FTTraineeSkillSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HeaderView"];
    //    self.tableView.estimatedRowHeight = 310; // 设置为一个接近于行高“平均值”的数值
    self.tableView.estimatedSectionHeaderHeight = 90;
}


#pragma mark - pull data
- (void) pullDataFromServer {
    
    NSString *corporationId = [NSString stringWithFormat:@"%ld",self.bean.corporationid];
    NSString *parent = [NSString stringWithFormat:@"%ld",self.skillBean.parent];
    [NetWorking getUserSkillsWithCorporationid:corporationId andMemberUserId:self.bean.memberUserId andVersion:nil andParent:parent andOption:^(NSDictionary *dict) {
        SLog(@"dic:%@",dict);
        if (!dict) {
            return;
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"]?YES:NO;
        if(status) {
            self.dataArray = dict[@"data"][@"skills"];
            [self.tableView reloadData];
        }
    }];
}


#pragma mark  - delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.dataArray.count;
    return self.dataArray.count +10;
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
    
    //    FTTraineeSkillSectionHeaderView *headerView = (FTTraineeSkillSectionHeaderView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HeaderView"];
    headerView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    NSString *detail = @"教练要为学员技能负责，一般来说，学员技能水平提升。如有特殊情况请速与管理员联系";
    
    NSMutableAttributedString *attributedString =  [[NSMutableAttributedString alloc] initWithString:detail attributes:@{NSKernAttributeName : @(1.0f)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, detail.length)];
    
    headerView.detailAttributeString = attributedString;
    headerView.title = @"本节课可为5项技术评分";
    
    return headerView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell"];
    cell.skillLabel.text = @"前手直拳：";
    cell.gradeLabel.text = @"8888";
    
    FTTraineeSkillBean *bean = [[FTTraineeSkillBean alloc]initWithFTTraineeSkillBeanDic:[self.dataArray objectAtIndex:indexPath.row]];
    cell.skillLabel.text = bean.name;
    cell.gradeLabel.text = [NSString stringWithFormat:@"%ld",bean.score];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    FTTraineeGradeViewController *gradeVC = [[FTTraineeGradeViewController alloc]init];
//    [self.navigationController pushViewController:gradeVC animated:YES];
}

#pragma mark - response
//- (void) backBtnAction:(id) sender {
//
//}
- (void) submitAction:(id) sender {
    
}



@end
