//
//  FTHomepageMainViewController.m
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//



#import "FTHomepageMainViewController.h"
#import "WXApi.h"
#import "UIImage+FTLYZImage.h"
#import "FTTableViewController.h"
#import "QuartzCore/QuartzCore.h"
#import "FTNWGetCategory.h"
#import "FTLabelBean.h"
#import "FTRankTableView.h"
#import "FTTableViewController.h"
#import "JHRefresh.h"
#import "FTInformationViewController.h"
#import "FTTableViewController.h"
#import "SDCycleScrollView.h"
#import "RBRequestOperationManager.h"
#import "FTNetConfig.h"
#import "ZJModelTool.h"
#import "AFNetworking.h"
#import "JHRefresh.h"
#import "FTFilterTableViewController.h"
#import "FTNewsBean.h"
#import "UIButton+LYZTitle.h"
#import "UIButton+WebCache.h"

#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTRankViewController.h"
#import "FTNewPostViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

#import "FTArenaBean.h"
#import "FTArenaPostsDetailViewController.h"
#import "NetWorking.h"
#import "DBManager.h"
#import "FTRankViewController.h"
#import "FTNewsBean.h"


#import "FTVideoDetailViewController.h"
#import "FTVideoCollectionViewCell.h"
#import "FTRecordRankTableViewCell.h"
#import "FTBaseTableViewCell.h"
#import "FTHomepageRecordListTableViewCell.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "FTHomepageCommentListViewController.h"
#import "FTArenaBean.h"
#import "FTArenaPostsDetailViewController.h"
#import "FTUserCenterViewController.h"
#import "FTShareView.h"

#import "FTTraineeSkillCell.h"//技能列表cell
#import "FTUserCourseHistoryTableViewCell.h"//学员历史课程
#import "FTUserCourseHistoryBean.h"//历史课程bean
#import "NSDate+Tool.h"
#import "FTUserCourseCommentViewController.h"
#import "FTUserSkillBean.h"

@interface FTHomepageMainViewController ()<FTArenaDetailDelegate, FTSelectCellDelegate,FTTableViewdelegate, UIScrollViewDelegate, UIScrollViewAccessibilityDelegate, UICollectionViewDelegate, UICollectionViewDataSource, FTVideoDetailDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic)UIScrollView *scrollView;
@property (nonatomic, strong)FTTableViewController *tableViewController;
@property (nonatomic, strong)NSMutableArray *tableViewDataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *infoTableView;

@property (weak, nonatomic) IBOutlet UICollectionView *videoCollectionView;


@property(nonatomic) NSInteger currentSelectIndex;
@property (nonatomic, strong)NSArray *typeArray;

@property (nonatomic, copy)NSString *currentIndexString;

@property (nonatomic, copy)NSString *query;
@property (nonatomic, copy)NSString *pageNum;
@property (nonatomic, copy)NSString *pageSize;
@property (nonatomic, copy)NSString *labels;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (assign, nonatomic)BOOL hasInitRecordRank;
@property (assign, nonatomic)BOOL hasFollow;//是否关注
@property (nonatomic, copy)NSString *userid;//用于（取消）关注、获取评论列表
@property (nonatomic, copy)NSString *followTableName;//用于（取消）关注

@property (nonatomic, strong)NSMutableArray *collectionViewDataSourceArray;//视频collectionView的数据源
@property (nonatomic, copy)NSString *userIdentity;//用户身份  0:普通用户 1:拳手 2:教练

@property (nonatomic, strong)NSMutableArray *boxerRankDataArray;//拳手战绩数据
@property (nonatomic, strong)NSArray *boxerRaceInfoDataArray;//拳手赛事数据
@property (nonatomic, copy)NSString *standings;//拳手战况
@property (nonatomic, strong) FTUserBean *userBean;//获取的用户信息

@property (strong, nonatomic) IBOutlet UIImageView *redPoint1;//课程记录的红点
@property (strong, nonatomic) IBOutlet UIImageView *redPoint2;//技术数据的红点
@property (strong, nonatomic) IBOutlet UITableView *courseHistoryTableView;//历史课程tableview
@property (strong, nonatomic) IBOutlet UITableView *skillsTableView;//技能属性tableview

@property (nonatomic, strong) NSMutableArray *courseHistoryArray;//课程历史数据

@property (nonatomic, strong) NSMutableArray *skillArray;//技能项（包括子项、母项）暂未用到，留备用
@property (nonatomic, strong) NSMutableArray *fatherSkillArray;//技能母项
@property (nonatomic, strong) NSMutableArray *childSkillArray;//技能子项
@property (nonatomic, assign) BOOL hasNewVersion;//是否有新版本（暂无用处，只是用来标记。。）
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainScrollViewBottomSpacing;

@property (nonatomic, copy) NSString *versionFromServer;//从服务器获取的最新版本

@end

