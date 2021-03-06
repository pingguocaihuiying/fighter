 //
//  FTGymDetailWebViewController.m
//  fighter
//
//  Created by kang on 16/7/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#define itemsPerLine 5 //定义collectionView每行的个数
#define itemWidth 56    //collection cell宽度
#define itemHeight 78 //collection cell高度
#define minLineSpacing 15//最小行距
#define minInteritemSpacing 19.5//最小列间距


#import "FTGymDetailWebViewController.h"
#import "FTCommentViewController.h"
#import "MBProgressHUD.h"
#import "FTBaseNavigationViewController.h"
#import "FTLoginViewController.h"
#import "FTShareView.h"
#import "FTEncoderAndDecoder.h"
#import "NetWorking.h"
#import "FTPayForGymVIPViewController.h"
#import "FTGymVIPCollectionViewCell.h"
#import "FTGymPhotosViewController.h"
#import "FTGymCommentViewController.h"
#import "FTGymDetailBean.h"
#import "FTGymCommentsViewController.h"
#import "FTCoachSelfCourseViewController.h"
#import "FTGymCourceViewNew.h"//新课程表
#import "FTGymOrderCourseView.h"
#import "FTOrderCoachViewController.h"
#import "FTJoinGymVIPTipViewIsCoorView.h"//成为会员弹出框（合作拳馆）
#import "FTJoinGymVIPTipViewNotCoorerativeView.h"//成为会员弹出框（非合作拳馆）
#import "FTQuitGymViewAlertView.h"//退出弹出框

@interface FTGymDetailWebViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, FTLoginViewControllerDelegate, FTGymOrderCourseViewDelegate, FTGymCourseTableViewDelegate, FTScrollViewScollToBottomDelegate>

@property (nonatomic, strong) FTGymDetailBean *gymDetailBean;//拳馆详情bean
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;

@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;


@property (nonatomic, copy)NSString *webUrlString;
@property (strong, nonatomic) IBOutlet UILabel *gymAddressLabel;//地址label
@property (strong, nonatomic) IBOutlet UIView *addressSeperatorView;//地址view中右边的分割线
@property (strong, nonatomic) IBOutlet UIButton *tipButton;

//顶部和底部的分割线
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;
@property (strong, nonatomic) IBOutlet UIView *seperatorView4;
@property (strong, nonatomic) IBOutlet UIView *seperatorView5;
@property (strong, nonatomic) IBOutlet UIView *seperatorView6;

@property (strong, nonatomic) IBOutlet UIView *seperatorView7;
@property (strong, nonatomic) IBOutlet UIView *seperatorView8;

@property (nonatomic, strong) UIBarButtonItem *joinVIPButton;

//评分view
@property (strong, nonatomic) IBOutlet UIView *scoreView;


//展示拳手的collectionView
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIImageView *isVIPImage;

//collectionView左右离父视图的距离
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewPaddingLeft;//左
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewPaddingRight;//右
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionContainerViewHeight;

@property (strong, nonatomic) IBOutlet UIImageView *gymShowImageView;
@property (strong, nonatomic) IBOutlet UIView *haveVideoView;
@property (strong, nonatomic) IBOutlet UIButton *haveVideoButton;

@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *videoAndImageCountLabel;


@property (nonatomic, assign) BOOL displayAllVIP;//是否展示所有会员

@property (nonatomic, strong) NSMutableArray *coachArray;

@property (nonatomic, strong) FTGymCourceViewNew *gymSourceView;//课程表
@property (strong, nonatomic) IBOutlet UIView *gymSourceViewContainerView;//课程表view的父view
@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况
@property (nonatomic, assign) NSInteger curPlaceSerial;//当前场地的序列号，如果有多个，其值为1，2.。。；如果只有一个，值为0
@property (strong, nonatomic) IBOutlet UIButton *addressButton;

@end

@implementation FTGymDetailWebViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];//初始化默认数据
    [self registNoti];//注册通知
    [self setBackButtonStyle];//设置返回按钮的样式
    [self getGymDetailInfoFromServer];//获取拳馆详情
}

- (void) dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - init data

- (void)setTips{
    //如果读过，则不显示
    id readMark = [[NSUserDefaults standardUserDefaults]valueForKey:TIPS_GYM_COURSE];
    [_tipButton setHidden: readMark ? YES : NO];
}

- (void)initBaseData{
    _gymVIPType = FTGymVIPTypeNope;
}

