//
//  FTPracticeViewController.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPracticeViewController.h"
#import "FTSegmentedControl.h"
#import "FTPracticeView.h"
#import "FTCoachView.h"
#import "FTGymView.h"

#import "FTRankViewController.h"

@interface FTPracticeViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)  FTPracticeView *practiceView;
@property (strong, nonatomic)  FTCoachView *coachView;
@property (strong, nonatomic)  FTGymView *gymView;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (weak, nonatomic) IBOutlet UIButton *rankBtn;

@property (weak, nonatomic) IBOutlet UIButton *teachBtn;

@property (weak, nonatomic) IBOutlet UIButton *coachBtn;

@property (weak, nonatomic) IBOutlet UIButton *gymBtn;


@end

@implementation FTPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubviews];
    [self initPracticeView];
}

- (void)viewWillAppear:(BOOL)animated{
   
    self.navigationController.navigationBarHidden = YES;
}

- (void) initSubviews {

//    _pageControl.layer.borderWidth = 0.0;
    
    
    
    
//    NSArray *items = @[[[FTSegmentItem alloc] initWithTitle:@"教学" selectImg:@"三标签-左-选中" normalImg:@"三标签-左-空"],
//                        [[FTSegmentItem alloc] initWithTitle:@"教练" selectImg:@"三标签-中-选中"  normalImg:@"三标签-中-空"],
//                        [[FTSegmentItem alloc] initWithTitle:@"拳馆" selectImg:@"三标签-中-选中" normalImg:@"三标签-右-空"]];
//    FTSegmentedControl *segmented=[[FTSegmentedControl alloc] initWithFrame:CGRectMake(6, 64, SCREEN_WIDTH-12, 35)
//                                                                                 items:items
//                                                                          iconPosition:IconPositionRight
//                                                                     andSelectionBlock:^(NSUInteger segmentIndex) { }
//                                                                        iconSeparation:5];
//    segmented.color=[UIColor clearColor];
//    segmented.borderWidth=0.0;
////    segmented.selectedColor=[UIColor colorWithRed:244.0f/255.0 green:67.0f/255.0 blue:60.0f/255.0 alpha:1];
//    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                NSForegroundColorAttributeName:[UIColor whiteColor]};
//    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                        NSForegroundColorAttributeName:[UIColor redColor]};
//    [self.view addSubview:segmented];
    
    
    //设置左上角按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.leftBtn.layer setMasksToBounds:YES];
    self.leftBtn.layer.cornerRadius = 17.0;
    [self.leftBtn sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftBtn];
    }
    
    [_teachBtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    [_teachBtn setBackgroundImage:[UIImage imageNamed:@"三标签-左-选中"] forState:UIControlStateSelected];
    
    
}

// 练习view
- (void) initPracticeView {
    
    if (!_practiceView) {
        _practiceView = [[FTPracticeView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _practiceView.delegate = self;
    }
    
    [self.contentView addSubview:_practiceView];
}

- (void) initCoachView {

    if (!_coachView) {
        _coachView = [[FTCoachView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _coachView.delegate = self;
    }
    
    [self.contentView addSubview:_coachView];
    
}

- (void) initGymView {
    
    if (!_gymView) {
        _gymView = [[FTGymView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100-59)];
        _gymView.delegate = self;
    }
    
    [self.contentView addSubview:_gymView];
    
}


#pragma mark - delegate
- (void)pushToController:(UIViewController *)viewController {
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - response

- (IBAction)leftBtnAction:(id)sender {
    
//    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }
}

- (IBAction)rankBtnAction:(id)sender {
    
    FTRankViewController *rankHomeVC = [[FTRankViewController alloc] init];
    //    rankHomeVC.title = @"排行榜";
    //    [self.navigationController pushViewController:rankHomeVC animated:YES];
    [self.navigationController pushViewController:rankHomeVC animated:YES];
}



- (IBAction)teachBtnAction:(id)sender {
    
//    _teachBtn.enabled = NO;
    _teachBtn.selected = YES;
    
    _coachBtn.selected = NO;
    _coachBtn.enabled = YES;
    
    _gymBtn.selected = NO;
    _gymBtn.enabled = YES;
    
    
    [self initPracticeView];
    
    [_coachView removeFromSuperview];
    [_gymView removeFromSuperview];
}

- (IBAction)coachBtnAction:(id)sender {
    
    _teachBtn.enabled = YES;
    _teachBtn.selected = NO;
    
    _coachBtn.selected = YES;
//    _coachBtn.enabled = NO;
    
    _gymBtn.selected = NO;
    _gymBtn.enabled = YES;
    
    [self initCoachView];
    
    [_practiceView removeFromSuperview];
    [_gymView removeFromSuperview];
}

- (IBAction)gymBtnAction:(id)sender {
    
    _teachBtn.enabled = YES;
    _teachBtn.selected = NO;
    
    _coachBtn.selected = NO;
    _coachBtn.enabled = YES;
    
    _gymBtn.selected = YES;
//    _gymBtn.enabled = NO;
    
    [self initGymView];

    [_practiceView removeFromSuperview];
    [_coachView removeFromSuperview];
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
