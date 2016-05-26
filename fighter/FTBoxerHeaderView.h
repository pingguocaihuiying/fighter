//
//  TFBoxerHeaderView.h
//  fighter
//
//  Created by kang on 16/5/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTBoxerHeaderView : UIView

@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIImageView *avatarImageView;
@property (nonatomic, weak) UIButton *focusBtn;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *focusLabel;
@property (nonatomic, weak) UILabel *fansLabel;
@property (nonatomic, weak) UILabel *briefLabel;

+ (FTBoxerHeaderView *) headerView;

@end
