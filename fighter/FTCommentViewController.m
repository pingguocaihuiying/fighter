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
//#import "NSString+EmojiFilter.h"

@interface FTCommentViewController () <UITextViewDelegate>
@property (nonnull, strong)UITextView *textView;
@end

@implementation FTCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)setSubViews{
    //设置textView的代理
//    self.textView.delegate = self;
    [self setLeftAndRightButtons];
    [self setTextView];
    //自动弹出键盘
    [_commentTextView becomeFirstResponder];
}

- (void)setLeftAndRightButtons{
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-取消"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
     [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
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

- (void)setTextView{
    CGRect textViewFrame = CGRectMake(6 + 15, 64 + 14 + 15, SCREEN_WIDTH - (6 + 15) * 2,300);
    
    _textView = [[UITextView alloc] initWithFrame:textViewFrame];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    _textView.delegate = self;//设置代理
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(6, 64 + 14, SCREEN_WIDTH - 6 * 2,300)];
    
    imageView.image = [UIImage imageNamed:@"金属边框-改进ios"];
    _textView.textColor = [UIColor colorWithHex:0xb4b4b4];
    _textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:imageView];
    
    [_textView sendSubviewToBack:imageView];
    [self.view addSubview:_textView];
    
    //在评论资讯的基础上，增加对评论进行评论的逻辑
    if (_userId && ![_userId isEqualToString:@""]) {
        UILabel *placeLabel = [UILabel new];
        NSString *placeHoldText = [NSString stringWithFormat:@"@%@", [_userName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        placeLabel.text = placeHoldText;
//        placeLabel.text = @"@ asdfasdf6as5d4g354";
        placeLabel.textColor = [UIColor lightGrayColor];
        placeLabel.font = [UIFont systemFontOfSize:14];
        [_textView addSubview:placeLabel];
        [_textView setValue:placeLabel forKey:@"_placeholderLabel"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)popVC{
    if ([self.delegate respondsToSelector:@selector(updateCountWithVideoBean: indexPath:)] ){
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)commentButtonClicked{
    NSString *comment = self.textView.text;
    //提示评论为空，或者全部空格
    if ([self isEmpty:comment]) {
        [self showHUDWithMessage:@"评论内容不能全部为空" isPop:NO];
        return;
    }
    
    //去除评论两端空格
    comment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *trimmedComment = [comment stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSLog(@"trimmedComment : %@",trimmedComment) ;
    //如果评论内容过长或过短，给出提示
    if (comment.length < 10 || comment.length > 100) {
        [self showHUDWithMessage:@"评论内容需在10~100字之间" isPop:NO];
        return;
    }
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *user = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:CommentURL];
    NSString *userId = user.olduserid;
    NSString *objId;
    objId= [NSString stringWithFormat:@"%@", _newsBean.newsId];
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName;
    
    if (self.newsBean) {
        tableName = @"c-news";
        objId= [NSString stringWithFormat:@"%@", _newsBean.newsId];
    }else if(self.videoBean){
        tableName = @"c-video";
        objId= [NSString stringWithFormat:@"%@", _videoBean.videosId];
    }else if(self.gymBean){
        objId= [NSString stringWithFormat:@"%ld", _gymBean.gymId];
        tableName = @"c-gym";
    }else if(self.arenaBean){
        objId= [NSString stringWithFormat:@"%@", _arenaBean.postsId];
        tableName = @"c-damageblog";
    }else if(self.matchDetailBean){
        objId= [NSString stringWithFormat:@"%@", _matchDetailBean.matchId];
        tableName = @"c-mat";
    }else if(_objId){
        objId= _objId;
        tableName = _tableName;
    }else{
        NSLog(@"error : 没有找到bean");
    }
    
    NSString *checkSign;
    if (_parentCommentId) {//如果parentId不为空，是二次评论
        checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",comment, loginToken, objId, _parentCommentId, tableName, ts, userId, @"gedoujia12555521254"];
    } else {
        checkSign = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",comment, loginToken, objId, tableName, ts, userId, @"gedoujia12555521254"];
    }

    
    checkSign = [MD5 md5:checkSign];
    comment = [comment stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"评论url：%@", urlString);
    
    //创建AAFNetWorKing管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"userId" : userId,
                          @"objId" : objId,
                          @"loginToken" : loginToken,
                          @"ts" : ts,
                          @"checkSign" : checkSign,
                          @"comment" : comment,
                          @"tableName" : tableName,
                          };
    NSMutableDictionary *mParamDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
    if (_parentCommentId) {
        [mParamDic setValue:_parentCommentId forKey:@"parentId"];
    }
    [manager POST:urlString parameters:mParamDic progress:nil success:^(NSURLSessionTask * _Nonnull task, id  _Nonnull responseObject) {
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
    } failure:^(NSURLSessionTask * _Nonnull task, NSError * _Nonnull error) {
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


#pragma mark - UITextViewDelegate 

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

//    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"]) {
//        return NO;
//    }
    //屏蔽系统表情
    if ([[UIApplication sharedApplication] textInputMode].primaryLanguage == nil){
        return NO;
    }
    
    //屏蔽输入法表情
    if (text.length > 0) {
        
        if ([self isContainsEmoji:text]) {
            return NO;
        }else {
            return YES;
        }
        
    }
    return YES;
}


#pragma mark - UITextViewDelegate 

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    NSLog(@"should end edit");
    return YES;
}
#pragma mark - private Method


/*
 * 判断string 是否包含输入法表情
 * 
 * 系统九宫格中文输入法测试包含表情
 */
- (BOOL)isContainsEmoji:(NSString *)string {
    
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         
         if (0xd800 <= hs && hs <= 0xdbff) {
             
             if (substring.length > 1) {
                 
                 const unichar ls = [substring characterAtIndex:1];
                 
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     
                     isEomji = YES;
                     
                 }
                 
             }
             
         } else if (substring.length > 1) {
             
             const unichar ls = [substring characterAtIndex:1];
             
             if (ls == 0x20e3) {
                 
                 isEomji = YES;
                 
             }
             
         } else {
             
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 
                 isEomji = YES;
                 
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 
                 isEomji = YES;
                 
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 
                 isEomji = YES;
                 
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 
                 isEomji = YES;
                 
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 
                 isEomji = YES;
                 
             }}
         
     }];
    
    return isEomji;
}

//判断内容是否全部为空格  yes 全部为空格  no 不是
- (BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}
@end
