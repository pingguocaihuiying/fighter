//
//  FTBaseInfoTableViewCell.h
//  fighter
//
//  Created by Liyz on 4/11/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTOneImageInfoTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

@property (weak, nonatomic) IBOutlet UILabel *numOfCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfthumbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfTypeImageView;

- (void)setWithBean:(FTNewsBean *)bean;

@end
