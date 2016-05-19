//
//  FTNewPostViewController.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewPostViewController.h"
#import "FTSelectedCategoriesView.h"
#import "FTArenaNetwork.h"

@interface FTNewPostViewController ()

@end

@implementation FTNewPostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setHideKeyboardEvent];
    [self setSubViews];
}

- (void)setSubViews{
    //设置顶部的按钮
    [self setTopButton];
    
    //设置下方的”项目标签“
    [self setPostCategories];
}

- (void)setHideKeyboardEvent{
    //点击空白收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)setPostCategories{
    NSLog(@"bottom : %f", self.contentTextView.bottom);
    FTSelectedCategoriesView *selectCategoriesView = [[FTSelectedCategoriesView alloc]initWithFrame:CGRectMake(4, self.contentTextViewContainer.bottom + 5, SCREEN_WIDTH - 4 * 2, 17 + 15 * 1 + 21)];
//    selectCategoriesView.backgroundColor = [UIColor redColor];
    [self.view addSubview:selectCategoriesView];
}

- (void)viewTapped{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
        //显示navigationBar
    self.navigationController.navigationBarHidden = NO;
    //注册键盘弹起、收回的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyBoardShow{
    NSLog(@"键盘弹出");
    if ([self.contentTextView isFirstResponder]) {
        CGRect rOfView = self.view.frame;
        rOfView.origin.y = -200;
        self.view.frame = rOfView;
    }
}
- (void)keyBoardHide{
    NSLog(@"键盘收回");
    CGRect rOfView = self.view.frame;
    rOfView.origin.y = 0;
    self.view.frame = rOfView;
}

- (void)setTopButton{
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置发布按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(newPostButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],UITextAttributeFont,
                                    nil];
    self.navigationItem.rightBarButtonItem = shareButton;
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
}
/**
 *  发布按钮被点击
 */
- (void)newPostButtonClicked{
    FTArenaNetwork *arenaNetwork = [FTArenaNetwork new];
    FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
    
    NSString *userId = localUser.olduserid;
//    NSString *userId = @"2345";
    
    NSString *loginToken = localUser.token;
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];
    
    NSString *title = self.titleTextField.text;
    NSString *content = self.contentTextView.text;
    NSString *tableName = @"damageblog";
    NSString *nickname = localUser.username;
    NSString *headUrl = localUser.headpic;
    NSString *urlPrefix = @"";
    NSString *pictureUrlNames = @"";
    NSString *videoUrlNames = @"";
    NSString *thumbUrl = @"";
    NSString *labels = @"Boxing";
    
//    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", content, headUrl, loginToken,nickname,pictureUrlNames,tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", content, labels, loginToken,pictureUrlNames,tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"loginToken":loginToken,
                          @"ts":ts,
                          @"title":title,
                          @"content":content,
                          @"tableName":tableName,
//                          @"nickname":nickname,
//                          @"headUrl":headUrl,
                          @"urlPrefix":urlPrefix,
                          @"pictureUrlNames":pictureUrlNames,
                          @"videoUrlNames":videoUrlNames,
                          @"thumbUrl":thumbUrl,
                          @"labels":labels,
                          @"checkSign":checkSign
                          };
    
    [arenaNetwork newPostWithDic:dic andOption:^(NSDictionary *dict) {
        NSLog(@"status : %@, message : %@", dict[@"status"], dict[@"message"]);
    }];
}

- (void)popVC{
//    [self.delegate updateCountWithNewsBean:_newsBean indexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
