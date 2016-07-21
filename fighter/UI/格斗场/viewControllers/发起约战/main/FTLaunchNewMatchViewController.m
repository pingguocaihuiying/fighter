//
//  FTLaunchNewMatchViewController.m
//  fighter
//
//  Created by Liyz on 6/29/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTLaunchNewMatchViewController.h"
#import "FTArenaChooseLabelView.h"
#import "FTChooseGymOrOpponentListViewController.h"
#import "FTIncomePercentView.h"

//总的可用点数，出去拳馆的固定收益20%（4点），还有80%（16点）
#define AllAvailableIncomePoint 16

@interface FTLaunchNewMatchViewController ()<FTArenaChooseLabelDelegate, FTIncomePercentPickerViewDelegate>
@property (nonatomic, strong)FTArenaChooseLabelView *chooseLabelView;//选择项目view
@property (nonatomic, strong)NSString *typeOfLabelString;//选择的项目
@property (weak, nonatomic) IBOutlet UIButton *fullyMatchButton;
@property (weak, nonatomic) IBOutlet UIButton *matchOverOneLevelButton;
@property (weak, nonatomic) IBOutlet UIButton *matchOverTwoLevelButton;

@property (weak, nonatomic) IBOutlet UIButton *selfPayButton;
@property (weak, nonatomic) IBOutlet UIButton *consultPayButton;
@property (weak, nonatomic) IBOutlet UIButton *opponentPayButton;
@property (weak, nonatomic) IBOutlet UIButton *supportPayButton;

@property (weak, nonatomic) IBOutlet UIButton *winnerPayButton;
@property (weak, nonatomic) IBOutlet UIButton *AAPayButton;
@property (weak, nonatomic) IBOutlet UIButton *loserPayButton;

@property (nonatomic, strong) FTIncomePercentView *selfIncomePercentView;//己方收益百分比选择器
@property (nonatomic, strong) FTIncomePercentView *opponentIncomePercentView;//opponent收益百分比选择器
@property (nonatomic, strong) FTIncomePercentView *supporterIncomePercentView;//supporter收益百分比选择器

@property (nonatomic, assign) NSInteger gymIncomePoint;// self income point ** 1 point equals 5 percent
@property (nonatomic, assign) NSInteger selfIncomePoint;// self income point ** 1 point equals 5 percent
@property (nonatomic, assign) NSInteger opponentIncomePoint;// opoonent income point ** 1 point  equals 5 percent
@property (nonatomic, assign) NSInteger supporterIncomePoint;// supporter income point ** 1 point  equals 5 percent

@property (weak, nonatomic) IBOutlet UILabel *selfIncomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *opponentIncomeLabel;
@property (weak, nonatomic) IBOutlet UIView *supportIncomeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *matchIncomeViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *supportIncomePercentLabel;

@end

@implementation FTLaunchNewMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self initSubViews];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;//显示导航栏
}

- (void)setNavigationBar{
    self.navigationItem.title = @"发起比赛";//设置默认标题
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
        self.navigationItem.rightBarButtonItem = confirmButton;
  
}

//初始化subviews
- (void)initSubViews{
    self.bottomGradualChangeView.hidden = YES;//隐藏底部的遮罩
    [self setNavigationBar];//设置导航栏
    [self displayMatchTypeButtons];
}

