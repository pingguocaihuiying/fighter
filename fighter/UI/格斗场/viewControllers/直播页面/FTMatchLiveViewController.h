//
//  FTMatchLiveViewController.h
//  fighter
//
//  Created by mapbar on 16/8/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTMatchDetailBean.h"
#import "FTMatchbean.h"

@interface FTMatchLiveViewController : FTBaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *liveWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webViewTopHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *customViewTopheight;//自定义view上方的高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blueProgressBarHeight;

//进度条宽度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressWidth1;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *progressWidth2;
//双方下注数
@property (nonatomic, assign)int betsNum1;
@property (nonatomic, assign)int betsNum2;

//scrollView宽度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollViewWidth;

//下注数label
@property (strong, nonatomic) IBOutlet UILabel *betsNumLabel1;
@property (strong, nonatomic) IBOutlet UILabel *betsNumLabel2;
//评论tableview高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *commentTableViewHeight;
//评论tableView
@property (strong, nonatomic) IBOutlet UITableView *commentTableView;

@property (nonatomic, strong) FTMatchDetailBean *matchDetailBean;
@property (nonatomic, strong) FTMatchBean *matchBean;
@end
