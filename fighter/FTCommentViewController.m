//
//  FTCommentViewController.m
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCommentViewController.h"
#import "AFNetworking.h"
#import "FTNetConfig.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "HUD.h"
#import "NSString+EmojiFilter.h"

@interface FTCommentViewController ()<UITextViewDelegate>
@property (nonnull, strong)UITextView *textView;
@end

@implementation FTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];

}

- (void)setSubViews{
    //设置textView的代理
    self.textView.delegate = self;
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
    
    //设置右边的按钮
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
    
    _textView = [[UITextView alloc] initWithFrame:textViewFrame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 64 + 14, SCREEN_WIDTH - 6 * 2,300)];
    
    imageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
    _textView.textColor = [UIColor colorWithHex:0xb4b4b4];
    _textView.font = [UIFont systemFontOfSize:14];
//    [textView addSubview:imageView];
    [self.view addSubview:imageView];
    
    [_textView sendSubviewToBack:imageView];
    [self.view addSubview:_textView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commentButtonClicked{
    NSString *comment = self.textView.text;
    NSString *trimmedComment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"trimmedComment : %@",trimmedComment) ;
    //如果评论内容过长或过短，给出提示 test git
    if (comment.length < 10 || comment.length > 100) {
        [self showHUDWithMessage:@"评论内容需在10~100字之间" isPop:NO];
        return;
    }
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:CommentURL];
    urlString = @"http://10.11.1.117:8080/pugilist_admin/api/comment/add$UserComment.do";
    NSString *userId = user.olduserid;
    NSString *objId = [NSString stringWithFormat:@"%@", _newsBean.newsId];
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"c-news";
    
    NSString *checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",comment, loginToken, objId, tableName, ts, userId, @"gedoujia12555521254"];
    
    checkSign = [MD5 md5:checkSign];
    comment = [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&comment=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, comment, tableName];
//    NSLog(@"评论url：%@", urlString);
    
    //创建AAFNetWorKing管理者
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"userId" : userId,
                          @"objId" : objId,
                          @"loginToken" : loginToken,
                          @"ts" : ts,
                          @"checkSign" : checkSign,
                          @"comment" : comment,
                          @"tableName" : tableName
                          };
    [manager POST:urlString parameters:dic success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];

        if ([responseDic[@"status"] isEqualToString:@"success"]) {
            NSLog(@"评论成功");
            [self showHUDWithMessage:@"评论成功" isPop:YES];

            
        }else{
            NSLog(@"评论失败");
                    NSLog(@"status : %@, message : %@", responseDic[@"status"], responseDic[@"message"]);
            NSString *failueMessage = [NSString stringWithFormat:@"评论失败，%@", responseDic[@"message"]];
            [self showHUDWithMessage:failueMessage isPop:NO];
        }
        
        //success
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        NSLog(@"评论失败，failure: %@", error);
        [self showHUDWithMessage:@"评论失败，请检查网络" isPop:NO];
    }];
    //设置请求返回的数据类型为默认类型（NSData类型)
    
}
- (void)showHUDWithMessage:(NSString *)message isPop:(BOOL)isPop{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (isPop) {
            [self popVC];
            [self.delegate commentSuccess];
        }
        
        //        HUD = nil;
    }];
}
//屏蔽emoji表情输入
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string{
    NSLog(@"键盘：%@", [[UITextInputMode currentInputMode]primaryLanguage]);
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    return YES;
}
@end