@implementation FTHomepageMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];//默认配置
    [self setNotification];
    [self setNavigationbar];
    [self getHomepageUserInfo];
    [self initSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    if (true){//如果是普通用户
        //更新“历史课程”、“技能”按钮右边的红点显示与否
            //如果是自己的主页
        if ([self isSelfHomepage]) {
            [self updateButtonRightRedPointDisplay];
        }
        
        
        if (_courseHistoryTableView) {
            [_courseHistoryTableView reloadData];
        }
        
        if (_skillsTableView) {
            [_skillsTableView reloadData];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

#pragma mark 获取用户的基本信息
- (void)getHomepageUserInfo{
    
    [NetWorking getHomepageUserInfoWithUserOldid:_olduserid andBoxerId:_boxerId andCoachId:_coachId andCallbackOption:^(FTUserBean *userBean) {
        _userBean = userBean;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:userBean.headUrl]];
    
        self.sexLabel.text = userBean.sex;
        self.nameLabel.text = userBean.name;

        self.followCountLabel.text = [NSString stringWithFormat:@"%@", userBean.followCount];
        self.fansCountLabel.text = [NSString stringWithFormat:@"%@", userBean.fansCount == nil ? @"0" : userBean.fansCount];
        self.dynamicCountLabel.text = [NSString stringWithFormat:@"%@", userBean.dynamicCount == nil ? @"0" : userBean.dynamicCount];
        if (!userBean.address) {
            userBean.address = @"";
        }
        self.addressLabel.text = [userBean.address stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.briefIntroductionTextField.text = userBean.brief;
        
        //设置年龄
        NSString *ageStr = userBean.birthday;
        if (ageStr == nil || [ageStr isEqualToString:@"(null)"]) {
            ageStr = @"-";
        }else{
            if ([ageStr isEqualToString:@""]) {
                ageStr = @"-";
            }else{
                NSTimeInterval birthTimeStamp = [userBean.birthday doubleValue];
                NSTimeInterval now = [[NSDate date] timeIntervalSince1970] * 1000;
                double age = (now - birthTimeStamp) / 3600 / 24 / 365 / 1000;
                ageStr = [NSString stringWithFormat:@"%.0lf", age];
            }
            if ([ageStr isEqualToString:@"-0"] || [ageStr isEqualToString:@"0"]) {
                ageStr = @"-";
            }
            
        }
        NSLog(@"ageStr : %@", ageStr);

        self.ageLabel.text = [NSString stringWithFormat:@"%@岁", ageStr];
        if (userBean.boxerId) {
            _boxerId = userBean.boxerId;
            //如果有boxerId，去查询拳手的赛事信息
            [self getBoxerRaceInfo];
        }
        if(userBean.coachId){
            _coachId = userBean.coachId;
        }
        _userid = userBean.userid;
        self.weightLabel.text = [NSString stringWithFormat:@"%@kg", userBean.weight == nil ? @"- " : userBean.weight];
        if (!userBean.height) {
            userBean.height = @"";
        }
        self.heightLabel.text = [NSString stringWithFormat:@"%@cm", [userBean.height isEqualToString:@""] ? @"- " : userBean.height];
        
        //处理三个按钮的可用状态
        if (userBean.query && ![userBean.query isEqualToString:@""]) {
            _userIdentity = userBean.query;
        }else{
            _userIdentity = @"0";
        }
        NSLog(@"_userIdentity : %@", _userIdentity);
        
        /*
            2016年12月1日修改：无论是什么身份，都显示三栏：技术数据、课程记录、动态信息
         */
        
        if ([_userIdentity isEqualToString:@"0"]) {//普通用户
            _userBgImageView.backgroundColor = [UIColor blackColor];//普通用户黑背景
            
            //隐藏所有身份图标
            self.identityImageView1.hidden = YES;
            self.identityImageView2.hidden = YES;
        }else if ([_userIdentity isEqualToString:@"1"]) {//拳手
            
            //设置拳手个人资料的背景图片
            if (userBean.background != nil && ![userBean.background isEqualToString:@""]) {//如果有背景图
                [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:userBean.background] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    _userBgImageView.image = [UIImage boxblurImage:image withBlurNumber:0.5];
                }];
            }else{//如果没有背景图
                _userBgImageView.backgroundColor = [UIColor blackColor];
            }

            //显示拳手身份
            self.identityImageView1.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-拳"];
            //隐藏其他身份
            self.identityImageView2.hidden = YES;
        }else if ([_userIdentity isEqualToString:@"2"]){//教练
            //显示教练身份
            self.identityImageView1.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-教"];
            
            //隐藏其他身份图片
            self.identityImageView2.hidden = YES;
        }else if ([_userIdentity isEqualToString:@"1,2"]){//拳手、教练
            //显示两个身份图片
            self.identityImageView1.hidden = NO;
            self.identityImageView2.hidden = NO;
            self.identityImageView1.image = [UIImage imageNamed:@"身份圆形-教"];
            self.identityImageView2.image = [UIImage imageNamed:@"身份圆形-拳"];
        }
        
        //如果是自己看自己的个人主页，显示三栏，如果是看别人的，显示技术数据和动态信息两栏，不显示上课记录
        if ([self isSelfHomepage]) {
            _firstButton.hidden = NO;//显示第一个按钮
            self.secondButton.hidden = NO;//显示第二个按钮
            self.thirdButton.hidden = NO;//显示第三个按钮

            [self getCourseHistoryFromServer];
                //处理右上角的“转发”或“修改”：如果是自己的主页，则是“修改”，如果是别人的，则显示转发
            _shareAndModifyProfileButton.hidden = NO;
            [_shareAndModifyProfileButton setTitle:@"修改" forState:UIControlStateNormal];
            [_shareAndModifyProfileButton removeTarget:self action:@selector(shareUserInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_shareAndModifyProfileButton addTarget:self action:@selector(modifyProfileButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //显示“发新动态”，隐藏关注等
            _bottomNewPostsView.hidden = NO;
            _bottomFollowView.hidden = YES;
            _mainScrollViewBottomSpacing.constant = 0;//没有了发动态view，把主内容view下移到底部
            self.bottomGradualChangeView.hidden = YES;
            
        }else{//如果是别人的主页
            //只显示一三：技术数据、动态
            _firstButton.hidden = NO;//显示第一个按钮
            self.secondButton.hidden = YES;//显示第二个按钮
            self.thirdButton.hidden = NO;//显示第三个按钮

            
            _shareAndModifyProfileButton.hidden = NO;
            [_shareAndModifyProfileButton setTitle:@"转发" forState:UIControlStateNormal];
            [_shareAndModifyProfileButton addTarget:self action:@selector(shareUserInfoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //隐藏“发新动态”，显示关注等
            _bottomNewPostsView.hidden = YES;
            _bottomFollowView.hidden = NO;
        }
        
        //默认总是加载技术数据和动态（帖子）
        [self getDataFromWeb];
        [self getSkillsFromServer];
        
        //获取关注信息
        [self getFollowInfo];
        
        //拳手战绩
        _boxerRankDataArray = [[NSMutableArray alloc]initWithArray:userBean.boxerRaceInfos];
            //添加一条空数据
        [_boxerRankDataArray insertObject:[NSObject new] atIndex:0];
        
        //拳手战绩概括
        _standings = userBean.standings;

    }];
}


/**
 是否是自己的主页
 */
- (BOOL)isSelfHomepage{
    BOOL result = NO;
    FTUserBean *localUserBean = [FTUserTools getLocalUser];
    if (localUserBean && [localUserBean.olduserid isEqualToString:self.olduserid]) {//如果是自己的主页
        result = YES;
    }else{//如果是别人的主页
        result = NO;
    }
    return result;
}

- (void)getBoxerRaceInfo{
    [NetWorking getBoxerRaceInfoWithBoxerId:_boxerId andOption:^(NSArray *array) {
        _boxerRaceInfoDataArray = array;
        [_recordListTableView reloadData];
    }];
}

#pragma mark 修改个人资料
- (void)modifyProfileButtonAction:(id) sender {
    NSLog(@"修改资料");
    FTUserCenterViewController *userCenter = [[FTUserCenterViewController alloc]init];
    userCenter.title = @"个人资料";
    [self.navigationController pushViewController:userCenter animated:YES];
    
}

#pragma mark 转发
- (void)shareUserInfoButtonAction:(id) sender {
    NSLog(@"转发");
    [MobClick event:@"rankingPage_HomePage_ShareUp"];
    NSLog(@"转发");
        //友盟分享事件统计
        [MobClick event:@"newsPage_DetailPage_share"];
    
    //链接地址
        NSString *_webUrlString = @"";
        FTShareView *shareView = [FTShareView new];
        [shareView setUrl:_webUrlString];
    
    //分享标题
    NSString *title = _userBean.name;
        //如果是拳手，再加上“［格斗东西］认证拳手，webview的url也改为拳手对应的
    if(_userBean.query && [_userBean.query isEqualToString:@"1"]){//1：拳手，2:教练，普通用户为空（nil）
        title = [NSString stringWithFormat:@"%@%@", title, @" - 认证拳手 [格斗东西]"];
        _webUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/v2/user_boxer.html?userId=%@", _olduserid];
    }else {
        _webUrlString = [NSString stringWithFormat:@"http://www.gogogofight.com/page/v2/user_general.html?userId=%@", _olduserid];
    }
    
    //分享简述
    NSString *summaryString = @"";
    if (_tableViewDataSourceArray && _tableViewDataSourceArray.count > 0) {//如果有动态，简述显示动态标题
        FTArenaBean *firstArenaBean = [_tableViewDataSourceArray firstObject];
        summaryString = firstArenaBean.title;
    }else{//不然，显示"职业拳手 %@ 在 [格斗东西] 上的个人主页"
        summaryString = [NSString stringWithFormat:@"职业拳手 %@ 在 [格斗东西] 上的个人主页", _userBean.name];
    }
        [shareView setTitle:title];
        [shareView setSummary:summaryString];
//        [shareView setImage:@"微信用@200"];
    [shareView setImageUrl:_userBean.headUrl];
//
            [shareView setUrl:_webUrlString];
    
        [self.view addSubview:shareView];
}
/**
 *  初始化一些默认配置
 */
- (void)initBaseData{
    _selectedType = FTHomepageTableViewTypeFirst;
    _currentIndexString = @"all";
    _query = @"list-dam-blog-1";
    _pageNum = @"1";
    _pageSize = @"100";
    _labels = @"";
    _hasInitRecordRank = false;
    
    _followTableName = @"f-user";
}

- (void)initSubviews{
    //给下方的关注、评论等控件增加点击事件监听
    [self addGesture];
    
    //调整行高
    [UILabel setRowGapOfLabel:self.briefIntroductionTextField withValue:6];
    
    //设置主scrollView的滚动逻辑
    [self setMainScrollView];
    //设置格斗场的tableview cell
    [self initInfoTableView];

}


- (void)addGesture{
    UITapGestureRecognizer *tapOfVoteView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(followViewClicked:)];
    [_followView addGestureRecognizer:tapOfVoteView];
    _followView.userInteractionEnabled = YES;
}

#pragma -mark 设置mainScrollView
- (void)setMainScrollView{
    _mainScrollView.delegate = self;
}
#pragma -mark scrollView滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == _mainScrollView){//如果是mainScrollView
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 204 - 24 + 8) {
        _buttonsContainerView.top = 224 + (offsetY - (204 - 24 + 8));
        [[_buttonsContainerView superview] bringSubviewToFront:_buttonsContainerView];
    }else{
        _buttonsContainerView.top = 224;
    }
    }
}
#pragma -mark -切换按钮的点击事件
- (IBAction)firstButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Match"];
    _selectedType = FTHomepageTableViewTypeFirst;
    [self refreshButtonsIndex];
}
- (IBAction)secondButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Match"];
    _selectedType = FTHomepageTableViewTypeSecond;
    [self refreshButtonsIndex];
}
- (IBAction)thirdButtonClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_VideoAll"];
    _selectedType = FTHomepageTableViewTypeThird;
    [self refreshButtonsIndex];
}
#pragma -mark 更新对应的界面显示
-(void)refreshButtonsIndex{
    switch (_selectedType) {
        case FTHomepageTableViewTypeFirst://视频 或 普通用户的技能属性
            _noDynamicImageView.hidden = YES;//隐藏“暂无数据”view
            
            //显示当前下标
            _dynamicInfomationButtonIndexView.hidden = NO;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = YES;

            
            //隐藏其余tableView，显示collectionView，并设置
            _infoTableView.hidden = YES;
            _recordRankTableView.hidden = YES;
            _recordListTableView.hidden = YES;
            
//            if ([_userIdentity isEqualToString:@"0"]) {//如果是普通用户，展示技能列表
            if (true) {//如果是普通用户，展示技能列表 /* 2016年12月1日修改，所有用户都显示技能列表 */
                _skillsTableView.hidden = NO;
                _courseHistoryTableView.hidden = YES;//隐藏历史课程tableview
                [self displaySkillsTableView];
            } else {//
                _videoCollectionView.hidden = NO;
                [self initCollectionView];
            }
            
            
            break;
        case FTHomepageTableViewTypeSecond://赛事 或 普通用户的课程记录
            _noDynamicImageView.hidden = YES;//隐藏“暂无数据”view
            
            //显示当前下标
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = NO;
            _videoButtonIndexView.hidden = YES;
            
            //显示赛事相关的内容，隐藏其他
            _noDynamicImageView.hidden = YES;
            _infoTableView.hidden = YES;
            _videoCollectionView.hidden = YES;
            
            if (true) {//如果是普通用户，需要展示历史课程
                _courseHistoryTableView.hidden = NO;//显示历史课程tableview
                _skillsTableView.hidden = YES;//隐藏技能列表
                [self displayCourseHistoryTableView];
            } else {//
                _recordRankTableView.hidden = NO;
                _recordListTableView.hidden = NO;

                //处理赛事内容显示
                [self setRecordContent];
            }
            
            break;
        case FTHomepageTableViewTypeThird://帖子列表
            
            
            //如果没有格斗场数据，则显示空图片
            if (self.tableViewDataSourceArray && self.tableViewDataSourceArray.count > 0) {
                _noDynamicImageView.hidden = YES;
            }else{
                _noDynamicImageView.hidden = NO;
            }
            
            //显示当前下标
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = NO;
            
            //显示格斗场列表，并隐藏其他
            _infoTableView.hidden = NO;
            _videoCollectionView.hidden = YES;
            _recordRankTableView.hidden = YES;
            _recordListTableView.hidden = YES;
            _courseHistoryTableView.hidden = YES;//隐藏历史课程
            _skillsTableView.hidden = YES;//隐藏技能列表
            break;
            
        default:
            break;
    }
}