- (void)getVIPInfo{
    NSString *corporationId = [NSString stringWithFormat:@"%ld",_gymDetailBean.corporationid];
    [NetWorking getVIPInfoWithGymId:corporationId andOption:^(NSDictionary *dic) {
        //无数据：非会员
        //"type"为会员类型： 0准会员 1会员 2往期会员
        NSString *status = dic[@"status"];
        NSLog(@"status : %@", status);
        if ([status isEqualToString:@"success"]) {
            NSString *type = dic[@"data"][@"type"];
            _gymVIPType = [type integerValue];//
            if (_gymVIPType == FTGymVIPTypeYep) {
                [self setToVIP];
            }else {
                [self setToNotVIP];
            }
        }else{//如果从接口读取失败，则默认按非会员处理
            _gymVIPType = FTGymVIPTypeNope;
            [self setToNotVIP];
        }
    }];
}

/**
 设置为VIP的UI
 */
- (void)setToVIP{
    //“隐藏”右上角的“成为会员”
    _joinVIPButton.enabled = NO;
    _joinVIPButton.title = @"";
    
    _isVIPImage.hidden = NO;//显示“我的拳馆”标识
    
    //地址栏后显示退出图标
    [_addressButton setImage:[UIImage imageNamed:@"退出拳馆28x38px"] forState:UIControlStateNormal];
    [_addressButton addTarget:self action:@selector(quitGymVIP) forControlEvents:UIControlEventTouchUpInside];
}

/**
 设置为非VIP的显示
 */
- (void)setToNotVIP{
    //右上角的“成为会员”
    _joinVIPButton.enabled = YES;
    _joinVIPButton.title = @"成为会员";
    
    //“我的拳馆”标识
    _isVIPImage.hidden = YES;
    
    //地址栏后显示地址图标
    [_addressButton setImage:[UIImage imageNamed:@"地点 (2)"] forState:UIControlStateDisabled];
    _addressButton.enabled = NO;
}

/**
 退出拳馆
 */
- (void)quitGymVIP{
    [self alertQuitGymConfirmView];
}

//弹出退出拳馆确认框
- (void)alertQuitGymConfirmView{
    FTQuitGymViewAlertView *quitGymViewAlertView = [[[NSBundle mainBundle] loadNibNamed:@"FTQuitGymViewAlertView" owner:nil options:nil] firstObject];
    [quitGymViewAlertView.confirmButton addTarget:self action:@selector(confirmQuitGym) forControlEvents:UIControlEventTouchUpInside];
    quitGymViewAlertView.frame = [[[UIApplication sharedApplication] keyWindow] bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:quitGymViewAlertView];
}

- (void)confirmQuitGym{
    [self sendQuitGymVIPToServer];
}

- (void)sendQuitGymVIPToServer{
    NSLog(@"退出拳馆");
    [NetWorking userQuitGymVIPGymCorporationId:[NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid]withBlock:^(NSDictionary *dic) {
        if (dic) {
            NSString *status = dic[@"status"];
            if ([status isEqualToString:@"success"]) {
                NSLog(@"退出成功");
                [self getVIPInfo];//更新VIP信息
                [FTNotificationTools postShowMembershipGymsNoti];//发送通知，刷新外部“学拳”界面
            }else{
                NSString *message = dic[@"message"];
                NSLog(@"message : %@", message);
            }
        }
    }];
}

/**
 //获取拳馆的详细信息
 */
- (void)getGymDetailInfoFromServer{
    [NetWorking getGymForGymDetailWithGymBean:_gymBean andOption:^(NSDictionary *dic) {
        if (dic) {
            _gymDetailBean = [FTGymDetailBean new];
            [_gymDetailBean setValuesForKeysWithDictionary:dic];
            //如果有多个场地，再显示多课表
            if (_gymDetailBean.placeBeans && _gymDetailBean.placeBeans.count > 0) [self setMutiCourseTable];
            
            [self doOtherThingWithGymDetailBean];
        }else{
            [self.view showMessage:@"没有获取到拳馆信息"];
        }
    }];
}


/**
 设置多课表
 */
- (void)setMutiCourseTable{
    _curPlaceSerial = 1;
}

/**
 更新课表左右两边的按钮显示状态，以及课表名字
 */
- (void)updateChangeCourseTableButtons{
    
    if (_gymDetailBean.placeBeans.count > 1) {//多课表才显示翻页按钮
        //翻页按钮的显示与否
        if (_curPlaceSerial == 1) {//如果当前页为1，
            _gymSourceView.prePlaceButton.hidden = YES;//不能往前翻，隐藏掉往前翻的按钮
            _gymSourceView.nextPlaceButton.hidden = NO;//当前为1，场地数>1,一定能往后翻
        } else {
            _gymSourceView.prePlaceButton.hidden = NO;//如果不是第一页，一定要可以往前翻，显示pre按钮
            if (_curPlaceSerial == _gymDetailBean.placeBeans.count) {//如果已经是最后一页，则隐藏next按钮
                _gymSourceView.nextPlaceButton.hidden = YES;
            } else {//如果不是最后一页，显示next按钮
                _gymSourceView.nextPlaceButton.hidden = NO;
            }
        }
        
        //课表名字
        FTPlaceBean *curPlaceBean = _gymDetailBean.placeBeans[_curPlaceSerial - 1];
        _gymSourceView.titleLabel.text = curPlaceBean.name;
    } else {//否则不显示翻页按钮
        _gymSourceView.prePlaceButton.hidden = YES;
        _gymSourceView.nextPlaceButton.hidden = YES;
    }
    
}

