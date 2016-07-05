//
//  FTTeachVideoCell.h
//  fighter
//
//  Created by kang on 16/7/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTVideoBean.h"
#import "FTArenaBean.h"

@interface FTTeachVideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTopConstraint;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *myImageView;

@property (weak, nonatomic) IBOutlet UILabel *videoLengthLabel;

@property (weak, nonatomic) IBOutlet UIImageView *priceImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *viewCountlabel;

@property (weak, nonatomic) IBOutlet UILabel *voteCount;

@property (weak, nonatomic) IBOutlet UILabel *comentCountLabel;

- (void)setWithBean:(FTVideoBean *)bean;

- (void)setWithDic:(NSDictionary *)dic;

@end
