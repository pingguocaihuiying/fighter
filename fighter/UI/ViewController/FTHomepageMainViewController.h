//
//  FTHomepageMainViewController.h
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

/**
 根据当前按钮的下标

 - FTHomepageTableViewTypeFirst: 第一个
 - FTHomepageTableViewTypeSecond: 第二个
 - FTHomepageTableViewTypeThird: 第三个
 */
typedef NS_ENUM(NSInteger, FTHomepageSelectedType) {
    FTHomepageTableViewTypeFirst,
    FTHomepageTableViewTypeSecond,
    FTHomepageTableViewTypeThird
};


#import "FTBaseViewController.h"

@interface FTHomepageMainViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *briefIntroductionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userBgImageView;//用户背景图
@property (assign, nonatomic)FTHomepageSelectedType selectedType;

@property (weak, nonatomic) IBOutlet UIView *dynamicInfomationButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *recordButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *videoButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UITableView *recordRankTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordRankTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *recordListTableView;
@property (copy, nonatomic) NSString *olduserid;
@property (nonatomic, copy) NSString *boxerId;//拳手id
@property (nonatomic, copy) NSString *coachId;//教练id
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;//关注数
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;//粉丝数
@property (weak, nonatomic) IBOutlet UILabel *dynamicCountLabel;//动态数
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *identityImageView3;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIButton *thirdButton;
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

@property (weak, nonatomic) IBOutlet UIImageView *noDynamicImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareAndModifyProfileButton;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIImageView *followImageView;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UIButton *bottomNewPostsView;
@property (weak, nonatomic) IBOutlet UIView *bottomFollowView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *fightRecordHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;



/**
 跳转个人主页的方式  TABBAR,PUSH,PRESENT
 */
@property (copy, nonatomic) NSString *navigationSkipType;


/**
 是否是当前用户的个人主页
 */
@property (nonatomic,assign) BOOL isCurrentUser;
@end
