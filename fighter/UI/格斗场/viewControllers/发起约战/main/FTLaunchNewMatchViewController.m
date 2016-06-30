//
//  FTLaunchNewMatchViewController.m
//  fighter
//
//  Created by Liyz on 6/29/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTLaunchNewMatchViewController.h"
#import "FTArenaChooseLabelView.h"
#import "FTChooseGymListViewController.h"

@interface FTLaunchNewMatchViewController ()<FTArenaChooseLabelDelegate>
@property (nonatomic, strong)FTArenaChooseLabelView *chooseLabelView;//选择项目view
@property (nonatomic, strong)NSString *typeOfLabelString;//选择的项目
@end

@implementation FTLaunchNewMatchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
#pragma -mark -选择拳馆按钮被电击
- (IBAction)chooseGymButtonClicked:(id)sender {
    NSLog(@"选择拳馆");
    FTChooseGymListViewController *chooseGymListViewController = [FTChooseGymListViewController new];
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
    _payModeViewHeight.constant = 89;
    _consultPayDetailView.hidden = YES;
}
- (IBAction)consultPayButtonClicked:(id)sender {
    NSLog(@"协定支付");
    _payModeViewHeight.constant = 133;
    _consultPayDetailView.hidden = NO;
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