- (void)doOtherThingWithGymDetailBean{
    [self updateGymBaseInfo];
    [self getVIPInfo];//获取当前用户的会员信息
    [self loadGymCoachDataFromServer];
    [self setNavigationSytle];
    [self setSubViews];
    
    // 获取收藏信息
    [self getAttentionInfo];
    
    /*
        如果openItem为nil、0、或1，才显示团课表
     */
    BOOL hasPublicCourse = _gymDetailBean.openItem == 0 || _gymDetailBean.openItem == 1;
//    hasPublicCourse = false;
    if (hasPublicCourse) {//如果有团课
        [self setGymSourceView];//设置课程表
        [self getTimeSection];//获取拳馆时间段配置
        [self setTips];//控制tips是否显示
    }
}

- (void)loadGymCoachDataFromServer{
    //获取拳馆的教练列表
    [NetWorking getCoachesWithCorporationid:[NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid] andOption:^(NSArray *array) {
        if (array && array.count > 0) {
            _coachArray = [NSMutableArray arrayWithArray:array];
            [self updateCollectionView];
        }
    }];
}

- (void)updateGymBaseInfo{
    //如果视频个数为0，隐藏上方视频标识
    if (_gymDetailBean.videoCount == 0) {
        _haveVideoView.hidden = YES;
        _haveVideoButton.hidden = YES;
        
    }else{
        _haveVideoView.hidden = NO;
        _haveVideoButton.hidden = NO;
    }
    
    //更新展示照片
    NSArray *imageArray = _gymDetailBean.gymImgs;
    NSString *imageURLString;
    for(NSString *imageURL in imageArray){
        imageURLString = imageURL;
        if (imageURLString && imageURLString.length > 0) {
            break;
        }
    }
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", QiniuDomain, imageURLString];
    [_gymShowImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    
    //更新照片、视频个数
    _videoAndImageCountLabel.text = [NSString stringWithFormat:@"%d个视频 %d张照片", _gymDetailBean.videoCount, _gymDetailBean.pictureCount];
    
    //更新评价星级
    [FTTools updateScoreView:_scoreView withScore:_gymDetailBean.grade];
    
    //更新地址
    _gymAddressLabel.text = _gymDetailBean.gym_location;
    NSLog(@"行数 ：%ld", _gymAddressLabel.numberOfLines);
    
//    _bottomViewHeight.constant = 165;
    //更新评论数
    _commentCountLabel.text = [NSString stringWithFormat:@"%d人评价", _gymDetailBean.commentcount];
}



#pragma mark - 初始化

/**
 注册登录的通知
 */
- (void)registNoti{
    //注册通知，接收登录成功的消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginCallBack:) name:LoginNoti object:nil];
}

- (void)setBackButtonStyle{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
}


// 设置导航栏
- (void) setNavigationSytle {
    
    //设置默认标题
    self.navigationItem.title = self.gymDetailBean.gym_name;
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    

    
    // 导航栏转发按钮
    _joinVIPButton = [[UIBarButtonItem alloc]initWithTitle:@"成为会员" style:UIBarButtonItemStylePlain target:self action:@selector(becomeVIPButtonClicked:)];
    _joinVIPButton.enabled = NO;
    _joinVIPButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = _joinVIPButton;
    
    //因为拳馆详情的web页还没做，先隐藏掉分享功能 || 10月25日改为 成为会员
    
}


- (void)setSubViews{
    
//    [self setWebView];
//    [self setLoadingImageView];
    
    [self subViewFormat];//设置分割线颜色、label行间距等
    [self setCollectionView];//设置拳馆教练头像显示
    
    //电话
    _telLabel.text = [NSString stringWithFormat:@"%@", _gymDetailBean.gym_tel];
    _telLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dialButtonAction:)];
    [_telLabel addGestureRecognizer:tap];
}