#pragma mark -获取上课记录
- (void) getCourseHistoryFromServer {
    
    [NetWorking getUserCourseHistoryWithOption:^(NSDictionary *dict) {
        
        SLog(@"history dict:%@",dict);
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            NSArray *arrayTemp = dict[@"data"];
            [self handleCourseVersionWithCourseArray:arrayTemp];//处理获取的数据
            [self sortArray:arrayTemp];
            [self updateCourseHistoryButtonRightRedPointDisplay];//刷新课程按钮右边的红点
            [_courseHistoryTableView reloadData];//刷新历史课程列表
        }
    }];
}

#pragma mark -获取用户技能点
- (void) getSkillsFromServer {
    
    NSString *localSkillVersion;
    if ([self isSelfHomepage]) {//如果是自己看自己的，才传技能版本号
        localSkillVersion = [[NSUserDefaults standardUserDefaults]valueForKey:SKILL_VERSION];
    }
    
    [NetWorking getUserSkillsWithCorporationid:nil andMemberUserId:_olduserid andVersion:localSkillVersion andParent:nil andOption:^(NSDictionary *dict) {
        
        SLog(@"history dict:%@",dict);
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {//获取到了技能数据，但有两种情况：1⃣️，版本号为null，没有过评分记录；2⃣️版本号不为空，此时为有更新
            
            NSArray *arrayTemp = dict[@"data"][@"skills"];
            
            /*
             把从服务器获取的数据存入本地
             */
            _skillArray = [NSMutableArray new];//新建数组
            _fatherSkillArray = [NSMutableArray new];//新建父项数组
            _childSkillArray = [NSMutableArray new];//新建子项数组
            
            for(NSDictionary *skillDic in arrayTemp){
                FTUserSkillBean *skillBean = [FTUserSkillBean new];
                [skillBean setValuesWithDic:skillDic];
                [_skillArray addObject:skillBean];
                
                if (skillBean.isParrent) {
                    [_fatherSkillArray addObject:skillBean];
                } else {
                    [_childSkillArray addObject:skillBean];
                }
                
            }
            
            /*
                如果是自己的主页，再处理版本数据
             */
            if ([self isSelfHomepage]) {
                id version = dict[@"data"][@"versions"];//从服务器获取的版本号
                
                if (version && (version != [NSNull null])) {//如果有版本号，说明有过评分记录
                    
                    _versionFromServer = version;
                    
                    /*
                        版本号存在有两种情况：一，该用户有评分记录，而且是第一次访问；二：该用户有评分记录，是有技能更新
                     */
                    NSString *localVersion = [[NSUserDefaults standardUserDefaults]valueForKey:SKILL_VERSION];
                    if (!localVersion) {//如果是第一种，直接保存版本号，把数据存入本地
                        [[NSUserDefaults standardUserDefaults]setValue:version forKey:SKILL_VERSION];
                        [[NSUserDefaults standardUserDefaults]synchronize];

                        [self saveSkillArray:_fatherSkillArray WithKey:FATHER_SKILLS_ARRAY];
                        [self saveSkillArray:_childSkillArray WithKey:CHILD_SKILLS_ARRAY];
                    }
                    
                    /*
                     有更新的话，要处理红点的逻辑，把之前存储的技能信息拿出来做一下对比，确定哪些母项有更新
                     */
                    
                    //处理获取的数据
                    NSArray *fatherSkillArrayOld = [self getLocalSkillArrayWithKey:FATHER_SKILLS_ARRAY];
                    //遍历，查看母项的更新情况
                    //如果不存在，初始化fatherSkillVersionsDic
                    NSMutableDictionary *fatherSkillVersionsDic = [[NSUserDefaults standardUserDefaults]valueForKey:FATHER_SKILL_VERSION_DIC];
                    
                    if (!fatherSkillVersionsDic) {
                        fatherSkillVersionsDic = [NSMutableDictionary new];
                    }else{
                        fatherSkillVersionsDic = [[NSMutableDictionary alloc]initWithDictionary:fatherSkillVersionsDic];
                    }
                    
                    for (FTUserSkillBean *newSkillBean in _fatherSkillArray){
                        FTUserSkillBean *oldSkillBean;
                        
                        /*
                         遍历本地存储的技能，对比score是否有更新
                         */
                        for(FTUserSkillBean *oldSkillBeanItem in fatherSkillArrayOld){
                            if (newSkillBean.id == oldSkillBeanItem.id){
                                oldSkillBean = oldSkillBeanItem;
                                
                                break;//退出内层循环
                            }
                        }
                        
                        if (oldSkillBean) {//如果oldSkillBean找到了，对比score
                            if (oldSkillBean.score != newSkillBean.score) {
                                //如果score不等，说明有更新，记录下来
                                newSkillBean.hasNewVersion = YES;
                                [fatherSkillVersionsDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d", oldSkillBean.id]];
                                
                            }
                        }
                    }
                    
                    //把技能已读未读的信息存入本地
                    if (fatherSkillVersionsDic) {
                        [[NSUserDefaults standardUserDefaults]setValue:fatherSkillVersionsDic forKey:FATHER_SKILL_VERSION_DIC];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }
                    
                    //刷新技能按钮右边红点的显示
                    [self updateSkillButtonRightRedPointDisplay];
                    
                } else {//如果返回有默认的技能数据返回，但版本号却不存在，说明没有进行过评分
                    
                    //把获取的技能信息存在本地
                    //先把skillBean转换成data存入数组，再存入本地
                    [self saveSkillArray:_fatherSkillArray WithKey:FATHER_SKILLS_ARRAY];
                    [self saveSkillArray:_childSkillArray WithKey:CHILD_SKILLS_ARRAY];
                }
 
            }
            
                    }else{//如果status为error，说明服务器无最新版本，本地的已经是最新版本，直接拿本地的显示
            /*
             从本地读取旧的数据展示
             */
            _fatherSkillArray = [self getLocalSkillArrayWithKey:FATHER_SKILLS_ARRAY];
            _childSkillArray = [self getLocalSkillArrayWithKey:CHILD_SKILLS_ARRAY];
        }
        [_skillsTableView reloadData];//刷新课程表
        [self refreshButtonsIndex ];//加载完技术数据后，刷新按钮、对应tableView的显示
    }];
}

- (void)saveSkillArray:(NSArray *)skillArray WithKey:(NSString *)key{
    NSMutableArray *skillDataArray = [NSMutableArray new];
    for(FTUserSkillBean *skillBeanItem in skillArray){
        NSData *skillDataItem = [NSKeyedArchiver archivedDataWithRootObject:skillBeanItem];
        [skillDataArray addObject:skillDataItem];
    }
    [[NSUserDefaults standardUserDefaults]setObject:skillDataArray forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

/**
 根据key从UserDefaults获取skillArray

 @param key key
 @return 技能数组
 */
- (NSMutableArray *)getLocalSkillArrayWithKey:(NSString *)key{
    NSArray *skillDataArray = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSMutableArray *skillArray = [NSMutableArray new];
    for (NSData *beanData in skillDataArray){
        FTUserSkillBean *bean = [NSKeyedUnarchiver unarchiveObjectWithData:beanData];
        [skillArray addObject:bean];
    }
    return skillArray;
}



- (void)handleCourseVersionWithCourseArray:(NSArray *)courseArray{
    
    if (!courseArray) {
        NSLog(@"array为空");
        return;
    }
    
    NSMutableDictionary *versionDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]valueForKey:COURSE_VERSION]];//从本地读取记录版本号已读、未读的字典
    
    if (!versionDic) {//如果不存在，说明本地没有课程的版本记录
        //创建一个新的字典
        versionDic = [NSMutableDictionary new];
        
        //存入版本号，并把值都设为“已读”
        for ( int i = 0; i < courseArray.count ; i++) {
            NSDictionary *courseDic = courseArray[i];//一条课程记录
            if (courseDic) {
                NSString *version = courseDic[@"versions"];//从字典取出的value实际为int类型
                if (version) {
                    version = [NSString stringWithFormat:@"%@", version];
                    [versionDic setValue:READ forKey:version];
                }
            }
        }
    } else {//如果存在，说明本地已经有版本数据
        //把新的课程版本存起来
        for ( int i = 0; i < courseArray.count ; i++) {
            NSDictionary *courseDic = courseArray[i];//一条课程记录
            if (courseDic) {
                NSString *version = courseDic[@"versions"];//从字典取出的value实际为int类型
                if (version) {
                    version = [NSString stringWithFormat:@"%@", version];
                    if (![self dictionary:versionDic containsKey:version]) {//如果是新的版本号
                        [versionDic setValue:UNREAD forKey:version];//作为未读存起来
                    }
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults]setObject:versionDic forKey:COURSE_VERSION];//把最新的版本信息存入本地
    [[NSUserDefaults standardUserDefaults]synchronize];//同步
}

- (BOOL)dictionary:(NSDictionary *)dic containsKey:(NSString *)keyString{
    for(NSString *key in [dic allKeys]){
        if([key isEqualToString:keyString]) return true;
    }
    return false;
}

#pragma makr 把从服务器获取的数据按照“yyyy年MM月”分组
- (void) sortArray:(NSArray *)tempArray {

        if (!_courseHistoryArray) {
            _courseHistoryArray = [[NSMutableArray alloc]init];
        }else{
            [_courseHistoryArray removeAllObjects];
        }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (NSDictionary *dic in tempArray) {
        
        FTUserCourseHistoryBean *bean = [[FTUserCourseHistoryBean alloc]init];
        [bean setValuesWithDic:dic];
        
        NSString *dateString = [NSDate dateStringWithYearMonth:bean.date];
        
        NSLog(@"dateString:%@",dateString);
        
        if ([dict.allKeys containsObject:dateString]) {
            NSMutableArray *array = [dict objectForKey:dateString];
            [array addObject:bean];
            
        }else {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            [array addObject:bean];
            [_courseHistoryArray addObject:array];
            [dict setObject:array forKey:dateString];
        }
    }
}

#pragma -mark 格斗场帖子列表
- (void)initInfoTableView
{
    if(!self.tableViewController){
        self.tableViewController = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
        self.tableViewController.listType = FTCellTypeArena;
        
        self.tableViewController.FTdelegate = self;
    }
    
    if (self.tableViewDataSourceArray) {
        self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    }else{
        NSLog(@"没有数据源。");
    }
    self.tableViewController.tableView = _infoTableView;
    //注册cell用于重用
    [_infoTableView registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
    [_infoTableView registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
}

- (void)displayCourseHistoryTableView{
    //历史课程tableview代理设置
    _courseHistoryTableView.delegate = self;
    _courseHistoryTableView.dataSource = self;
    [_courseHistoryTableView registerNib:[UINib nibWithNibName:@"FTUserCourseHistoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"courseHistoryCell"];//加载cell用于复用
    [_courseHistoryTableView reloadData];//刷新tableview
}

- (void)displaySkillsTableView{
    //历史课程tableview代理设置
    _skillsTableView.delegate = self;
    _skillsTableView.dataSource = self;
    [_skillsTableView registerNib:[UINib nibWithNibName:@"FTTraineeSkillCell" bundle:nil] forCellReuseIdentifier:@"skillListCell"];//加载cell用于复用
    [_skillsTableView reloadData];//刷新tableview
    
}

-(void) getDataFromWeb {
    
    NSString *urlString = [FTNetConfig host:Domain path:GetArenaListURL];
    NSString *tableName = @"damageblog";
    
    urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@&userId=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName, _olduserid];
//        urlString = [NSString stringWithFormat:@"%@?query=%@&labels=%@&pageNum=%@&pageSize=%@&tableName=%@", urlString, _query, _labels, _pageNum ,_pageSize, tableName];
    
    NSLog(@"个人中心获取帖子列表 url ： %@", urlString);
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *responseDic) {
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                
                //把获取的字典转换为bean，再存入数组
                NSMutableArray *tempTableViewArray = [NSMutableArray new];
                for(NSDictionary *dic in mutableArray){
                    FTArenaBean *bean = [FTArenaBean new];
                    [bean setValuesWithDic:dic];
                    [tempTableViewArray addObject:bean];
                }
                
                //从格斗场的数据中，筛选出属于“训练”类型的内容**start***
                NSMutableArray *tempCollectionViewDataArray = [NSMutableArray new];
                for(FTArenaBean *bean in tempTableViewArray){
                    if ([bean.labels isEqualToString:@"Train"] || [bean.labels isEqualToString:@"Match"]) {
                        [tempCollectionViewDataArray addObject:bean];
                    }
                }
                _collectionViewDataSourceArray = tempCollectionViewDataArray;
                //从格斗场的数据中，筛选出属于“训练”类型的内容** end ***
                
                if (self.tableViewDataSourceArray == nil) {
                    self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
                }
                if ([_pageNum isEqualToString:@"1"]) {//如果是第一页数据，直接替换，不然追加
                    self.tableViewDataSourceArray = tempTableViewArray;
                }else{
                    [self.tableViewDataSourceArray addObjectsFromArray:tempTableViewArray];
                }
                
                self.tableViewController.sourceArray = self.tableViewDataSourceArray;
                
                
                
                if (self.tableViewDataSourceArray.count > 0) {
                    _noDynamicImageView.hidden = YES;
                }
                
                [self.tableViewController.tableView reloadData];
                
                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
                [self.tableViewController.tableView footerEndRefreshing];
            }else {
                //不用缓存，如果用缓存，会有个bug：看别人（小明）的主页，显示的是非小明的动态
//                [self getDataFromDB];
//                [self.tableViewController.tableView headerEndRefreshingWithResult:JHRefreshResultFailure];
//                [self.tableViewController.tableView footerEndRefreshing];
            }
            
        }else {
            //不用缓存，如果用缓存，会有个bug：看别人（小明）的主页，显示的是非小明的动态
//            [self getDataFromDB];
        }
    }];
}

-(void) getDataFromDB {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchArenasWithLabel:_labels hotTag:_query];
    [dbManager close];
    
    //从格斗场的数据中，筛选出属于“训练”类型的内容**start***
    NSMutableArray *tempArray = [NSMutableArray new];
    for(FTArenaBean *bean in mutableArray){
        if ([bean.labels isEqualToString:@"Train"]) {
            [tempArray addObject:bean];
        }
    }
    _collectionViewDataSourceArray = tempArray;
    //从格斗场的数据中，筛选出属于“训练”类型的内容** end ***
    
    if (self.tableViewDataSourceArray == nil) {
        self.tableViewDataSourceArray = [[NSMutableArray alloc]init];
    }
    if ([_pageNum isEqualToString:@"1"]) {//如果是第一页数据，直接替换，不然追加
        self.tableViewDataSourceArray = mutableArray;
    }else{
        [self.tableViewDataSourceArray addObjectsFromArray:mutableArray];
    }
    
    self.tableViewController.sourceArray = self.tableViewDataSourceArray;
    

    
    if (self.tableViewDataSourceArray.count > 0) {
        _noDynamicImageView.hidden = YES;
    }
    
    [self.tableViewController.tableView reloadData];

}
#pragma -mark 动态tableview的cell点击事件
- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath{
        NSLog(@"第%ld个cell被点击了。", indexPath.row);
    if (self.tableViewDataSourceArray) {
        
        FTArenaPostsDetailViewController *postsDetailVC = [FTArenaPostsDetailViewController new];
        //获取对应的bean，传递给下个vc
        //        NSDictionary *newsDic = tableView.sourceArray[indexPath.row];
        //        FTArenaBean *bean = [FTArenaBean new];
        //        [bean setValuesWithDic:newsDic];
        FTArenaBean *bean = tableView.sourceArray[indexPath.row];
        //标记已读
        if (![bean.isReader isEqualToString:@"YES"]) {
            bean.isReader = @"YES";
            //从数据库取数据
            DBManager *dbManager = [DBManager shareDBManager];
            [dbManager connect];
            [dbManager updateArenasById:bean.postsId isReader:YES];
            [dbManager close];
        }
        postsDetailVC.arenaBean = bean;
        postsDetailVC.delegate = self;
        postsDetailVC.indexPath = indexPath;
        [self.navigationController pushViewController:postsDetailVC animated:YES];    }
}

