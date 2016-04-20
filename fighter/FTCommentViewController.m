//
//  FTCommentViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCommentViewController.h"

@interface FTCommentViewController ()

@end

@implementation FTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];

}

- (void)setSubViews{
    [self setLeftAndRightButtons];
    [self setBgOfTextView];
}

- (void)setLeftAndRightButtons{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-取消"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(popVC)];
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(commentButtonClicked)];
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [commentButton setImageInsets:UIEdgeInsetsMake(0, -8, 0, 20)];
    self.navigationItem.rightBarButtonItem = commentButton;
    
    //设置默认标题
    self.navigationItem.title = @"发表评论";
}

- (void)setBgOfTextView{
    CGRect textViewFrame = CGRectMake(6 + 15, 64 + 14 + 15, SCREEN_WIDTH - (6 + 15) * 2,300);
    
    UITextView *textView = [[UITextView alloc] initWithFrame:textViewFrame];
    textView.backgroundColor = [UIColor clearColor];
    textView.scrollEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 64 + 14, SCREEN_WIDTH - 6 * 2,300)];
    
    imageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
    textView.textColor = [UIColor colorWithHex:0xb4b4b4];
    textView.font = [UIFont systemFontOfSize:14];
//    [textView addSubview:imageView];
    [self.view addSubview:imageView];
    
    [textView sendSubviewToBack:imageView];
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commentButtonClicked{
    NSLog(@"comment button clicked.");
    [self.commentTextView resignFirstResponder];
    [self popVC];
}
@end
