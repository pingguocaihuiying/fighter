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

@interface FTUserCourseCommentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *commentContentView;

@property (nonatomic, strong) FTCoachCommentBottomView *commentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;
@property (nonatomic, strong) FTUserCourseCommentHeaderView *userCourseCommentHeaderView;//

@property (nonatomic, strong) NSMutableArray *skillScoreArray;//存储评分子项的数组
@property (nonatomic, strong) FTUserChildSkillTopInfoView *userSkilltHeaderView;

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
        if (status) {
            NSArray *skillScroeArray = dic[@"data"][@"skills"];
            _skillScoreArray = [NSMutableArray new];
            for(NSDictionary *dic in skillScroeArray){
                FTUserSkillScore *skillScoreBean = [FTUserSkillScore new];
                [skillScoreBean setValuesWithDic:dic];
                [_skillScoreArray addObject:skillScoreBean];
            }
            
            /*
                评论内容、教练名、头像
             */
            NSString *commentContent = dic[@"data"][@"evaluation"];
            NSString *coachName = dic[@"data"][@"coachName"];
            NSString *coachAvatorURLString = dic[@"data"][@"headUrl"];
            
            /*
             测试数据
             */
//            for (int i = 0; i < 5; i++) {
//                [_skillScoreArray addObject:[self getTestBean]];
//            }
            
            //根据教练评论的技能详情，设置tableView的高度、显示内容，以及评论内容
            _tableViewHeight.constant = 45 * _skillScoreArray.count + 76;// 45为cell高度，76为headerView高度
            
            [_tableView reloadData];
            
                //评论内容
            if (commentContent) {
                _commentView.commentContentLabel.text = commentContent;    
            }
            _commentView.coachNameLabel.text = coachName;
            if (coachAvatorURLString) {
                [_commentView.coachHeaderImageView sd_setImageWithURL:[NSURL URLWithString:coachAvatorURLString]];
            }
            
            
            
        } else {
            [[[UIApplication sharedApplication]keyWindow] showHUDWithMessage:dic[@"message"]];
        }
    }];
}

- (int)getChangeCount:(NSArray *)skillArray{
    int changeCount = 0;
    for (FTUserSkillScore *bean in skillArray){
        if (bean.increase > 0) {
            changeCount++;
        }
    }
    return changeCount;
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


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (_type == FTUserSkillTypeCoachComment) {//教练评论
        _userCourseCommentHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"FTUserCourseCommentHeaderView" owner:self options:nil]firstObject];
        //统计有增长的项
        int changeCount = [self getChangeCount:_skillScoreArray];
        _userCourseCommentHeaderView.titleLabel2.text = [NSString stringWithFormat:@"%d项内容获得了提升！", changeCount];

        [_userCourseCommentHeaderView addTopDividingLine];
        return _userCourseCommentHeaderView;
    } else {//技能属性
        if (!_userSkilltHeaderView) {
            _userSkilltHeaderView = [[[NSBundle mainBundle]loadNibNamed:@"FTUserChildSkillTopInfoView" owner:self options:nil]firstObject];
            [UILabel setRowGapOfLabel:_userSkilltHeaderView.skillDescLabel withValue:7];
        }
        _userSkilltHeaderView.scoreLabel.text = [NSString stringWithFormat:@"%.0f", _fatherSkillBean.score];
        _userSkilltHeaderView.skillName.text = _fatherSkillBean.name;
        [_userSkilltHeaderView.ratingBar displayRating:[self levelOfGrade:_fatherSkillBean.score / _fatherSkillBean.subNumber]];
        
        NSString *skillDesc = [self getParentSkillLevelDesc:_fatherSkillBean];
        
        _userSkilltHeaderView.skillDescLabel.text = skillDesc;
        
        return _userSkilltHeaderView;
    }
}

- (NSString *)getParentSkillLevelDesc:(FTUserSkillBean *)bean{
    NSString *desc = @"";
    
    if (bean) { //如果bean不为空
        //父项的子项个数不能为0
        if (bean.subNumber <= 0) bean.subNumber = 1;
        
        double mark = bean.score / bean.subNumber;
        
        if (1<mark&&mark<=9) {
            desc = @"完事开头难，fighting!";
        }else if (9<mark&&mark<=19) {
            desc = @"不断练习就会不断进步!";
        }else if (19<mark&&mark<=29) {
            desc = @"有些水平哦，赞!";
        }else if (29<mark&&mark<=39) {
            desc = @"正在变强，需要继续练习呀!";
        }else if (39<mark&&mark<=49) {
            desc = @"你的技术比普通人强大太多了!";
        }else if (49<mark&&mark<=59) {
            desc = @"不要对他人使用暴力，你会伤人!";
        }else if (59<mark&&mark<=69) {
            desc = @"经过了多久的磨练才有如此的技术?";
        }else if (69<mark&&mark<=79) {
            desc = @"衡量下自己的能力，要不要站上擂台？";
        }else if (79<mark&&mark<=89) {
            desc = @"你的威力可能是一颗子弹";
        }else if (89<mark&&mark<=99) {
            desc = @"我们的拳头是为了保卫家人和朋友";
        }else if (99<mark) {
            desc = @"你是职业的";
        }
        desc = @"还没有评过分哟";
        
    }
    
    return desc;
}

- (NSInteger) levelOfGrade:(NSInteger) grade {
    
    NSInteger level = 0;
    
    if (grade <20) {
        level = 0;
    }else if (level < 40) {
        level = 1;
    }else if (level < 60) {
        level = 2;
    }else if (level < 80) {
        level = 3;
    }else if (level < 100) {
        level = 4;
    }
    
    return level;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //设置Cell的动画效果为3D效果
//    //设置x和y的初始值为0.1；
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//    //x和y的最终值为1
//    [UIView animateWithDuration:1 animations:^{
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//    }];
    if (_type == FTUserSkillTypeCoachComment) {//如果是教练评论详情
        
    }else{//如果是技能子项详情
        
        FTTraineeSkillCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell2"];
        
//        FTUserSkillBean *beanNew = _skillArray[indexPath.row];
//        FTUserSkillBean *beanOld = _skillArrayOld[indexPath.row];
//        
//        if (beanOld) {
//            [cell setWithSkillNewBean:beanNew andSkillOldBean:beanOld];
//        } else {
//            [cell setWithSkillBean:beanNew];
//        }
        
        cell.gradeLabel.text = @"2344234";
        
    }
    

}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_type == FTUserSkillTypeCoachComment) {//如果是教练评论详情
        
        FTUserSkillGradeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GradeCell"];
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