#pragma -mark 回调更新格斗场的点赞、评论信息
- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.tableViewController.sourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", arenaBean.commentCount] forKey:@"commentCount"];
    
    self.tableViewController.sourceArray[indexPath.row] = dic;
    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark ***  赛事  ***
- (void)setRecordContent{

    //设置赛事排行榜
    if (!_hasInitRecordRank) {
        //设置代理
        _recordRankTableView.delegate = self;
        _recordRankTableView.dataSource = self;
        //加载一个cell用于复用
        [_recordRankTableView registerNib:[UINib nibWithNibName:@"FTRecordRankTableViewCell" bundle:nil] forCellReuseIdentifier:@"recordRankCell"];
        //设置高度
        _recordRankTableViewHeight.constant =36 + 22 + 32 * (_boxerRankDataArray.count - 1) + 7;
        //添加背景
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 0, _recordRankTableView.width - 8 * 2, _recordRankTableViewHeight.constant)];
//        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _recordRankTableView.width, _recordRankTableViewHeight.constant)];
        bgImageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
        [_recordRankTableView addSubview:bgImageView];
        _hasInitRecordRank = true;
    }
    [_recordRankTableView reloadData];
    
    //设置赛事列表
    _recordListTableView.delegate = self;
    _recordListTableView.dataSource = self;
    [_recordListTableView registerNib:[UINib nibWithNibName:@"FTHomepageRecordListTableViewCell" bundle:nil] forCellReuseIdentifier:@"recordListCell"];
    [_recordListTableView reloadData];
}