- (void)subViewFormat{
    //分割线的颜色
    _addressSeperatorView.backgroundColor = Cell_Space_Color;
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
    _seperatorView4.backgroundColor = Cell_Space_Color;
    _seperatorView5.backgroundColor = Cell_Space_Color;
    _seperatorView6.backgroundColor = Cell_Space_Color;
    
    _seperatorView7.backgroundColor = Cell_Space_Color;
    _seperatorView8.backgroundColor = Cell_Space_Color;
    
//    [UILabel setRowGapOfLabel:_gymAddressLabel withValue:6];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_coachArray.count > itemsPerLine && _displayAllVIP) {
        if (indexPath.row == _coachArray.count) {
            _displayAllVIP = !_displayAllVIP;
            [self updateCollectionView];
            NSLog(@"收起");
        } else {
            NSDictionary *vipDic = _coachArray[indexPath.row];
            NSLog(@"vipName : %@", vipDic[@"name"]);
            [self pushToCoachVCWithDic:vipDic];
        }
    } else {
        if (_coachArray.count > itemsPerLine && indexPath.row == itemsPerLine - 1) {
            _displayAllVIP = !_displayAllVIP;
            [self updateCollectionView];
            NSLog(@"展开");
        } else {
            NSDictionary *vipDic = _coachArray[indexPath.row];
            NSLog(@"vipName : %@", vipDic[@"name"]);
            [self pushToCoachVCWithDic:vipDic];
        }
    }
}

- (void)pushToCoachVCWithDic:(NSDictionary *)coachDic{
    FTCoachBean *coachBean = [FTCoachBean new];
    [coachBean setWithDic:coachDic];
    
    FTOrderCoachViewController *orderCoachViewController = [FTOrderCoachViewController new];
    orderCoachViewController.gymOpenItem = _gymDetailBean.openItem;
    orderCoachViewController.coachBean = coachBean;
    [self.navigationController pushViewController:orderCoachViewController animated:YES];
}

- (void)setCollectionView{
    
    //创建flowLayout
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = minLineSpacing;//最小行间距
    flowLayout.minimumInteritemSpacing = minInteritemSpacing;//最小列间距
//    flowLayout.itemSize = CGSizeMake(40, 60);
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _collectionView.collectionViewLayout = flowLayout;
    
    //针对320屏进行适配
    if (SCREEN_WIDTH == 320) {
        NSLog(@"苹果6以下");
        _collectionViewPaddingLeft.constant *= SCALE;
        _collectionViewPaddingRight.constant *= SCALE;
        
        flowLayout.minimumLineSpacing  *= SCALE;//最小行间距
        flowLayout.minimumInteritemSpacing *= SCALE;//最小列间距
        flowLayout.itemSize = CGSizeMake(itemWidth * SCALE, itemHeight * SCALE);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _collectionView.collectionViewLayout = flowLayout;
    }
    
    _collectionView.scrollEnabled = NO;//禁止滚动
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //加载cell用于复用

    [_collectionView registerNib:[UINib nibWithNibName:@"FTGymVIPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
//    [self updateCollectionView];
    
}

- (void)setGymSourceView{
    _gymSourceView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymCourceViewNew" owner:nil options:nil]firstObject];
    _gymSourceView.courseType = FTGymPublicCourseTypeForUser;
    _gymSourceView.frame = _gymSourceViewContainerView.bounds;
    _gymSourceView.delegate = self;
    _gymSourceView.scrollDelegate = self;
    [_gymSourceView.prePlaceButton addTarget:self action:@selector(prePlaceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_gymSourceView.nextPlaceButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_gymSourceViewContainerView addSubview:_gymSourceView];
    [self updateChangeCourseTableButtons];//课表初始化后，更新翻页显示
}

- (IBAction)prePlaceButtonClicked:(id)sender {
    NSLog(@"上一个场地");
    if (_curPlaceSerial > 1) {
        _curPlaceSerial--;
    }
    
    [self updateChangeCourseTableButtons];//刷新显示
    [self getTimeSection];
    
    [self disablePreAndNextButton];//点击后暂时禁用，加载数据成功后在启用
    
    [self cleanCourseTableData];
}

- (void)cleanCourseTableData{
    //获取场地使用信息后，刷新UI
    _gymSourceView.placesUsingInfoDic = nil;
    [_gymSourceView reloadTableViews];
}

- (IBAction)nextButtonClicked:(id)sender {
    NSLog(@"下一个场地");
    if (_curPlaceSerial < _gymDetailBean.placeBeans.count) {
        _curPlaceSerial++;
    }
    
    [self updateChangeCourseTableButtons];//刷新显示
    [self getTimeSection];
    
    [self disablePreAndNextButton];//点击后暂时禁用，加载数据成功后在启用
    [self cleanCourseTableData];
}

- (void)disablePreAndNextButton{
    _gymSourceView.prePlaceButton.enabled = NO;
    _gymSourceView.nextPlaceButton.enabled = NO;
}

- (void)enablePreAndNextButton{
    _gymSourceView.prePlaceButton.enabled = YES;
    _gymSourceView.nextPlaceButton.enabled = YES;
}

- (void)updateCollectionView{
    
    if (_coachArray.count > itemsPerLine  && _displayAllVIP) {
        NSInteger line;
        if ((_coachArray.count + 1) % itemsPerLine == 0) {//如果刚好被整除
                line = (_coachArray.count + 1) / itemsPerLine;//行数
        }else{//如果没有被整出
            line = (_coachArray.count + 1) / itemsPerLine + 1;//行数
        }
        
        NSLog(@"line : %ld", (long)line);
        
        
        if (SCREEN_WIDTH == 320) {
            NSLog(@"SCREEN_WIDTH == 320");
            _collectionContainerViewHeight.constant = 10 + 15 + itemHeight * line * SCALE + 15 * (line - 1) * SCALE;
        }else{
            _collectionContainerViewHeight.constant = 10 + 15 + itemHeight * line + 15 * (line - 1);
        }
        
        
    } else {
        
        if (SCREEN_WIDTH == 320) {
            NSLog(@"SCREEN_WIDTH == 320");
            _collectionContainerViewHeight.constant = 10 + 15 + itemHeight * SCALE;
        }else{
            _collectionContainerViewHeight.constant = 10 + 15 +itemHeight;
        }
    }
    [_collectionView reloadData];
}

//多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

//某组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_coachArray) {
        if(_coachArray.count > itemsPerLine){
            //如果源数据vip数量大于itemsPerLine，需要分行显示，则显示『更多』、『收起』项
            return _coachArray.count + 1;
        }else{
            return _coachArray.count;
        }
    }else{
        return 0;
    }
}

//返回collectionView cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTGymVIPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];

    NSDictionary *vipDic = _coachArray[indexPath.row];
    NSString *imageURLString = vipDic[@"headUrl"];
    imageURLString = [FTTools replaceImageURLToHttpsDomain:imageURLString];
    
    if (_displayAllVIP) {//展示所有
        if (_coachArray.count > itemsPerLine && indexPath.row == _coachArray.count) {//『收起』
            cell.headerImageView.image = [UIImage imageNamed:@"学员列表-收起"];
            cell.vipNameLabel.text = @"收起";
        }else{
            
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]placeholderImage:[UIImage imageNamed:@"头像-空"]];
            
            NSString *name = vipDic[@"name"];
            cell.vipNameLabel.text = name;
        }
        
    } else {//只展示第一行
        
        if (indexPath.row >= itemsPerLine - 1) {
            if (_coachArray.count > itemsPerLine) {
                if (indexPath.row == itemsPerLine - 1) {
                    cell.headerImageView.image = [UIImage imageNamed:@"学员列表-更多"];
                    cell.vipNameLabel.text = @"更多";
                }
            }else{
//                NSDictionary *vipDic = _coachArray[indexPath.row];
                [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]placeholderImage:[UIImage imageNamed:@"头像-空"]];
                cell.vipNameLabel.text = vipDic[@"name"];
            }
        }else{
//            NSDictionary *vipDic = _coachArray[indexPath.row];
            [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]placeholderImage:[UIImage imageNamed:@"头像-空"]];
            cell.vipNameLabel.text = vipDic[@"name"];
        }
    }
    
    return cell;
}

