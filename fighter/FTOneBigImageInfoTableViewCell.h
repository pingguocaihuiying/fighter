//
//  FTOneBigImageInfoTableViewCell.h
//  fighter
//
//  Created by Liyz on 4/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTOneBigImageInfoTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

@property (weak, nonatomic) IBOutlet UILabel *numOfCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfthumbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfTypeImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth;
@end
