//
//  FTGymListViewController.m
//  fighter
//
//  Created by Liyz on 22/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymListViewController.h"
#import "FTGymViewForLaunchMatch.h"
#import "FTLaunchNewMatchViewController.h"
#import "ViewControllerTransitionDelegate.h"

@interface FTGymListViewController ()<ViewControllerTransitionDelegate>

@property (strong, nonatomic)  FTGymViewForLaunchMatch *gymView;

@end

@implementation FTGymListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews{
    self.navigationItem.title = @"选择拳馆";//设置默认标题
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self initGymView];
}

- (void) initGymView {
    
    if (!_gymView) {
//        _gymView = [[FTGymView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)andIsFromLaunchMatch:YES];
                _gymView = [[FTGymViewForLaunchMatch alloc]initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
        _gymView.delegate = self;
    }
    
    [self.view addSubview:_gymView];
    
}

/**
 *  返回上一个viewController
 */
- (void)popVC{
    /**
    
     */
        //返回前一个vc
        FTLaunchNewMatchViewController *launchNewMatchViewController = self.navigationController.viewControllers[1];
        
        //把选择的拳馆信息传递给上一个vc
        
//        launchNewMatchViewController.challengedBoxerName= _choosedOpponentName;
//        launchNewMatchViewController.challengedBoxerID = [NSString stringWithFormat:@"%@", _choosedOpponentID];
//        launchNewMatchViewController.opponentLabel.text = _choosedOpponentName;
//        launchNewMatchViewController.matchType = _matchType;
//        [launchNewMatchViewController displayMatchTypeButtons];
        [self.navigationController popToViewController:launchNewMatchViewController animated:YES];
}

#pragma mark - delegate
- (void)pushToController:(UIViewController *)viewController {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