//多少组

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //如果是历史课程，返回多组，其他均为1
    if (tableView == _courseHistoryTableView) {
        if (_courseHistoryArray) {
            return _courseHistoryArray.count;
        }
        return 1;
    } else {
        return 1;
    }
}

//cell多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (tableView == _recordRankTableView) {
        if(_boxerRankDataArray){
            number = _boxerRankDataArray.count;
        }
    }else if(tableView == _recordListTableView){
        number = _boxerRaceInfoDataArray.count;
    }else if (tableView == _courseHistoryTableView) {
        if (_courseHistoryArray) {
            number = [_courseHistoryArray[section] count];
        }
//        number = 10;
    }else if (tableView == _skillsTableView){
        if (_fatherSkillArray && _fatherSkillArray.count > 0) {//先加在从服务器获取的最新的技能，没有的话去本地缓存找
            number = _fatherSkillArray.count;
        }else{
            NSArray *localFatherSkillArray = [self getLocalSkillArrayWithKey:FATHER_SKILLS_ARRAY];
            if (localFatherSkillArray && localFatherSkillArray.count > 0) {
                number = _fatherSkillArray.count;
            }
        }
    }
    return number;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == _recordRankTableView) {
        UIView *headerView = [UIView new];
        headerView.frame = CGRectMake(0, 0, tableView.width, 36);
        
        //固定文本“战绩”label
        UILabel *standingsTitle = [[UILabel alloc]initWithFrame:CGRectMake(14 + 10, 12, 50, 14)];
        standingsTitle.text = @"战绩";
        standingsTitle.font = [UIFont systemFontOfSize:14];
        standingsTitle.textColor = [UIColor whiteColor];
        [headerView addSubview:standingsTitle];
        
        //战绩详情label
        UILabel *standingsDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.width - 200 - 14 - 10, 12, 200, 14)];
        standingsDetailLabel.textAlignment = NSTextAlignmentRight;
        
        NSMutableAttributedString *standingStr = [[NSMutableAttributedString alloc]init];
            //胜
        NSMutableAttributedString *winCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.win == nil ? @"0" : _userBean.win]];
        [winCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, winCountStr.length)];
        NSMutableAttributedString *winStr = [[NSMutableAttributedString alloc]initWithString:@"胜 "];
        [winStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, winStr.length)];
        
            //负
        NSMutableAttributedString *failCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.fail == nil ? @"0" : _userBean.fail]];
        [failCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, failCountStr.length)];
        NSMutableAttributedString *failStr = [[NSMutableAttributedString alloc]initWithString:@"负 "];
        [failStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, failStr.length)];
            //平
        NSMutableAttributedString *drawCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.draw == nil ? @"0" : _userBean.draw]];
        NSMutableAttributedString *drawStr = [[NSMutableAttributedString alloc]initWithString:@"平 "];
        [drawCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, drawCountStr.length)];
        [drawStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, drawStr.length)];
            //击倒
        NSMutableAttributedString *knockoutCountStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@", _userBean.knockout == nil ? @"0" : _userBean.knockout]];
        [knockoutCountStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, knockoutCountStr.length)];
        NSMutableAttributedString *knockStr = [[NSMutableAttributedString alloc]initWithString:@"击倒"];
        [knockStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, knockStr.length)];
        
        [standingStr appendAttributedString:winCountStr];
        [standingStr appendAttributedString:winStr];
        [standingStr appendAttributedString:failCountStr];
        [standingStr appendAttributedString:failStr];
        [standingStr appendAttributedString:drawCountStr];
        [standingStr appendAttributedString:drawStr];
        [standingStr appendAttributedString:knockoutCountStr];
        [standingStr appendAttributedString:knockStr];
        
        standingsDetailLabel.attributedText = standingStr;
        standingsDetailLabel.font = [UIFont systemFontOfSize:14];
        [headerView addSubview:standingsDetailLabel];
        
        //底部分割线
        UIView *bottomSeparatorView = [[UIView alloc]initWithFrame:CGRectMake(10, headerView.height - 1, headerView.width - 20, 1)];
        bottomSeparatorView.backgroundColor = [UIColor colorWithRed:40 / 255.0 green:40 / 255.0 blue:40 / 255.0 alpha:1];
        [headerView addSubview:bottomSeparatorView];
        
        return headerView;
    }else if (tableView == _courseHistoryTableView){
        
        if(!_courseHistoryArray || _courseHistoryArray.count == 0){//如果没有历史课程数据，则不反回headerView
            return nil;
        }
        
        UIView *headerView = [UIView new];
        headerView.backgroundColor = [UIColor colorWithHex:0x282828];
        headerView.frame = CGRectMake(0, 0, tableView.width, 20);
        
        FTUserCourseHistoryBean *bean = [_courseHistoryArray[section] firstObject];
        NSString *currentYearMonthString = [NSDate currentYearMonthString2];
        NSString *yearMonthString = [NSDate dateStringWithYearMonth:bean.date];
        
        NSString *currentMonthString = [NSDate currentMonthString];
        NSString *monthString = [NSDate monthString:bean.date];
        
        NSString *date = @"";
        UILabel *label1;
        if ([yearMonthString isEqualToString:currentYearMonthString]) {
            if ([monthString isEqualToString:currentMonthString]) {
                date = @"本月完成课程";
            } else {
                date = [NSString stringWithFormat:@"%@月完成课程", monthString];
            }
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 75, 12)];
        }else {
            date = [NSString stringWithFormat:@"%@完成课程", yearMonthString];
            label1 = [[UILabel alloc]initWithFrame:CGRectMake(16, 4, 120, 12)];
        }
        
        label1.textColor = [UIColor colorWithHex:0xb4b4b4];
        label1.font = [UIFont systemFontOfSize:12];
        label1.text = date;
        [headerView addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(label1.frame.origin.x + label1.width, 4, 50, 12)];
        label2.textColor = [UIColor colorWithHex:0xb4b4b4];
        label2.text = [NSString stringWithFormat:@"%ld节", [_courseHistoryArray[section] count] ];
        label2.font = [UIFont systemFontOfSize:12];
        [headerView addSubview:label2];
        
        return headerView;
    }
    return nil;
}

