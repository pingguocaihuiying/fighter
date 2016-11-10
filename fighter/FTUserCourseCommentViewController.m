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
    [self loadDataFromServer];
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
    _commentView = [[[NSBundle mainBundle]loadNibNamed:@"FTCoachCommentBottomView" owner:self options:nil]firstObject];//加载底部评论内容view
    _commentView.frame = _commentContentView.bounds;
    
    [_commentContentView addSubview:_commentView];
}

- (void) setTableView {
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"FTUserSkillGradeTableViewCell" bundle:nil] forCellReuseIdentifier:@"GradeCell"];
    self.tableView.estimatedSectionHeaderHeight = 90;
}

#pragma mark  - delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    //    return self.dataArray.count;
    return _skillScoreArray.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 90;
//}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    FTUserCourseCommentHeaderView *userCourseCommentHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"FTUserCourseCommentHeaderView" owner:self options:nil]firstObject];
    [userCourseCommentHeaderView addTopDividingLine];
    return userCourseCommentHeaderView;
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTUserSkillGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell"];
    cell.skillLabel.text = @"前手直拳：";
    cell.gradeLabel.text = @"8888";
    
    FTUserSkillScore *bean = _skillScoreArray[indexPath.row];

    [cell setWithBean:bean];
    
    
    return cell;
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

