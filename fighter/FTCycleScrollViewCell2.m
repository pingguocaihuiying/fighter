//
//  FTCycleScrollViewCell2.m
//  fighter
//
//  Created by kang on 16/6/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTCycleScrollViewCell2.h"
#import "UIView+SDExtension.h"

@implementation FTCycleScrollViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupImageView];
        [self setupTitleLabel];
    }
    
    return self;
}

- (void)setTitleLabelBackgroundColor:(UIColor *)titleLabelBackgroundColor
{
    _titleLabelBackgroundColor = titleLabelBackgroundColor;
    _titleLabel.backgroundColor = titleLabelBackgroundColor;
}

- (void)setTitleLabelTextColor:(UIColor *)titleLabelTextColor
{
    _titleLabelTextColor = titleLabelTextColor;
    _titleLabel.textColor = titleLabelTextColor;
}

- (void)setTitleLabelTextFont:(UIFont *)titleLabelTextFont
{
    _titleLabelTextFont = titleLabelTextFont;
    _titleLabel.font = titleLabelTextFont;
}

- (void)setupImageView
{
    UIImageView *imageView = [[UIImageView alloc] init];
    _imageView = imageView;
    [self.contentView addSubview:imageView];
}

- (void)setupTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc] init];
    _titleLabel = titleLabel;
    _titleLabel.hidden = YES;
    [self.contentView addSubview:titleLabel];
    
#pragma -mark 设置轮播图的遮罩层
    
    UIImageView *bgView;
    bgView = [self.contentView viewWithTag:1111];
    if (bgView == nil) {
        bgView = [[UIImageView alloc]initWithFrame:self.contentView.bounds];
        bgView.tag = 1111;
        bgView.image = [UIImage imageNamed:@"头图暗影遮罩-ios"];
        [self.contentView insertSubview:bgView belowSubview:_titleLabel];
        bgView.alpha = 0.3;
    }
    
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    _titleLabel.text = [NSString stringWithFormat:@"   %@", title];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    
    CGFloat titleLabelH = _titleLabelHeight;
    CGFloat titleLabelX = 0;
    CGFloat titleLabelY = self.sd_height - titleLabelH;
    _titleLabel.frame = CGRectMake(0, 129, SCREEN_WIDTH - 25 * 2, 16);
    _titleLabel.hidden = !_titleLabel.text;
    
}

@end
