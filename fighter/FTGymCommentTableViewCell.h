//
//  FTGymCommentTableViewCell.h
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTGymCommentBean.h"
@protocol CellDelegate;

@interface FTGymCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarMask;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (weak, nonatomic) IBOutlet UIView *containerView1;// 舒适度container

@property (weak, nonatomic) IBOutlet UIView *containerView2;// 实力container

@property (weak, nonatomic) IBOutlet UIView *containerView3;// 教学水平container

@property (weak, nonatomic) IBOutlet UIButton *thumbsButton; // 点赞按钮

@property (weak, nonatomic) IBOutlet UIButton *commentButton; // 评论按钮

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CollectionHeightConstraint;

// 舒适度
@property (weak, nonatomic) IBOutlet UIImageView *comfortImage1;
@property (weak, nonatomic) IBOutlet UIImageView *comfortImage2;
@property (weak, nonatomic) IBOutlet UIImageView *comfortImage3;
@property (weak, nonatomic) IBOutlet UIImageView *comfortImage4;
@property (weak, nonatomic) IBOutlet UIImageView *comfortImage5;

// 实力
@property (weak, nonatomic) IBOutlet UIImageView *strengthImage1;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImage2;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImage3;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImage4;
@property (weak, nonatomic) IBOutlet UIImageView *strengthImage5;

// 教学水平
@property (weak, nonatomic) IBOutlet UIImageView *levelImage1;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage3;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage4;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage5;

//@property (nonatomic, strong) NSArray *comfortArray;
//@property (nonatomic, strong) NSArray *strengthArray;
//@property (nonatomic, strong) NSArray *levelArray;

@property (nonatomic, weak) id<CellDelegate> cellDelegate;
@property (nonatomic, strong) FTGymCommentBean *commentbean;

- (void) setCellContentWithBean:(FTGymCommentBean *)bean;
- (void) setThumbState:(BOOL) state;
- (void) setCommentState:(BOOL) state;


@end
