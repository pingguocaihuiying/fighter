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
@property (copy, nonatomic) NSMutableArray *dataArray;
@property (copy, nonatomic) NSMutableDictionary *subDic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) NSInteger shouldEditNum;
@property (nonatomic, copy) TransmitParamsBlock paramsBlock;
@property (copy, nonatomic) NSMutableDictionary *editItems; // 已评分项

@end

@implementation FTTraineeSkillViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self setSubViews];
    
//    [self getShouldEditSkillNumber];
    [self pullDataFromServer];
    
    [self initData];
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
    self.tableView.estimatedSectionHeaderHeight = 100;
}


- (void) initData {
    
    __weak typeof(self) weakSelf = self;
    self.paramsBlock = ^(NSMutableDictionary *dic) {
        
        if (dic!= weakSelf.editItems) {
            weakSelf.editItems = dic;
        }
    };
}

- (NSMutableDictionary *) editItems {
    
    if (!_editItems) {
        _editItems = [[NSMutableDictionary alloc]init];
    }
    
    return _editItems;
}

- (NSMutableArray *) dataArray {

    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    
    return _dataArray;
}


- (NSMutableDictionary *) subDic {

    if (!_subDic) {
        _subDic = [[NSMutableDictionary alloc]init];
    }
    
    return _subDic;
}

#pragma mark - pull data
- (void) pullDataFromServer {

    NSString *corporationId = [NSString stringWithFormat:@"%ld",self.bean.corporationid];
    NSString *memberUserId = self.bean.memberUserId;
    [NetWorking getUserSkillsWithCorporationid:corporationId andMemberUserId:memberUserId andVersion:nil andParent:nil andOption:^(NSDictionary *dict) {
        SLog(@"dic:%@",dict);
        if (!dict) {
            return;
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"]?YES:NO;
        if(status) {
//            self.dataArray = dict[@"data"][@"skills"];
            [self sortArray:dict[@"data"][@"skills"]];
            [self.tableView reloadData];
        }
    }];
}

- (void) sortArray:(NSArray *)dicArray {
    
    _shouldEditNum = 0;
    for (NSDictionary *dic in dicArray) {
        FTTraineeSkillBean *bean = [[FTTraineeSkillBean alloc]initWithFTTraineeSkillBeanDic:dic];
        if (bean.parent == 0) {
            [self.dataArray addObject:bean];
        }else {
            _shouldEditNum ++;
            NSString *parent = [NSString stringWithFormat:@"%ld",bean.parent];
            if (![self.subDic.allKeys containsObject:parent] ) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                [array addObject:bean];
                [self.subDic setObject:array forKey:parent];
            }else {
                NSMutableArray *array = [self.subDic objectForKey:parent];
                [array addObject:bean];
                [self.subDic setObject:array forKey:parent];
            }
        }
    }
}


- (void) getShouldEditSkillNumber {

    [NetWorking getShouldEditSkillNumber:[NSString stringWithFormat:@"%ld",self.bean.corporationid] option:^(NSDictionary *dict) {
        SLog(@"pullDataFromServer:%@",dict);
        if (!dict) {
            return;
        }
        SLog(@"pullDataFromServer:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
        BOOL status = [dict[@"status"] isEqualToString:@"success"]?YES:NO;
        if(status) {
            _shouldEditNum = [dict[@"data"] integerValue];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
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
    headerView.title =[NSString stringWithFormat:@"本节课可为%ld项技术评分",_shouldEditNum];
    return headerView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SkillCell"];
    
    FTTraineeSkillBean *bean = [self.dataArray objectAtIndex:indexPath.row];
    [cell  setWithBean:bean];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeGradeViewController *gradeVC = [[FTTraineeGradeViewController alloc]init];
    FTTraineeSkillBean *parentBean = [self.dataArray objectAtIndex:indexPath.row];
    NSMutableArray *array = [self.subDic objectForKey:[NSString stringWithFormat:@"%ld",parentBean.id]];
    gradeVC.title = self.title;
    gradeVC.bean = self.bean;
    gradeVC.parentBean = parentBean;
    gradeVC.dataArray = array;
    gradeVC.shouldEditNum = self.shouldEditNum;
    gradeVC.paramsBlock = self.paramsBlock;
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
    
    if (self.editItems.allKeys.count > 0) {
        FTTraineeSubmitPopupView *popUpView = [[FTTraineeSubmitPopupView alloc]init];
        popUpView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        popUpView.bookId = [NSString stringWithFormat:@"%ld",self.bean.bookId];
        //    NSDictionary *dic = @{@"前手直拳":@"很好",
        //                          @"后手直拳":@"好",
        //                          @"肘击横摆（左）":@"一般",
        //                          @"肘击横摆（右）":@"差",
        //                          @"后手勾拳":@"很好",
        //                          };
        popUpView.skillGradeDic = self.editItems;
        
        [[UIApplication sharedApplication].keyWindow addSubview:popUpView];
    }else {
    
        [self.view showMessage:@"还没有给学员评分，赶紧去评分吧~"];
    }
    
    
}
@end