#pragma mark 点击头部图片

- (IBAction)topImageClicked:(id)sender {
    NSLog(@"进入图集");
    FTGymPhotosViewController *photoViewController = [FTGymPhotosViewController new];
    photoViewController.gymDetailBean = _gymDetailBean;
    [self.navigationController pushViewController:photoViewController animated:YES];
}

// 关注按钮点击事件
- (IBAction)focusButtonAction:(id)sender {
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        self.hasAttention = !self.hasAttention;
        [self updateAttentionButtonImg];
        self.focusView.userInteractionEnabled = NO;
        [self uploadStarStatusToServer];
    }
}

// 分享按钮点击事件
- (IBAction)shareButtonAction:(id)sender {
    FTCoachSelfCourseViewController *coachSelfCourseViewController = [FTCoachSelfCourseViewController new];
    [self.navigationController pushViewController:coachSelfCourseViewController animated:YES];
    
    [MobClick event:@"videoPage_DetailPage_shareUp"];
    
    NSString *str = [NSString stringWithFormat:@"gymId=%d",_gymDetailBean.id];
    _webUrlString = [@"http://www.gogogofight.com/m/hall.html?" stringByAppendingString:str];
    
    NSString *imgStr = _gymDetailBean.gym_show_img;
    NSString *urlStr = nil;
    if (imgStr && imgStr.length > 0) {
        NSArray *tempArray = [imgStr componentsSeparatedByString:@","];
        urlStr = [NSString stringWithFormat:@"http://%@/%@",_gymDetailBean.urlprefix,[tempArray objectAtIndex:0]];
    }
    
    FTShareView *shareView = [FTShareView new];
    [shareView setUrl:_webUrlString];
    [shareView setTitle:_gymDetailBean.gym_name];
    [shareView setSummary:_gymDetailBean.gym_location];
    [shareView setImageUrl:urlStr];
    
    [self.view addSubview:shareView];
}


