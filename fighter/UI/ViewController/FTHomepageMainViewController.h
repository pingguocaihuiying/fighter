//
//  FTHomepageMainViewController.h
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//
typedef NS_ENUM(NSInteger, FTHomepageTableViewType) {
    FTHomepageDynamicInformation,
    FTHomepageRecord,
    FTHomepageVideo
};
#import "FTBaseViewController.h"

@interface FTHomepageMainViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *briefIntroductionTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userBgImageView;
@property (assign, nonatomic)FTHomepageTableViewType selectedType;

@property (weak, nonatomic) IBOutlet UIView *dynamicInfomationButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *recordButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *videoButtonIndexView;
@property (weak, nonatomic) IBOutlet UIView *buttonsContainerView;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UITableView *recordRankTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recordRankTableViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *recordListTableView;
@property (copy, nonatomic) NSString *olduserid;
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
@property (weak, nonatomic) IBOutlet UIButton *videoButton;
@property (weak, nonatomic) IBOutlet UIButton *dynamicButton;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIImageView *noDynamicImageView;
@property (weak, nonatomic) IBOutlet UIButton *shareAndModifyProfileButton;

@end
