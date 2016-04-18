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
    
}

- (void)setLeftAndRightButtons{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置分享按钮
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(popVC)];
    UIBarButtonItem *commentButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:(UIBarButtonItemStylePlain) target:self action:@selector(commentButtonClicked)];
    commentButton.tintColor = [UIColor whiteColor];
    [commentButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = commentButton;
    
    //设置默认标题
    self.navigationItem.title = @"发表评论";
    
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