// 评论按钮点击事件
- (IBAction)commentButtonAction:(id)sender {
    
    [MobClick event:@"videoPage_DetailPage_Comment"];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (!localUser) {
        [self login];
    }else{
        [self pushToCommentVC];
    }
    
}

// 拨号点击事件
- (IBAction)dialButtonAction:(id)sender {
    
    NSString *urlStr = self.gymDetailBean.gym_tel;
    if (urlStr.length > 0) {
        UIAlertView *alertView =  [[UIAlertView alloc] initWithTitle:@""
                                                            message:urlStr
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"拨打",nil];
        alertView.tag = 1000;
        [alertView show];
    }else {
    
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"当前拳馆没有预留号码~"
                                                           delegate:nil
                                                  cancelButtonTitle:@"知道了"
                                                  otherButtonTitles:nil];
        [alerView show];
    }
    
}

- (void)backBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 成为会员被点击
 
 @param sender 右上角的按钮
 */
- (IBAction)becomeVIPButtonClicked:(id)sender {
    
    if ([FTTools hasLoginWithViewController:self]) {
        NSLog(@"成为会员");
        [self showJoinVIPTips];
    }
}

/**
 成为会员弹出框
 */
- (void)showJoinVIPTips{
    if (_gymDetailBean.is_cooperate) {//如果是合作拳馆
        [self showJoinGymVIPTipViewIsCoorView];//请用户二次确认
    }else{//如果不是合作拳馆
        [self showJoinGymVIPTipViewIsNotCoorView]; //弹出非合作拳馆的提示
    }
}

/**
 弹出加入VIP确认的提示框(已合作)
 */
