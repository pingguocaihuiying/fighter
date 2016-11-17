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
#import "FTCourseHeaderFile.h"
#import "FTTraineeSubmitPopupView.h"

@interface FTTraineeGradeViewController ()<UITableViewDelegate,UITableViewDataSource>
//@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (copy, nonatomic) NSMutableArray *editGrades; // 评分数组
@property (copy, nonatomic) NSMutableArray *editSkills; // 技能点数组

@property (nonatomic, copy) EditSkillBlock editSkillBlock;  // 设置评分字典
@property (nonatomic, copy) NSMutableDictionary *changedScoreDic;  //

@end

@implementation FTTraineeGradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self setSubViews];
//    [self pullDataFromServer];
    [self initData];
}


- (void) viewWillAppear:(BOOL)animated {

    [self addNotification];
}

- (void) viewWillDisappear:(BOOL)animated {
    
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  - 设置


/**
 注册通知
 */
- (void) addNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewController:) name:@"HadGradeSkill" object:nil];
}


/**
 删除通知
 */
- (void) removeNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HadGradeSkill" object:nil];
}



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
    self.tableView.estimatedSectionHeaderHeight = 100;
}

- (void) initData {

    __weak typeof(self) weakSelf = self;
    self.editSkillBlock = ^(NSString *key, NSString *value) {
        
        if (weakSelf.editItems.allKeys.count == weakSelf.shouldEditNum && ![weakSelf.editItems.allKeys containsObject:key]) {
            [weakSelf.view showMessage:[NSString stringWithFormat:@"本次课程最多只能为%ld项技能评分~",weakSelf.shouldEditNum]];
            return NO;
        }else {
        
           [weakSelf editChangedSkillDiction:key Score:value];
            return YES;
        }
    };
}


/**
 编辑评分的技能，统计到字典editItems，以备提交发表

 @param skill 技能名称
 @param score 评分
 */
- (void) editChangedSkillDiction:(NSString *) skill Score:(NSString *) score {

    [self.changedScoreDic setObject:score forKey:skill];
    
    [self.editItems setObject:score forKey:skill];
    if(self.paramsBlock) {
        self.paramsBlock(self.editItems);
    }
}


/**
 统计当前技能点分数变化
 */
- (void) countChangedScoreForCurrentSkill {
    
    NSInteger totalChangeScore = 0;
    for (NSString *key in self.changedScoreDic.allKeys) {
        NSInteger value = [[self.changedScoreDic objectForKey:key] integerValue];
        totalChangeScore += value;
    }
    
    self.parentBean.score =  self.parentBean.score + totalChangeScore;
}

- (NSMutableDictionary *) changedScoreDic {

    if (!_changedScoreDic) {
        _changedScoreDic = [[NSMutableDictionary alloc]init];
    }
    return _changedScoreDic;
}


- (NSMutableDictionary *) editItems {

    if (!_editItems) {
        _editItems = [[NSMutableDictionary alloc]initWithCapacity:_shouldEditNum];
    }
    
    return _editItems;
}


#pragma mark - pull data
- (void) pullDataFromServer {
    
    NSString *corporationId = [NSString stringWithFormat:@"%ld",self.bean.corporationid];
    NSLog(@"corporationId:%@",corporationId);
    NSString *parent = [NSString stringWithFormat:@"%ld",4];
//    NSString *parent = [NSString stringWithFormat:@"%ld",self.parentBean.id];
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
    
        return self.dataArray.count;
//    return self.dataArray.count +10;
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
    headerView.title = [NSString stringWithFormat:@"本节课可为%ld项技术评分",_shouldEditNum];
    
    return headerView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTraineeGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell"];
    FTTraineeSkillBean *bean = [self.dataArray objectAtIndex:indexPath.row];
    [cell setWithBean:bean block:self.editSkillBlock];
    
    return cell;
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
        popUpView.title = self.title;
        popUpView.skillGradeDic = self.editItems;
        popUpView.notificationDic = _notificationDic;
        [[UIApplication sharedApplication].keyWindow addSubview:popUpView];
    }else {
        
        [self.view showMessage:@"还没有给学员评分，赶紧去评分吧~"];
    }
}

/**
 评论成功后返回学员列表
 
 @param noti
 */
- (void) popViewController:(NSNotification *)noti{

    NSArray *controllers = self.navigationController.viewControllers;
    UIViewController *parentController;
    if (controllers.count >=3) {
        parentController = [controllers objectAtIndex:controllers.count - 3];
        [self.navigationController popToViewController:parentController animated:YES];
    }
}


@end
