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

@end
