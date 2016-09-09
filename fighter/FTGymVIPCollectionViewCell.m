//
//  FTGymVIPCollectionViewCell.m
//  fighter
//
//  Created by 李懿哲 on 16/9/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymVIPCollectionViewCell.h"

@interface FTGymVIPCollectionViewCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerBGHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerBGWidth;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *nameLabelTopHeight;

@end

@implementation FTGymVIPCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (SCREEN_WIDTH == 320) {//对6以下机型做适配
        NSLog(@"苹果6以下");
        _headerWidth.constant *= SCALE;
        _headerHeight.constant *= SCALE;
        _headerBGHeight.constant *= SCALE;
        _headerBGWidth.constant *= SCALE;
        _nameLabelTopHeight.constant *= SCALE;
        
        _headerImageView.layer.cornerRadius = 19 * SCALE;
    }
}

@end