//headerView height
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _recordRankTableView) {
        return 36;
    }else if (tableView == _courseHistoryTableView){
        if(!_courseHistoryArray || _courseHistoryArray.count == 0){//如果没有历史课程数据，则不反回headerView
            return 0;
        }
        return 20;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == _courseHistoryTableView) {
        return 20;
    }
    return 0;
}
- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == _courseHistoryTableView) {
        UIView *footerView = [UIView new];
        footerView.backgroundColor = [UIColor clearColor];
        footerView.frame = CGRectMake(0, 0, tableView.width, 20);
        
        return  footerView;
    }
    return nil;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTBaseTableViewCell *cell = [FTBaseTableViewCell new];
    if (tableView == _recordRankTableView) {//如果是赛事排行榜信息
        
        FTRecordRankTableViewCell *cell1 = (FTRecordRankTableViewCell *)([tableView dequeueReusableCellWithIdentifier:@"recordRankCell"]);
        if (indexPath.row == 0) {//如果是第一行，调整字体为灰色
            cell1.competitionNameLabel.textColor = [UIColor colorWithHex:0x646464];
            cell1.curRankLabel.textColor = [UIColor colorWithHex:0x646464];
            cell1.bestRankLabel.textColor = [UIColor colorWithHex:0x646464];
            //增加背景色
            NSLog(@"cell1 width : %f", cell1.width);
            UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(11, 0, SCREEN_WIDTH - 32, 22)];
            bgView.backgroundColor = [UIColor colorWithHex:0x191919];
            [cell1 addSubview:bgView];
            [cell1 sendSubviewToBack:bgView];
        }else{//如果不是第一行，动态显示内容
            cell1.competitionNameLabel.textColor = [UIColor whiteColor];
            cell1.curRankLabel.textColor = [UIColor whiteColor];
            cell1.bestRankLabel.textColor = [UIColor whiteColor];
            cell1.backgroundColor = [UIColor clearColor];
            
            [cell1 setWithDic:_boxerRankDataArray[indexPath.row]];
        }
        //如果是第一个和最后一个，则不显示分割线
        if (indexPath.row == 0 || indexPath.row == 4) {
            cell1.separatorIndexView.hidden = YES;
        }
        return cell1;
    }else if(tableView == _recordListTableView){
        FTHomepageRecordListTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"recordListCell"];
        [cell2 setWithDic:_boxerRaceInfoDataArray[indexPath.row]];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell2;
    }else if(tableView == _courseHistoryTableView){//历史课程
        FTUserCourseHistoryTableViewCell *courseHistoryCell = [tableView dequeueReusableCellWithIdentifier:@"courseHistoryCell"];
        FTUserCourseHistoryBean *userCourseHistoryBean = _courseHistoryArray[indexPath.section][indexPath.row];
        [courseHistoryCell setWithBean:userCourseHistoryBean];
        return courseHistoryCell;
    }else if(tableView == _skillsTableView){//技能
        FTTraineeSkillCell *skillListCell = [tableView dequeueReusableCellWithIdentifier:@"skillListCell"];
        FTUserSkillBean *bean = _fatherSkillArray[indexPath.row];
        [skillListCell setWithSkillBean:bean];
        return skillListCell;
    }
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _recordRankTableView) {
        if (indexPath.row == 0) {
            return 22;
        }else{
            return 32;
        }
    }else if(tableView == _recordListTableView){
        return 74 + 10;
    }else if(tableView == _courseHistoryTableView){
        return 50;
    }else if(tableView == _skillsTableView){
        return 44;
    }
    return 0;
}
//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _recordListTableView) {
        NSDictionary *dic = _boxerRaceInfoDataArray[indexPath.row];
        NSString *type = dic[@"urlType"];
        NSLog(@"type : %@", type);
        if ([type isEqualToString:@"0"]) {//不跳转
            return;
        }else if ([type isEqualToString:@"1"]){//拳讯
            NSLog(@"拳讯");
            [NetWorking getNewsById:dic[@"urlId"] andOption:^(NSArray *array) {
                if (dic[@"urlId"]) {
                    FTVideoDetailViewController *newsDetailVC = [FTVideoDetailViewController new];
                    newsDetailVC.objId = [NSString stringWithFormat:@"%@", dic[@"urlId"]];
                    FTNewsBean *newsBean = [FTNewsBean new];
                    [newsBean setValuesWithDic:[array firstObject]];
                    newsDetailVC.newsBean = newsBean;
                    [self.navigationController pushViewController:newsDetailVC animated:YES];
                }
            }];


        }else if ([type isEqualToString:@"2"]){//视频  注释掉了这一段，不会有视频类型了，全部是news类型
            
        }
    }else if (tableView == _courseHistoryTableView){
        NSLog(@"_courseHistoryTableView 被点击");
        
        FTUserCourseHistoryBean *courseBean = _courseHistoryArray[indexPath.section][indexPath.row];
        NSString *version = courseBean.version;
        
        FTUserCourseCommentViewController * userCourseCommentViewController = [FTUserCourseCommentViewController new];
        userCourseCommentViewController.courseRecordVersion = version;
        userCourseCommentViewController.courseName = courseBean.courseName;
        [self.navigationController pushViewController:userCourseCommentViewController animated:YES];

        if (version) {
            NSMutableDictionary *versionDic = [[NSUserDefaults standardUserDefaults]valueForKey:COURSE_VERSION];//从本地读取记录版本号已读、未读的字典
            if (versionDic) {
                NSMutableDictionary *mDicTest = [[NSMutableDictionary alloc]initWithDictionary:versionDic copyItems:YES];
                
                [mDicTest setValue:READ forKey:version];
                [[NSUserDefaults standardUserDefaults]removeObjectForKey:COURSE_VERSION];
                [[NSUserDefaults standardUserDefaults]setObject:mDicTest forKey:COURSE_VERSION];
                [[NSUserDefaults standardUserDefaults]synchronize];
            }
        }
        
    }else if (tableView == _skillsTableView){
        NSLog(@"_skillsTableView 被点击");
        FTUserCourseCommentViewController * userCourseCommentViewController = [FTUserCourseCommentViewController new];
        userCourseCommentViewController.type = FTUserSkillTypeChildSkill;
        
        //点击的该母项技能
        FTUserSkillBean *fatherSkillBean = _fatherSkillArray[indexPath.row];
        
        //母项页传递下去
        userCourseCommentViewController.fatherSkillBean = fatherSkillBean;

        //把筛选出来的该母项下所有的子项传值给下个vc
        userCourseCommentViewController.skillArray = [self getChildrenSkillArrayWithParentID:fatherSkillBean.id fromSkillArray:_childSkillArray];
        
        if ([self isSelfHomepage] && fatherSkillBean.hasNewVersion) {//如果是自己的主页，并且有更新
            //点击后，将该母项设为没有更新
            fatherSkillBean.hasNewVersion = NO;
            
            //把历史该母项的所有子项历史记录也传给下个vc
            NSArray *childSkillArrayOld = [self getLocalSkillArrayWithKey:CHILD_SKILLS_ARRAY];
            
            
            userCourseCommentViewController.skillArrayOld = [self getChildrenSkillArrayWithParentID:fatherSkillBean.id fromSkillArray:childSkillArrayOld];
            
            //点击后，把该条设为已读
            NSMutableDictionary *fatherSkillVersionsDic = [[NSUserDefaults standardUserDefaults]valueForKey:FATHER_SKILL_VERSION_DIC];
            if (!fatherSkillVersionsDic) {
                fatherSkillVersionsDic = [NSMutableDictionary new];
            }else{
                fatherSkillVersionsDic = [[NSMutableDictionary alloc]initWithDictionary:fatherSkillVersionsDic];
            }
            [fatherSkillVersionsDic setObject:@"0" forKey:[NSString stringWithFormat:@"%d", fatherSkillBean.id]];
            //把技能已读未读的信息存入本地
            [[NSUserDefaults standardUserDefaults]setValue:fatherSkillVersionsDic forKey:FATHER_SKILL_VERSION_DIC];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //并把这条点击过的母项存入本地
            NSMutableArray *fatherSkillArrayOld = [self getLocalSkillArrayWithKey:FATHER_SKILLS_ARRAY];
                //移除旧的母项，添加最新的母项
            for(FTUserSkillBean *beanItem in fatherSkillArrayOld){
                if(beanItem.id == fatherSkillBean.id){
                    [fatherSkillArrayOld removeObject:beanItem];
                    [fatherSkillArrayOld addObject:fatherSkillBean];
                    [self saveSkillArray:fatherSkillArrayOld WithKey:FATHER_SKILLS_ARRAY];//存入本地
                    break;
                }
            }
        }
        [self.navigationController pushViewController:userCourseCommentViewController animated:YES];
    }
}


