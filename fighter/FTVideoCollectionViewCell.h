//
//  FTVideoCollectionViewCell.h
//  fighter
//
//  Created by Liyz on 5/6/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTVideoBean.h"
#import "FTArenaBean.h"
#import "FTCoachPhotoBean.h"

@interface FTVideoCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoTypeImageView;
@property (weak, nonatomic) IBOutlet UILabel *viewCountlabel;
@property (weak, nonatomic) IBOutlet UILabel *voteCount;
@property (weak, nonatomic) IBOutlet UILabel *comentCountLabel;

//只用于展示的控件
@property (strong, nonatomic) IBOutlet UIButton *viewButton;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;
@property (strong, nonatomic) IBOutlet UIButton *commentButton;
@property (strong, nonatomic) IBOutlet UIView *labelViewContainer;
@property (strong, nonatomic) IBOutlet UIView *bottomCoontainerView;

@property (strong, nonatomic) IBOutlet UIImageView *videoMarkImageView;//视频标记,如果是视频，会显示，默认隐藏

- (void)setWithBean:(FTVideoBean *)bean;
- (void)setWithArenaBean:(FTArenaBean *)bean;
- (void)setWithDic:(NSDictionary *)dic;
- (void)setWithCoachPhotoBean:(FTCoachPhotoBean *)bean;
@end
