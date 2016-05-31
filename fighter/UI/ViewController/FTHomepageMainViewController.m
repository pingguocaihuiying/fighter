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

@interface FTHomepageMainViewController ()
@property (strong, nonatomic)UIScrollView *scrollView;
@end

@implementation FTHomepageMainViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName: nibNameOrNil bundle:nibBundleOrNil]) {
        NSLog(@"briefIntroductionTextField : %@", _briefIntroductionTextField.text);
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    NSLog(@"briefIntroductionTextField : %@", _briefIntroductionTextField.text);
    [self initSubviews];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}
/**
 *  初始化一些默认配置
 */
- (void)initBaseData{
    _selectedType = FTHomepageDynamicInformation;
}

- (void)initSubviews{
    //调整行高
    [UILabel setRowGapOfLabel:self.briefIntroductionTextField withValue:6];

    //设置左上角的返回按钮
    UIButton *leftBackButton = [[UIButton alloc]init];
    [leftBackButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [leftBackButton addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
    leftBackButton.frame = CGRectMake(10, 30, 22, 22);
    [self.view addSubview:leftBackButton];
    [self.view bringSubviewToFront:leftBackButton];
    
    //如果用户安装了微信，再显示转发按钮
    if([WXApi isWXAppInstalled]){
        
    }
    //设置背景图片

    [_userBgImageView sd_setImageWithURL:[NSURL URLWithString:@"http://7xtvwy.com1.z0.glb.clouddn.com/2016-05-27%2017:00_2ece766d041b40d2ad7da8c08c15d97f"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
//        [UIImage blurImage:_userBgImageView];
        
        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        
        visualEffectView.frame = _userBgImageView.bounds;
        
        [_userBgImageView addSubview:visualEffectView];
    }];
}

- (void)setScrollView{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 49)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 1000);
    [self.view addSubview:_scrollView];
    
    //头像
    
}

#pragma -mark -切换按钮的点击事件
- (IBAction)dynamicInfomationButtonClicked:(id)sender {
    _selectedType = FTHomepageDynamicInformation;
    [self refreshButtonsIndex];
}
- (IBAction)recordButtonClicked:(id)sender {
    _selectedType = FTHomepageRecord;
    [self refreshButtonsIndex];
}
- (IBAction)videoButtonClicked:(id)sender {
    _selectedType = FTHomepageVideo;
    [self refreshButtonsIndex];
}

-(void)refreshButtonsIndex{
    switch (_selectedType) {
        case FTHomepageDynamicInformation:
            _dynamicInfomationButtonIndexView.hidden = NO;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = YES;
            break;
        case FTHomepageRecord:
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = NO;
            _videoButtonIndexView.hidden = YES;
            break;
        case FTHomepageVideo:
            _dynamicInfomationButtonIndexView.hidden = YES;
            _recordButtonIndexView.hidden = YES;
            _videoButtonIndexView.hidden = NO;
            break;
        default:
            break;
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
- (void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
