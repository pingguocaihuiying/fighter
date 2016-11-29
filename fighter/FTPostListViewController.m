//
//  FTPostListViewController.m
//  fighter
//
//  Created by 李懿哲 on 28/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTPostListViewController.h"

#import "FTNewPostViewController.h"//导入发新帖
#import "FTPostListTableView.h"//导入自定义的tableView
#import "FTArenaViewController.h"// 测试

@interface FTPostListViewController ()

@property (nonatomic, strong) FTPostListTableView *postListTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *sectionDescLabel;
@property (strong, nonatomic) IBOutlet UIButton *followButton;


@property (strong, nonatomic) IBOutlet UIView *mainView;

@end

@implementation FTPostListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)setSubViews{
    //设置导航栏
    [self setNaviViews];
    
    //设置主view内容
    [self setMainView];
}

- (void)setNaviViews{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *newPostButton = [[UIBarButtonItem alloc]initWithTitle:@"发新帖" style:UIBarButtonItemStylePlain target:self action:@selector(newPostButtonClicked)];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationItem.rightBarButtonItem = newPostButton;
    
    //设置默认标题
    self.navigationItem.title = @"格斗明星";
}

/**
 返回上一个navi item
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)newPostButtonClicked {
    //测试
    FTArenaViewController *arenaViewController = [FTArenaViewController new];
    [self.navigationController pushViewController:arenaViewController animated:YES];
    return;
    
    NSLog(@"发新帖");
    
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [FTTools loginwithVC:self];
    }else{
        FTNewPostViewController *newPostViewController = [FTNewPostViewController new];
        newPostViewController.title = @"发新帖";
        [self.navigationController pushViewController:newPostViewController animated:YES];
    }
}

- (void)setMainView{
    _postListTableView = [[FTPostListTableView alloc]initWithFrame:CGRectMake(6, 0, SCREEN_WIDTH - 6 * 2, SCREEN_HEIGHT - 64 - 144)];// 6为边距
    [_mainView addSubview:_postListTableView];
}
@end
