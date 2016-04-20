//
//  FTThreeImageTableViewCell.h
//  fighter
//
//  Created by Liyz on 4/12/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTThreeImageInfoTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

@property (weak, nonatomic) IBOutlet UILabel *numOfCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfthumbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *newsTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView1;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView2;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView3;

@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *image3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthOfTypeImageView;
@end
