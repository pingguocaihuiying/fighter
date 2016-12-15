//
//  FTNewsCell.h
//  fighter
//
//  Created by kang on 16/7/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTNewsCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;

@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;

@property (weak, nonatomic) IBOutlet UIImageView *labelImageView;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;

//@property (weak, nonatomic) IBOutlet UIButton *thumbButton;
//
//@property (weak, nonatomic) IBOutlet UIButton *comentButton;

// comment number label
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
// favor number label
@property (weak, nonatomic) IBOutlet UILabel *favorLabel;


@property (strong, nonatomic)NSIndexPath *indexPath;

- (void)setWithBean:(FTNewsBean *)bean;

@end