/**
 是否还有未查看的技能更新（用于判断顶部红点的展示与否）

 @return BOOL
 */
- (BOOL)hasAnyUnreadSkillChange{
    NSDictionary *fatherSkillVersionsDic = [[NSUserDefaults standardUserDefaults]objectForKey:FATHER_SKILL_VERSION_DIC];
    for(NSString *value in [fatherSkillVersionsDic allValues]){
        if ([value isEqualToString:@"1"]){
            /*
                如果有值为1的，说明有未读的，返回true
             */
            return true;
        }
    }
    
    //如果全部已读，则把最新的版本号存入本地，下次再加载时，以这个版本号作为参数传给服务器
    if (_versionFromServer) {
        [[NSUserDefaults standardUserDefaults]setValue:_versionFromServer forKey:SKILL_VERSION];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    return false;
}

- (BOOL)hasAnyUnreadCourseRecord{
    NSDictionary *versionDic = [[NSUserDefaults standardUserDefaults]valueForKey:COURSE_VERSION];
    for (NSString *version in [versionDic allKeys]){
        NSString *hasRead = versionDic[version];
        if ([hasRead isEqualToString:UNREAD]) {
            return YES;
        }
    }

    return NO;
}

/**
 根据parentID筛选出子项skill

 @param parentId 父项id
 @param skillArray skillArray
 @return 子项
 */
- (NSMutableArray *)getChildrenSkillArrayWithParentID:(int)parentId fromSkillArray:(NSArray *)skillArray{
    NSMutableArray *childSkillArray = [NSMutableArray new];
    for(FTUserSkillBean *bean in skillArray){
        if (bean.parentId == parentId) {
            [childSkillArray addObject:bean];
        }
    }
    return childSkillArray;
}

- (void) getDataFromDBWithVideoType:(NSString *)videosType  getType:(NSString *) getType {
    
    //从数据库取数据
    DBManager *dbManager = [DBManager shareDBManager];
    [dbManager connect];
    NSMutableArray *mutableArray =[dbManager searchVideosWithType:videosType hotTag:nil];
    [dbManager close];
    
    if ([getType isEqualToString:@"new"]) {
        self.collectionViewDataSourceArray = mutableArray;
    }else if([getType isEqualToString:@"old"]){
        [self.collectionViewDataSourceArray addObjectsFromArray:mutableArray];
    }
}
- (void)initCollectionView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
    //    flow.minimumLineSpacing = 15 * SCALE;
    //列间距
    flow.minimumInteritemSpacing = 16 * SCALE;
    
    float width = 164 * SCALE;
    float height = 143 * SCALE;
    flow.itemSize = CGSizeMake(width, height);
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
    
    _videoCollectionView.collectionViewLayout = flow;
    _videoCollectionView.delegate = self;
    _videoCollectionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
    [_videoCollectionView registerNib:[UINib nibWithNibName:@"FTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_videoCollectionView reloadData];
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    if (self.collectionViewDataSourceArray) {
        
        FTArenaPostsDetailViewController *postsDetailVC = [FTArenaPostsDetailViewController new];
        //获取对应的bean，传递给下个vc
        //        NSDictionary *newsDic = self.collectionViewDataSourceArray[indexPath.row];
        //        FTVideoBean *bean = [FTVideoBean new];
        //        [bean setValuesWithDic:newsDic];
        
        FTArenaBean *bean = self.collectionViewDataSourceArray[indexPath.row];
        //标记已读
//        if (![bean.isReader isEqualToString:@"YES"]) {
//            bean.isReader = @"YES";
//            //从数据库取数据
//            DBManager *dbManager = [DBManager shareDBManager];
//            [dbManager connect];
//            [dbManager updateVideosById:bean.videosId isReader:YES];
//            [dbManager close];
//        }
        
        
        postsDetailVC.arenaBean = bean;
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
        postsDetailVC.indexPath = theIndexPath;
        
        postsDetailVC.delegate = self;
        
        [self.navigationController pushViewController:postsDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}

- (void)updateButtonRightRedPointDisplay{
    //历史课程的红点
    [self updateCourseHistoryButtonRightRedPointDisplay];
    
    //技能按钮右边的红点
    [self updateSkillButtonRightRedPointDisplay];
}

- (void)updateSkillButtonRightRedPointDisplay{
    if ([self hasAnyUnreadSkillChange]) {
        //如果有任何未读的记录，显示红点
        _redPoint2.hidden = NO;
    } else {
        _redPoint2.hidden = YES;
    }
}

/**
 刷新历史课程按钮右边的红点
 */
- (void)updateCourseHistoryButtonRightRedPointDisplay{
    if ([self hasAnyUnreadCourseRecord]) {
        //如果有任何未读的记录，显示红点
        _redPoint1.hidden = NO;
    } else {
        _redPoint1.hidden = YES;
    }
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.collectionViewDataSourceArray.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTVideoCollectionViewCell" owner:self options:nil]firstObject];
    }
//    NSDictionary *dic = _collectionViewDataSourceArray[indexPath.row];
//    [cell setWithDic:dic];
    FTArenaBean *arenaBean = _collectionViewDataSourceArray[indexPath.row];
    [cell setWithArenaBean:arenaBean];
    return cell;
}
//更新视频的点赞、评论数量
- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.collectionViewDataSourceArray[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.viewCount] forKey:@"viewCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.commentCount] forKey:@"commentCount"];
    //    NSLog(@"indexPath.row : %ld", indexPath.row);
    self.collectionViewDataSourceArray[indexPath.row] = dic;
    //    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    [_videoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 关注
#pragma -mark 点赞按钮被点击

- (IBAction)followViewClicked:(id)sender {
    [MobClick event:@"rankingPage_HomePage_Follow"];
    
    FTUserBean *localUser = [FTUserBean loginUser];
    if (!localUser) {
        [self login];
    }else{
        self.hasFollow = !self.hasFollow;
        [self updateFollowImageView];
        _followView.userInteractionEnabled = NO;
        [self uploadVoteStatusToServer];
    }

}

- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

- (void)updateFollowImageView{
    if (self.hasFollow) {
        _followImageView.image = [UIImage imageNamed:@"关注pre"];
        
    }else{
        _followImageView.image = [UIImage imageNamed:@"关注"];
    }
}

//把点赞信息更新至服务器
- (void)uploadVoteStatusToServer{
    
   FTUserBean *user = [FTUserBean loginUser];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:_hasFollow ? AddFollowURL : DeleteFollowURL];
    
    NSString *userId = user.olduserid;
    NSString *objId;
    if (_boxerId) {
        objId = _boxerId;
    }else if(_coachId){
        objId = _coachId;
    }else if(_userid){
        objId = _userid;
    }
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _followTableName;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, self.hasFollow ? AddFollowCheckKey: CancelFollowCheckKey]];
    
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
        NSLog(@"%@ : %@", self.hasFollow ? @"增加" : @"删除", urlString);
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求返回的数据类型为默认类型（NSData类型)
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"vote status : %@", responseDic[@"status"]);
        NSLog(@"vote message : %@", responseDic[@"message"]);
        
        _followView.userInteractionEnabled = YES;
        if ([responseDic[@"status"] isEqualToString:@"success"]) {//如果关注信息更新成功后，处理本地的赞数，并更新webview
            int voteCount = [_fansCountLabel.text intValue];//获取旧的粉丝数，然后＋1或－1
            if (self.hasFollow) {
                voteCount++;
            }else{
                if (voteCount > 0) {
                    voteCount--;
                }
            }
            _fansCountLabel.text = [NSString stringWithFormat:@"%d", voteCount];
            
        }
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
        _followView.userInteractionEnabled = YES;
        NSLog(@"vote failure ：%@", error);
    }];
    
}
#pragma mark 从服务器获取是否已经关注
- (void)getFollowInfo{
    
    FTUserBean *user = [FTUserBean loginUser];
    if(!user) return;//如果没有登录，则直接返回
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId;
    if (_boxerId) {
         objId = _boxerId;
    }else if(_coachId){
        objId = _coachId;
    }else if(_userid){
        objId = _userid;
    }
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = _followTableName;
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
        NSLog(@"get vote urlString : %@", urlString);
    //创建AAFNetWorKing管理者
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //success
                NSLog(@"get vote info sucess. vote status : %@", responseDic[@"message"]);
        
        if ([responseDic[@"message"] isEqualToString:@"true"]) {
            self.hasFollow = YES;
        }else{
            self.hasFollow = NO;
        }
        
        [self updateFollowImageView];
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
        //failure
    }];
}
/**
 *  ”发新帖“按钮被点击
 *
 *  @param sender
 */