- (void)displayMatchTypeButtons{
    [_fullyMatchButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_matchOverOneLevelButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_matchOverTwoLevelButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    switch (_matchType) {
        case FTMatchTypeFullyMatch:
            [_fullyMatchButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchTypeOverOneLevel:
            [_matchOverOneLevelButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchTypeOverTwoLevel:
            [_matchOverTwoLevelButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

#pragma -mark -选择项目按钮被点击
- (void)initBaseData{
    
    //选择的项目，默认为－1
    _typeOfLabelString = @"-1";
    
    _matchType = FTMatchTypeFullyMatch;//默认完全匹配
    
    //默认收益点数
    _gymIncomePoint = 4;//默认为 4 ＊ 5 ＝ 20％
    _selfIncomePoint = 1;
    _opponentIncomePoint = 1;
    _supporterIncomePoint = 1;
    
    _gymName = @"天下一武道馆";
    _gymID = @"158";
    _selectedTimeSectionString = @"09:00~10:00";
    _ticketPrice = @"";
    _gymServicePrice = @"";
}
#pragma -mark -选择项目按钮被点击
- (IBAction)chooseLabelButtonClicked:(id)sender {
    NSLog(@"选择项目");
    if (_chooseLabelView == nil) {
        _chooseLabelView = [[FTArenaChooseLabelView alloc]init];
        
        
        //如果用户有identity字段，则说明不是普通用户（是拳手或教练）
        FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
        
        
        if (localUser.identity) {
            _chooseLabelView.isBoxerOrCoach = YES;
        }
        _chooseLabelView.delegate = self;
        [self.view addSubview:_chooseLabelView];
    }else{
        _chooseLabelView.hidden = NO;
    }
}
#pragma -mark -选择拳馆按钮被点击
- (IBAction)chooseGymButtonClicked:(id)sender {
    NSLog(@"选择拳馆");
    
    //判断是否选择了项目
    if (![self hasSelectedItem]) {
        [self showHUDWithMessage:@"请先选择项目"];
        return;
    }
    
    FTChooseGymOrOpponentListViewController *chooseGymListViewController = [FTChooseGymOrOpponentListViewController new];
    chooseGymListViewController.listType = FTGymListType;
    [self.navigationController pushViewController:chooseGymListViewController animated:YES];
}

#pragma -mark -选择对手按钮被点击
- (IBAction)chooseOpponentButtonClicked:(id)sender {
    NSLog(@"选择对手");
    
    //判断是否选择了项目
    if (![self hasSelectedItem]) {
        [self showHUDWithMessage:@"请先选择项目"];
        return;
    }
    
    FTChooseGymOrOpponentListViewController *chooseOpponentListViewController = [FTChooseGymOrOpponentListViewController new];
    chooseOpponentListViewController.listType = FTOpponentListType;
    chooseOpponentListViewController.choosedOpponentID = _challengedBoxerID;
    chooseOpponentListViewController.choosedOpponentName = _challengedBoxerName;
    
    [self.navigationController pushViewController:chooseOpponentListViewController animated:YES];
}

/**
 *  是否选择了项目
 *
 *  @return true/false
 */
- (BOOL)hasSelectedItem{
    if ([_typeOfLabelString isEqualToString:@"-1"]) {
        return false;
    }
    return true;
}

#pragma -mark -处理选择标签的回调
- (void)chooseLabel:itemValueEn{
    NSLog(@"itemValueEn: %@", itemValueEn);
    
    if (![itemValueEn isEqualToString:@""]) {
        _typeImageView.hidden = NO;
        _typeOfLabelString = itemValueEn;
        _typeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:itemValueEn]];
    }
    _chooseLabelView.hidden = YES;
}
/**
 *  返回上一个viewController
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  确定发起约战
 */
- (void)confirmButtonClicked{
    NSLog(@"添加比赛");
    
    if(![self validParams]){//参数检查
        return;
    };
    
    //支付
    
    
    //保存比赛信息至服务器
    [self addMatnToServer];
}

- (void)addMatnToServer{
    NSMutableDictionary *mDic = [NSMutableDictionary new];
    
    FTUserBean *localUser = [FTUserTools getLocalUser];
    NSString *userID = localUser.olduserid;//oladuserID。 a8c0ba8e2071425ab21737ec65f5a333
    //    NSString *userID = @"a8c0ba8e2071425ab21737ec65f5a333";//oladuserID。 a8c0ba8e2071425ab21737ec65f5a333
    NSString *userName = localUser.username;//发起人name
    
    NSString *timeSectionID = _selectedTimeSectionIDString;//时间段ID
    NSString *levelGap = [NSString stringWithFormat:@"%ld", _matchType];
    //    NSString *levelGap = @"lavelGap888";
    NSString *gymIncomePercent = [NSString stringWithFormat:@"%ld", _gymIncomePoint * 5];
    NSString *selfIncomePercent = [NSString stringWithFormat:@"%ld", _selfIncomePoint * 5];
    NSString *opponentIncomePercent = [NSString stringWithFormat:@"%ld", _opponentIncomePoint * 5];
    NSString *supporterIncomePercent = [NSString stringWithFormat:@"%ld", _supporterIncomePoint * 5];
    NSString *payStatus = @"0";//0 等待支付 1 支付完成
    NSString *loginToken = localUser.token;//loginToken 592eb34f9edd411b98e3ec9dcb46a976
    //    NSString *loginToken = @"592eb34f9edd411b98e3ec9dcb46a976";//loginToken 592eb34f9edd411b98e3ec9dcb46a976
    NSString *ts = [NSString stringWithFormat:@"%0.f", [[NSDate date]timeIntervalSince1970] * 1000];//此刻的时间戳
    NSString *labelCH = [FTTools getNameCHWithEnLabelName:_typeOfLabelString];
    NSString *theDate = [NSString stringWithFormat:@"%.0f", _selectedDateTimestamp * 1000];
    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",_gymName,_gymID,_gymServicePrice,opponentIncomePercent,gymIncomePercent,supporterIncomePercent,selfIncomePercent,labelCH,levelGap,loginToken,[self getPayMode], payStatus,theDate,_ticketPrice, timeSectionID, _selectedTimeSectionString,ts,userID,userName, @"gedoujiahdflshklfkdll252244"];
    NSLog(@"md5前的checksign： %@", checkSign);
    checkSign = [MD5 md5:checkSign];
    
    [mDic setValue:userID forKey:@"userId"];//用户ID
    [mDic setValue:[userName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"userName"];//用户名字
    [mDic setValue:_gymID forKey:@"corporationid"];//拳馆ID
    [mDic setValue:_gymName forKey:@"corporationName"];//拳馆名字
    [mDic setValue:timeSectionID forKey:@"timeId"];//时间段ID
    [mDic setValue:[labelCH stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"label"];//选择的比赛项目（中文）
    [mDic setValue:[levelGap stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding ] forKey:@"levelGap"];//匹配级别（0-完全匹配（默认），1-跨越1级别，2-跨越2级别）
    [mDic setValue:_ticketPrice forKey:@"ticket"];//门票价格
    [mDic setValue:_gymServicePrice forKey:@"cost"];//拳馆基础使用费用
    [mDic setValue:gymIncomePercent forKey:@"incomeCorp"];//拳馆收益
    [mDic setValue:selfIncomePercent forKey:@"incomeSponsor"];//己方收益名字
    [mDic setValue:opponentIncomePercent forKey:@"incomeAgainst"];//对手收益
    [mDic setValue:supporterIncomePercent forKey:@"incomePatron"];//赞助方收益
    [mDic setValue:[self getPayMode] forKey:@"payType"];//支付类型
    [mDic setValue:payStatus forKey:@"payStatu"];//支付状态
    [mDic setValue:theDate forKey:@"theDate"];//比赛日期
    [mDic setValue:_selectedTimeSectionString forKey:@"timeSection"];//
    [mDic setValue:loginToken forKey:@"loginToken"];//
    [mDic setValue:ts forKey:@"ts"];//
    [mDic setValue:checkSign forKey:@"checkSign"];//
    
    [NetWorking addMatchWithParams:mDic andOption:^(BOOL result) {
        if (result) {
            NSLog(@"添加比赛成功");
        }else{
            NSLog(@"添加比赛失败");
        }
    }];
}

- (NSString *)getPayMode{
    NSString *payMode = @"";
    switch (_matchPayMode) {
        case FTMatchPayModeSelf:
            payMode = @"0";
            break;
        case FTMatchPayModeOpponent:
            payMode = @"1";
            break;
        case FTMatchPayModeSupport:
            payMode = @"5";
            break;
        case FTMatchPayModeConsult:
            if (_matchPayConsultMode == FTMatchConsultPayModeWinner) {
                payMode = @"2";
            } else  if (_matchPayConsultMode == FTMatchConsultPayModeAA){
                payMode = @"3";
            }else  if (_matchPayConsultMode == FTMatchConsultPayModeLoser){
                payMode = @"4";
            }
            
            break;
        default:
            break;
    }
    return payMode;
}

- (BOOL)validParams{
    //检查所选的项目，拳馆是否支持
    if (![self isGymSupportSelectedItem]) {
        [self showHUDWithMessage:@"拳馆不支持所选项目"];
        //        return false;//测试数据限制，暂时关闭验证
    }
    return true;
}

- (BOOL)isGymSupportSelectedItem{
    NSString *labelCh = [FTTools getNameCHWithEnLabelName:_typeOfLabelString];
    NSArray *gymSupportedLabelsArray = [_gymSupportedLabelsString componentsSeparatedByString:@","];
    for(NSString *labelString in gymSupportedLabelsArray){
        if ([labelCh isEqualToString:labelString]) return true;//如果所选的项目在支持范围内，返回true
    }
    return false;
}

- (void)showHUDWithMessage:(NSString *)message{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [HUD removeFromSuperview];
        
    }];
}

- (IBAction)selfPayButtonClicked:(id)sender {
    NSLog(@"我方支付");
    
    _supporterIncomePoint = 0;//清零赞助收益比例
    
    _matchPayMode = FTMatchPayModeSelf;//更改支付类型
    [self refreshPayModeButtonsDisplay];//刷新显示
    
    _payModeViewHeight.constant = 89;//调整整个支付view的高度
    _consultPayDetailView.hidden = YES;//隐藏二级支付view
    
    //隐藏赞助方收益view
    _matchIncomeViewHeight.constant = 109;
    _supportIncomeView.hidden = YES;
}
- (IBAction)consultPayButtonClicked:(id)sender {
    NSLog(@"协定支付");
    
    _supporterIncomePoint = 0;//清零赞助收益比例
    
    _matchPayMode = FTMatchPayModeConsult;
    [self refreshPayModeButtonsDisplay];
    _payModeViewHeight.constant = 133;
    _consultPayDetailView.hidden = NO;
    
    //隐藏赞助方收益view
    _matchIncomeViewHeight.constant = 109;
    _supportIncomeView.hidden = YES;
}
- (IBAction)opponentPayButtonClicked:(id)sender {
    NSLog(@"对手支付");
    
    _supporterIncomePoint = 0;//清零赞助收益比例
    
    _payModeViewHeight.constant = 89;
    _consultPayDetailView.hidden = YES;
    
    //隐藏赞助方收益view
    _matchIncomeViewHeight.constant = 109;
    _supportIncomeView.hidden = YES;
    
    _matchPayMode = FTMatchPayModeOpponent;
    [self refreshPayModeButtonsDisplay];
}
- (IBAction)supportPayButtonClicked:(id)sender {
    NSLog(@"赞助");
    _payModeViewHeight.constant = 89;
    _consultPayDetailView.hidden = YES;
    
    //显示赞助方收益view
    _matchIncomeViewHeight.constant = 136;
    _supportIncomeView.hidden = NO;
    
    _matchPayMode = FTMatchPayModeSupport;
    [self refreshPayModeButtonsDisplay];
}

//根据支付方式去刷新一级支付buttons的背景色
- (void)refreshPayModeButtonsDisplay{
    //先把几个按钮都置为未选中，再根据实际支付方式去设置对应的按钮背景
    [_selfPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_consultPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_opponentPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_supportPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    
    switch (_matchPayMode) {
        case FTMatchPayModeSelf:
            [_selfPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchPayModeConsult:
            [_consultPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchPayModeOpponent:
            [_opponentPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchPayModeSupport:
            [_supportPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

//根据支付方式去刷新一级支付buttons的背景色
- (void)refreshConsultPayModeButtonsDisplay{
    //先把几个按钮都置为未选中，再根据实际协议支付方式去设置对应的按钮背景
    [_winnerPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_AAPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    [_loserPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景-ios"] forState:UIControlStateNormal];
    
    switch (_matchPayConsultMode) {
        case FTMatchConsultPayModeWinner:
            [_winnerPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchConsultPayModeAA:
            [_AAPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        case FTMatchConsultPayModeLoser:
            [_loserPayButton setBackgroundImage:[UIImage imageNamed:@"支付选项背景pre-ios"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (IBAction)winnerPayButtonClicked:(id)sender {
    _matchPayConsultMode = FTMatchConsultPayModeWinner;
    [self refreshConsultPayModeButtonsDisplay];
}

- (IBAction)AAPayButtonClicked:(id)sender {
    _matchPayConsultMode = FTMatchConsultPayModeAA;
    [self refreshConsultPayModeButtonsDisplay];
}

- (IBAction)loserPayButtonClicked:(id)sender {
    _matchPayConsultMode = FTMatchConsultPayModeLoser;
    [self refreshConsultPayModeButtonsDisplay];
}

/**
 *
 *
 *  @param sender
 */
- (IBAction)selfIncomeButtonClicked:(id)sender {
    NSInteger selfAvailablePoint = 16;
//    if (_opponentIncomePoint == 0) {
//        selfAvailablePoint = AllAvailableIncomePoint - _opponentIncomePoint - _supporterIncomePoint - 1;
//    }else{
//        selfAvailablePoint = AllAvailableIncomePoint - _opponentIncomePoint - _supporterIncomePoint;
//    }
//    
//    if (_matchPayMode == FTMatchPayModeSupport && _supporterIncomePoint == 0) {//如果是赞助支付,而且赞助方收益为0,要为赞助方预留2p（10%）出来
//        selfAvailablePoint -= 2;
//    }
//    
    _selfIncomePercentView = [[FTIncomePercentView alloc]initWithAvailablePoint:selfAvailablePoint andCurPoint:_selfIncomePoint];

        _selfIncomePercentView.delegate = self;
    _selfIncomePercentView.resultLabel.text = @"我方收益";
        [self.view addSubview:_selfIncomePercentView];
}
- (IBAction)opponentIncomeButtonClicked:(id)sender {
    NSInteger opponentAvailablePoint = 16;
//    if (_selfIncomePoint == 0) {
//        opponentAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint - 1;
//    }else{
//        opponentAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint;
//    }
//    
//    if (_matchPayMode == FTMatchPayModeSupport && _supporterIncomePoint == 0) {//如果是赞助支付,而且赞助方收益为0要为赞助方预留2p（10%）出来
//        opponentAvailablePoint -= 2;
//    }
    
    _opponentIncomePercentView = [[FTIncomePercentView alloc]initWithAvailablePoint:opponentAvailablePoint andCurPoint:_opponentIncomePoint];
    
    _opponentIncomePercentView.delegate = self;
    
    _opponentIncomePercentView.resultLabel.text = @"对方收益";
    [self.view addSubview:_opponentIncomePercentView];
}
- (IBAction)supporertIncomeButtonClicked:(id)sender {
    NSInteger supporterAvailablePoint = 16;
//    if (_selfIncomePoint == 0 && _opponentIncomePoint == 0) {//如果我方和对方收益都为0，则预留2p
//        supporterAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint - 2;
//    }else if (_selfIncomePoint == 0 || _opponentIncomePoint == 0){//如果我方和对方有一个收益都为0，则预留1p
//        supporterAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint - 1;
//    }else{
//        supporterAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint;
//    }
    _supporterIncomePercentView = [[FTIncomePercentView alloc]initWithAvailablePoint:supporterAvailablePoint andCurPoint:_opponentIncomePoint];
    
    _supporterIncomePercentView.delegate = self;
    
    _supporterIncomePercentView.resultLabel.text = @"赞助方收益";
    [self.view addSubview:_supporterIncomePercentView];
}

//收益百分比选择回调
- (void)pickerView:(FTIncomePercentView *)incomePercentView didSelectedIncomeValuePercent:(NSInteger)curIncomePoint{
    NSLog(@"curIncomePoint : %ld", (long)curIncomePoint);
    if (incomePercentView == _selfIncomePercentView) {
            _selfIncomePoint = curIncomePoint;
            _selfIncomeLabel.text = [NSString stringWithFormat:@"%ld%%", _selfIncomePoint * 5];
    }else if (incomePercentView == _opponentIncomePercentView){
        _opponentIncomePoint = curIncomePoint;
        _opponentIncomeLabel.text = [NSString stringWithFormat:@"%ld%%", _opponentIncomePoint * 5];
    }else if (incomePercentView == _supporterIncomePercentView){
        _supporterIncomePoint = curIncomePoint;
        _supportIncomePercentLabel.text = [NSString stringWithFormat:@"%ld%%", _supporterIncomePoint * 5];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
