//
//  FTGymCommentsCell.h
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTContainerView.h"

@interface FTGymCommentsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet FTContainerView *container1;// 舒适度container

@property (weak, nonatomic) IBOutlet FTContainerView *container2;// 实力container

@property (weak, nonatomic) IBOutlet FTContainerView *container3;// 教学水平container

@property (weak, nonatomic) IBOutlet UIButton *thumbsButton; // 点赞按钮

@property (weak, nonatomic) IBOutlet UIButton *commentButton; // 评论按钮

@end