- (IBAction)newPostsButtonClicked:(id)sender {
    FTNewPostViewController *newPostViewController = [FTNewPostViewController new];
    newPostViewController.isShowSyncView = YES;
    newPostViewController.title = @"发新帖";
    [self.navigationController pushViewController:newPostViewController animated:YES];
}
- (IBAction)commentButtonClicked:(id)sender {
    
    if (![self isLogined]) {
        return;
    };
    
    [MobClick event:@"rankingPage_HomePage_Message"];
    FTHomepageCommentListViewController *commentListViewController = [FTHomepageCommentListViewController new];
    if (_boxerId) {
        commentListViewController.objId = _boxerId;
    }else if(_coachId){
        commentListViewController.objId = _coachId;
    }else if(_userid){
        commentListViewController.objId = _userid;
    }
    
    //个人中心所有的评论的tablename都是“c-user"
    commentListViewController.tableName = @"c-user";
    
    [self.navigationController pushViewController:commentListViewController animated:YES];
}


/************************************   code by kangxq   *************************************************/
#pragma mark - notification 

- (void) setNotification {
    
    //注册通知
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hideNavigationBar:) name:HideHomePageNavNoti object:nil];
    
    if (self.isCurrentUser) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newPostSuccess) name:NewPostSuccessNoti object:nil];
    }
}
#pragma mark - 设置界面

/**
 设置导航栏样式
 */
- (void) setNavigationbar {
    
//    self.navigationController.navigationBar.hidden = YES;
    [self.tabBarController.navigationController.navigationBar setHidden:YES];
    
    if ([_navigationSkipType isEqualToString:@"PRESENT"]) {
        //设置左侧按钮
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                       initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-取消"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(dismissBtnAction:)];
        //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else if ([_navigationSkipType isEqualToString:@"TABBAR"]){
        // hide left navigation button
    }else {
        
        //设置左侧按钮
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                       initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(popBtnAction:)];
        //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }

}


//- (void) viewDidAppear:(BOOL)animated {
//    
//    self.navigationController.navigationBar.hidden = YES;
//}

/**
 设置view上的返回按钮，非导航栏返回按钮
 */
- (void) setBackButton {
    
    //设置左上角的返回按钮
    UIButton *leftBackButton = [[UIButton alloc]init];
    leftBackButton.frame = CGRectMake(-2, 19, 60, 44);
    [self.view addSubview:leftBackButton];
    [self.view bringSubviewToFront:leftBackButton];
    
    if ([_navigationSkipType isEqualToString:@"PRESENT"]) {
        [leftBackButton setImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
        [leftBackButton addTarget:self action:@selector(dismissBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [leftBackButton setImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
        [leftBackButton addTarget:self action:@selector(popBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }

}


#pragma mark - response

- (void) popBtnAction:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) dismissBtnAction:(id) sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//拳吧发了新帖子后，刷新动态列表
- (void)newPostSuccess{
    [self getDataFromWeb];
}

- (void) loginCallBack:(NSNotification *) noti {

    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        
        FTUserBean *loginUser = [FTUserBean loginUser];
//        if (loginUser) {
//            self.olduserid = loginUser.olduserid;
//            [self getHomepageUserInfo];
//        }
        self.olduserid = loginUser.olduserid;
        [self clearCache];
        [self getHomepageUserInfo];//请求数据
    }
    
    if ([userInfo[@"type"] isEqualToString:@"Logout"]) {
        self.tabBarController.selectedIndex = 0;
    }
}

- (void)clearCache{
    //清除本地存储的上课记录
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:COURSE_VERSION];
    
    //清除本地的技能数据
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:SKILL_VERSION];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FATHER_SKILLS_ARRAY];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:CHILD_SKILLS_ARRAY];
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:FATHER_SKILL_VERSION_DIC];
    
    //同步
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    //清除内存中的动态信息，并刷tableView
    _tableViewController.sourceArray = nil;
    _tableViewDataSourceArray = nil;
    [_tableViewController.tableView reloadData];
    
    //清除内存中的历史课程，并刷tableView
    _courseHistoryArray = nil;
    [_courseHistoryTableView reloadData];
    
    //清除内存中的动态信息，并刷tableView
    _fatherSkillArray = nil;
    _childSkillArray = nil;
    [_skillsTableView reloadData];
}

//- (void) hideNavigationBar:(NSNotification *) noti {
//
////    [self.navigationController.navigationBar setHidden:YES];
//    [self.tabBarController.navigationController.navigationBar setHidden:YES];
//}


@end
