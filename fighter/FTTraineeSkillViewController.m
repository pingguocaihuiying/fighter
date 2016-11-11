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
#import "FTTraineeSubmitPopupView.h"
#import "FTTraineeSkillBean.h"

@interface FTTraineeSkillViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTTraineeSkillViewController

#pragma mark - life cycle
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
    
    self.title = self.bean.createName;
    
    [self setTableView];
}

- (void) setTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTraineeSkillCell" bundle:nil] forCellReuseIdentifier:@"SkillCell"];
    self.tableView.estimatedSectionHeaderHeight = 90;
}

#pragma mark - pull data
- (void) pullDataFromServer {

    NSString *corporationId = [NSString stringWithFormat:@"%ld",self.bean.corporationid];
    [NetWorking getUserSkillsWithCorporationid:corporationId andMemberUserId:self.bean.memberUserId andVersion:nil andParent:nil andOption:^(NSDictionary *dict) {
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
    
    return self.dataArray.count;
//    return self.dataArray.count +10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}



- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FTTraineeSkillSectionHeaderView *headerView = [[FTTraineeSkillSectionHeaderView alloc]init];
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
    
    FTTraineeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillCell"];
    
    FTTraineeSkillBean *bean = [[FTTraineeSkillBean alloc]initWithFTTraineeSkillBeanDic:[self.dataArray objectAtIndex:indexPath.row]];
    [cell  setWithBean:bean];
    
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
    [self popUpView];
}



/**
 提交弹出框
 */
- (void) popUpView {
    
    FTTraineeSubmitPopupView *popUpView = [[FTTraineeSubmitPopupView alloc]init];
    popUpView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    NSDictionary *dic = @{@"前手直拳":@"很好",
                          @"后手直拳":@"好",
                          @"肘击横摆（左）":@"一般",
                          @"肘击横摆（右）":@"差",
                          @"后手勾拳":@"很好",
                          };
    popUpView.skillGradeDic = dic;
    
    [[UIApplication sharedApplication].keyWindow addSubview:popUpView];
    
}
@end