- (void)showJoinGymVIPTipViewIsCoorView{
    FTJoinGymVIPTipViewIsCoorView *joinGymVIPTipViewIsCoorView = [[[NSBundle mainBundle] loadNibNamed:@"FTJoinGymVIPTipViewIsCoorView" owner:nil options:nil] firstObject];
    joinGymVIPTipViewIsCoorView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    joinGymVIPTipViewIsCoorView.gymNameLabel.text = _gymDetailBean.gym_name;
    [joinGymVIPTipViewIsCoorView.gymTelButton setTitle:_gymDetailBean.gym_tel forState:UIControlStateNormal];
    [joinGymVIPTipViewIsCoorView.gymTelButton addTarget:self action:@selector(dialButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [joinGymVIPTipViewIsCoorView.confirmButton addTarget:self action:@selector(confirmJoinVIP) forControlEvents:UIControlEventTouchUpInside];
    [[[UIApplication sharedApplication] keyWindow] addSubview:joinGymVIPTipViewIsCoorView];
}

/**
  弹出加入VIP确认的提示框(未合作)
 */
- (void)showJoinGymVIPTipViewIsNotCoorView{
    FTJoinGymVIPTipViewNotCoorerativeView *joinGymVIPTipViewNotCoorerativeView = [[[NSBundle mainBundle] loadNibNamed:@"FTJoinGymVIPTipViewNotCoorerativeView" owner:nil options:nil] firstObject];
    joinGymVIPTipViewNotCoorerativeView.frame = [[UIApplication sharedApplication] keyWindow].bounds;
    [joinGymVIPTipViewNotCoorerativeView.gymTelButton setTitle:_gymDetailBean.gym_tel forState:UIControlStateNormal];
    [joinGymVIPTipViewNotCoorerativeView.gymTelButton addTarget:self action:@selector(dialButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [[[UIApplication sharedApplication] keyWindow] addSubview:joinGymVIPTipViewNotCoorerativeView];
    
}

/**
 确定加入按钮被点击
 */
- (void)confirmJoinVIP{
    [self pushToPayForGymVIPViewController];
}

/**
 跳转到申请会员vc
 */
- (void)pushToPayForGymVIPViewController{
    FTPayForGymVIPViewController *payForGymVIPViewController = [[FTPayForGymVIPViewController alloc]init];
    FTCoachBean *firstCoach = [FTCoachBean new];
    [firstCoach setWithDic:[_coachArray firstObject]];
    payForGymVIPViewController.coachBean = firstCoach;
    payForGymVIPViewController.gymVIPType = _gymVIPType;
    payForGymVIPViewController.gymName = _gymDetailBean.gym_name;
    [self.navigationController pushViewController:payForGymVIPViewController animated:YES];

}

- (IBAction)tipButtonClicked:(id)sender {
    _tipButton.hidden = YES;
    //已经读过，存入本地
    [[NSUserDefaults standardUserDefaults] setValue:@"read" forKey:TIPS_GYM_COURSE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark 拳馆列表入口
- (IBAction)viewMoreCommentButtonClicked:(id)sender {
    
    FTGymCommentsViewController *gymCommentsVC = [[FTGymCommentsViewController alloc]init];
    gymCommentsVC.title = self.gymDetailBean.gym_name;//@"评论列表";
    gymCommentsVC.objId = [NSString stringWithFormat:@"%d",_gymDetailBean.id];
    
    __weak typeof(self) weakself = self;
    gymCommentsVC.freshBlock = ^(){
        //更新评论数
        weakself.commentCountLabel.text = [NSString stringWithFormat:@"%d人评价", ++weakself.gymDetailBean.commentcount];
        [weakself loadGymCoachDataFromServer];
    };
    [self.navigationController pushViewController:gymCommentsVC animated:YES];
}

// 登录响应
- (void) loginCallBack:(NSNotification *)noti {
    
    NSDictionary *userInfo = noti.userInfo;
    if ([userInfo[@"result"] isEqualToString:@"SUCCESS"]) {
        [self getVIPInfo];
        [self gettimeSectionsUsingInfo];
    }
    
}


#pragma mark - private method
// 跳转登录界面方法
- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}


// 跳转评论页面
- (void)pushToCommentVC{
    
    FTGymCommentViewController *commentVC = [ FTGymCommentViewController new];
    commentVC.objId = [NSString stringWithFormat:@"%d",_gymDetailBean.id];
    commentVC.title = self.gymDetailBean.gym_name;
    
    __weak typeof(self) weakself = self;
    commentVC.freshBlock = ^(){
        //更新评论数
        weakself.commentCountLabel.text = [NSString stringWithFormat:@"%d人评价", ++weakself.gymDetailBean.commentcount];
    };
    [self.navigationController pushViewController:commentVC animated:YES];

}

#pragma mark - 服务器交互
//  获取用户是否关注
- (void)getAttentionInfo{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:GetStateURL];
    NSString *userId = user.olduserid;
    NSString *objId = [NSString stringWithFormat:@"%d",_gymDetailBean.id];
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"f-gym";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, GetStatusCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        if ([dict[@"message"] isEqualToString:@"true"]) {
            self.hasAttention = YES;
        }else{
            self.hasAttention = NO;
        }
        
        [self updateAttentionButtonImg];
    }];
}

/**
 *  获取时间段信息
 */
- (void)getTimeSection{
    [NetWorking getGymTimeSlotsWithGymDetailBean:_gymDetailBean serialId:_curPlaceSerial andOption:^(NSArray *array) {
        _timeSectionsArray = array;
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            //获取时间段信息后，根据内容多少设置tableviews的高度，再刷新一次tableview
            _gymSourceView.timeSectionsArray = _timeSectionsArray;
            _gymSourceView.tableViewsHeight.constant = 42 * _timeSectionsArray.count;
            [self gettimeSectionsUsingInfo];
        }
        
    }];
}

//获取场地使用信息
- (void)gettimeSectionsUsingInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970]];
    [NetWorking getGymCourceInfoWithGymDetailBean:_gymDetailBean placeSerialId:_curPlaceSerial andTimestamp:timestampString  andOption:^(NSArray *array) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self enablePreAndNextButton];
        _placesUsingInfoDic = [NSMutableDictionary new];
        if (array) {
            for(NSDictionary *dic in array){
                NSString *theDate = [NSString stringWithFormat:@"%@", dic[@"theDate"]];//周几
                NSMutableArray *mArray = _placesUsingInfoDic[theDate];
                if(!mArray){
                    mArray = [NSMutableArray new];
                    [_placesUsingInfoDic setValue:mArray forKey:theDate];
                }
                [mArray addObject:dic];
            }
            //获取场地使用信息后，刷新UI
            _gymSourceView.placesUsingInfoDic = _placesUsingInfoDic;
            [_gymSourceView reloadTableViews];
        }else{
//            [[[UIApplication sharedApplication] keyWindow] showHUDWithMessage:@"没有查询到"];
            NSLog(@"没有获取到数据");
        }
    }];
}


//把收藏信息更新至服务器
- (void)uploadStarStatusToServer{
    
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:self.hasAttention ? AddFollowURL : DeleteFollowURL];
    
    NSString *userId = user.olduserid;
    NSString *objId = [NSString stringWithFormat:@"%d",_gymDetailBean.id];
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"f-gym";

    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@",loginToken, objId, tableName, ts, userId,self.hasAttention ? AddFollowCheckKey: CancelFollowCheckKey];
    NSLog(@"check sign : %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    NSLog(@"收藏url：%@", urlString);
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        self.focusView.userInteractionEnabled = YES;
        if (dict) {
            NSLog(@"关注状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
            }
        }
    }];
}

