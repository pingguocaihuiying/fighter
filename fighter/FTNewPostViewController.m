//
//  FTNewPostViewController.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewPostViewController.h"

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
    [self setTopButton];
    //收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
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
    NSString *title = self.titleTextField.text;
    NSString *content = self.contentTextView.text;
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
