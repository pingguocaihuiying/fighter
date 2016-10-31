//
//  FTTraineeCell.h
//  fighter
//
//  Created by kang on 2016/10/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 学员列表cell
 */
@interface FTTraineeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarMaskImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContraintHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarContrainWidth;

@end
