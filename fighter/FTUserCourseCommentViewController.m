//
//  FTUserCourseCommentViewController.m
//  fighter
//
//  Created by 李懿哲 on 10/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTUserCourseCommentViewController.h"
#import "FTTraineeSkillSectionHeaderView.h"
#import "FTTraineeGradeCell.h"
#import "FTUserSkillGradeTableViewCell.h"
#import "FTUserCourseCommentHeaderView.h"
#import "UIView+DividingLine.h"
#import "FTCoachCommentBottomView.h"
#import "FTUserSkillScore.h"
#import "FTUserCourseHistoryBean.h"
#import "FTUserChildSkillTopInfoView.h"
#import "UILabel+FTLYZLabel.h"
#import "FTTraineeSkillCell.h"
#import "FTUserSkillBean.h"

@interface FTUserCourseCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *commentContentView;

@property (nonatomic, strong) FTCoachCommentBottomView *commentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;


@property (nonatomic, strong) NSMutableArray *skillScoreArray;//存储评分子项的数组

@end

@implementation FTUserCourseCommentViewController

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self setSubViews];
    
    if (_type == FTUserSkillTypeCoachComment) {
        [self loadDataFromServer];
    }else{
        //直接刷新tableView，数据已经从上个页面传递过来了
        [_tableView reloadData];
    }
    
}

- (void)loadDataFromServer{
    [NetWorking getUserSkillsByVersion:@"1" andOption:^(NSDictionary *dic) {
        BOOL status = [dic[@"status"] isEqualToString:@"success"];
        if (1) {
            NSString *commentContent = dic[@"data"][@"evaluation"];
            NSArray *skillScroeArray = dic[@"data"][@"skills"];
            _skillScoreArray = [NSMutableArray new];
            for(NSDictionary *dic in skillScroeArray){
                FTUserSkillScore *skillScoreBean = [FTUserSkillScore new];
                [skillScoreBean setValuesWithDic:dic];
                [_skillScoreArray addObject:skillScoreBean];
            }
            
            for (int i = 0; i < 5; i++) {
                [_skillScoreArray addObject:[self getTestBean]];
            }
            
            //根据教练评论的技能详情，设置tableView的高度、显示内容，以及评论内容
            _tableViewHeight.constant = 45 * _skillScoreArray.count + 76;// 45为cell高度，76为headerView高度
            
            [_tableView reloadData];
            
                //评论内容
            if (commentContent) {
                _commentView.commentContentLabel.text = commentContent;    
            }
            
            
        } else {
            [[[UIApplication sharedApplication]keyWindow] showHUDWithMessage:dic[@"message"]];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark  - 设置


/**
 设置到导航栏样式
 */
- (void) setNavigationbar {
    
    /*
     直接复制小强的代码，这里并不需要右上角的按钮，暂时把有按钮文本置空，设为不可用
     */
    
    //导航栏右侧按钮
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc]initWithTitle:@""
                                                                      style:UIBarButtonItemStyleDone
                                                                     target:self
                                                                     action:@selector(submitAction:)];
    
    [rightBarButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}


- (void) setSubViews {
    
    [self setTableView];
    
    if (_type == FTUserSkillTypeCoachComment) {//如果是教练评论的，才加载底部的评论内容view
        [self setBottomCommentContentView];
    }
}

- (void)setBottomCommentContentView{
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"FTCoachCommentBottomView" owner:self options:nil]firstObject];//加载底部评论内容view
    _commentView.frame = _commentContentView.bounds;
    
    [_commentContentView addSubview:_commentView];
}
    
- (void) setTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //根据_type类型去加载对应的cell文件
    if (_type == FTUserSkillTypeCoachComment) {
    [self.tableView registerNib:[UINib nibWithNibName:@"FTUserSkillGradeTableViewCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
    }else if(_type == FTUserSkillTypeChildSkill){
            [self.tableView registerNib:[UINib nibWithNibName:@"FTTraineeSkillCell" bundle:nil] forCellReuseIdentifier:@"GradeCell2"];
    }

    self.tableView.estimatedSectionHeaderHeight = 90;
}

#pragma mark  - delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_type == FTUserSkillTypeCoachComment) {
        if (_skillScoreArray) {
            return _skillScoreArray.count;
        }
        
    }else if(_type == FTUserSkillTypeChildSkill){
        if (_skillArray) {
            return _skillArray.count;
        }
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 90;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_type == FTUserSkillTypeCoachComment) {
        FTUserCourseCommentHeaderView *userCourseCommentHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"FTUserCourseCommentHeaderView" owner:self options:nil]firstObject];
        [userCourseCommentHeaderView addTopDividingLine];
        return userCourseCommentHeaderView;
    } else {
        FTUserChildSkillTopInfoView *userSkilltHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"FTUserChildSkillTopInfoView" owner:self options:nil]firstObject];
        [UILabel setRowGapOfLabel:userSkilltHeaderView.skillDescLabel withValue:7];
        
        return userSkilltHeaderView;
    }
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == FTUserSkillTypeCoachComment) {//如果是教练评论详情
        
        FTUserSkillGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell"];
        cell.skillLabel.text = @"前手直拳：";
        cell.gradeLabel.text = @"8888";
        
        FTUserSkillScore *bean = _skillScoreArray[indexPath.row];
        
        [cell setWithBean:bean];
        
        
        return cell;
        
    }else{//如果是技能子项详情
        
        FTTraineeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell2"];
        
        FTUserSkillBean *beanNew = _skillArray[indexPath.row];
        FTUserSkillBean *beanOld = _skillArrayOld[indexPath.row];
        
        if (beanOld) {
            [cell setWithSkillNewBean:beanNew andSkillOldBean:beanOld];
        } else {
            [cell setWithSkillBean:beanNew];
        }
        
        
        return cell;

    }
}


- (FTUserSkillScore *)getTestBean{
    FTUserSkillScore *bean = [FTUserSkillScore new];
    bean.skill = @"降龙十八掌";
    bean.score = 27;
    bean.scoreOld = 25;
    bean.increase = 2;
    return bean;
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