#pragma mark - webView response

- (void)updateAttentionButtonImg{
    
    if (self.hasAttention) {
        [self.focusButton setBackgroundImage:[UIImage imageNamed:@"关注pre"] forState:UIControlStateNormal];
        
    }else{
        [self.focusButton setBackgroundImage:[UIImage imageNamed:@"关注"] forState:UIControlStateNormal];
    }
}

#pragma mark - alertDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 1000) {
        
        if (buttonIndex == 1) {
            
            NSString *urlStr = _gymDetailBean.gym_tel;
            //获取目标号码字符串
            urlStr = [NSString stringWithFormat:@"tel://%@",urlStr];
            //转换成URL
            NSURL *url = [NSURL URLWithString:urlStr];
            //调用系统方法拨号
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}


- (void)courseClickedWithCell:(FTGymSourceTableViewCell *)courseCell andDay:(NSInteger)day andTimeSection:(NSString *) timeSection andDateString:(NSString *) dateString andTimeStamp:(NSString *)timeStamp{
    NSLog(@"day : %ld, timeSection : %@ dateString : %@", day, timeSection, dateString);
    
    if (![FTUserTools getLocalUser]) {
        NSLog(@"没有登录");
        [self login];
        return;
    }
    
    if(_gymVIPType != FTGymVIPTypeYep){//如果非会员
        if (_gymDetailBean.is_cooperate) {//如果是合作拳馆
            [self showJoinGymVIPTipViewIsCoorView];
        } else {//如果是非合作拳馆
            [self showJoinGymVIPTipViewIsNotCoorView];
        }
    }else{//如果是会员
        FTGymOrderCourseView *gymOrderCourseView = [[[NSBundle mainBundle]loadNibNamed:@"FTGymOrderCourseView" owner:nil options:nil] firstObject];
        //传递场地信息
        if (_gymDetailBean.placeBeans.count > 1) {//当场地数大于1时，才传递场地信息，否则（服务器）用默认的
            if (_curPlaceSerial > 0 && _curPlaceSerial <= _gymDetailBean.placeBeans.count) {
                FTPlaceBean *curBean = _gymDetailBean.placeBeans[_curPlaceSerial - 1];
                if (curBean) {
                    gymOrderCourseView.placeBean = curBean;
                }
            }
        }
        
        gymOrderCourseView.courseType = FTOrderCourseTypeGym;
        gymOrderCourseView.frame = CGRectMake(0, -64, SCREEN_WIDTH, SCREEN_HEIGHT);
        gymOrderCourseView.dateString = dateString;
        gymOrderCourseView.dateTimeStamp = timeStamp;
        
        NSDictionary *courseDic = courseCell.courserCellDic;
        NSString *webViewURL = courseDic[@"url"];
        gymOrderCourseView.webViewURL = webViewURL;
        
        if (courseCell.hasOrder) {
            NSLog(@"已经预约");
            
            NSDictionary *courseCellDic = courseCell.courserCellDic;
            gymOrderCourseView.courserCellDic = courseCellDic;
            
            gymOrderCourseView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
            gymOrderCourseView.delegate = self;
            gymOrderCourseView.status = FTGymCourseStatusHasOrder;
            [self.view addSubview:gymOrderCourseView];
            
        } else if (courseCell.canOrder) {
            
            
            NSDictionary *courseCellDic = courseCell.courserCellDic;
            gymOrderCourseView.courserCellDic = courseCellDic;
            gymOrderCourseView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
            gymOrderCourseView.delegate = self;
            gymOrderCourseView.status = FTGymCourseStatusCanOrder;
            [self.view addSubview:gymOrderCourseView];
            NSLog(@"可以预约");
        }else if (courseCell.isFull) {
            
            NSDictionary *courseCellDic = courseCell.courserCellDic;
            gymOrderCourseView.courserCellDic = courseCellDic;
            gymOrderCourseView.gymId = [NSString stringWithFormat:@"%ld", _gymDetailBean.corporationid];
            gymOrderCourseView.delegate = self;
            gymOrderCourseView.status = FTGymCourseStatusIsFull;
            [self.view addSubview:gymOrderCourseView];
            NSLog(@"满员");
        }else{
            //不能预约（可能因为数据无效等原因）
        }
    }
}

-(void)scrollToBottom{
//    UIView animation
    _mainScrollView.contentOffset = CGPointMake(0, _mainScrollView.contentSize.height - _mainScrollView.height);
}

- (void)bookSuccess{
    //预订成功后，刷新课程预订信息
    [self gettimeSectionsUsingInfo];
    [self getVIPInfo];
}

@end
