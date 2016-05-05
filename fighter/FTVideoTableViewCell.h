//
//  FTVideoTableViewCell.h
//  fighter
//
//  Created by Liyz on 5/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTVideoTableViewCell : FTBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

@property (weak, nonatomic) IBOutlet UILabel *numOfCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfthumbLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoTypeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *myImageView;
@property (weak, nonatomic) IBOutlet UILabel *myTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfWatch;
@property (weak, nonatomic) IBOutlet UILabel *durationOfVideoLabel;

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
