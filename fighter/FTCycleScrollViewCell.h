//
//  FTCycleScrollViewCell.h
//  fighter
//
//  Created by kang on 16/6/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCycleScrollViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UILabel *brief;

@property (weak, nonatomic) IBOutlet UIView *labelView;


@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property(nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, assign) BOOL hasConfigured;

@end
