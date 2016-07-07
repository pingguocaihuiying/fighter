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

@property (nonatomic, assign) NSInteger selfIncomePoint;// self income point ** 1 point equals 5 percent
@property (nonatomic, assign) NSInteger opponentIncomePoint;// opoonent income point ** 1 point  equals 5 percent
@property (nonatomic, assign) NSInteger supporterIncomePoint;// supporter income point ** 1 point  equals 5 percent

@property (weak, nonatomic) IBOutlet UILabel *selfIncomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *opponentIncomeLabel;

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
    _matchType = FTMatchTypeFullyMatch;//默认完全匹配
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
    FTChooseGymOrOpponentListViewController *chooseGymListViewController = [FTChooseGymOrOpponentListViewController new];
    chooseGymListViewController.listType = FTGymListType;
    [self.navigationController pushViewController:chooseGymListViewController animated:YES];
}

#pragma -mark -选择对手按钮被点击
- (IBAction)chooseOpponentButtonClicked:(id)sender {
    NSLog(@"选择对手");
    FTChooseGymOrOpponentListViewController *chooseGymListViewController = [FTChooseGymOrOpponentListViewController new];
    chooseGymListViewController.listType = FTOpponentListType;
    [self.navigationController pushViewController:chooseGymListViewController animated:YES];
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
    NSLog(@"确定");
}
- (IBAction)selfPayButtonClicked:(id)sender {
    NSLog(@"我方支付");
    _matchPayMode = FTMatchPayModeSelf;//更改支付类型
    [self refreshPayModeButtonsDisplay];//刷新显示
    
    _payModeViewHeight.constant = 89;//调整整个支付view的高度
    _consultPayDetailView.hidden = YES;//隐藏二级支付view
}
- (IBAction)consultPayButtonClicked:(id)sender {
    NSLog(@"协定支付");
    _matchPayMode = FTMatchPayModeConsult;
    [self refreshPayModeButtonsDisplay];
    _payModeViewHeight.constant = 133;
    _consultPayDetailView.hidden = NO;
}
- (IBAction)opponentPayButtonClicked:(id)sender {
    NSLog(@"对手支付");
    _payModeViewHeight.constant = 89;
    _consultPayDetailView.hidden = YES;
    _matchPayMode = FTMatchPayModeOpponent;
    [self refreshPayModeButtonsDisplay];
}
- (IBAction)supportPayButtonClicked:(id)sender {
    NSLog(@"赞助");
    _payModeViewHeight.constant = 89;
    _consultPayDetailView.hidden = YES;
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
    NSInteger selfAvailablePoint;
    if (_opponentIncomePoint == 0) {
        selfAvailablePoint = AllAvailableIncomePoint - _opponentIncomePoint - _supporterIncomePoint - 1;
    }else{
        selfAvailablePoint = AllAvailableIncomePoint - _opponentIncomePoint - _supporterIncomePoint;
    }
    _selfIncomePercentView = [[FTIncomePercentView alloc]initWithAvailablePoint:selfAvailablePoint andCurPoint:_selfIncomePoint];

        _selfIncomePercentView.delegate = self;
    _selfIncomePercentView.resultLabel.text = @"我方收益";
        [self.view addSubview:_selfIncomePercentView];
}
- (IBAction)opponentIncomeButtonClicked:(id)sender {
    NSInteger opponentAvailablePoint ;
    if (_selfIncomePoint == 0) {
        opponentAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint - 1;
    }else{
        opponentAvailablePoint = AllAvailableIncomePoint - _selfIncomePoint - _supporterIncomePoint;
    }
    _opponentIncomePercentView = [[FTIncomePercentView alloc]initWithAvailablePoint:opponentAvailablePoint andCurPoint:_opponentIncomePoint];
    
    _opponentIncomePercentView.delegate = self;
    
    _opponentIncomePercentView.resultLabel.text = @"对方收益";
    [self.view addSubview:_opponentIncomePercentView];
}

//收益百分比选择回调
- (void)pickerView:(FTIncomePercentView *)incomePercentView didSelectedIncomeValuePercent:(NSInteger)curIncomePoint{
    NSLog(@"curIncomePoint : %ld", (long)curIncomePoint);
    if (incomePercentView == _selfIncomePercentView) {
            _selfIncomePoint = curIncomePoint;
        _selfIncomeLabel.text = [NSString stringWithFormat:@"%ld%%", _selfIncomePoint * 5];
    }else if (incomePercentView == _opponentIncomePercentView)
        _opponentIncomePoint = curIncomePoint;
    _opponentIncomeLabel.text = [NSString stringWithFormat:@"%ld%%", _opponentIncomePoint * 5];
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
