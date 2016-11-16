//
//  FTUserChildSkillTopInfoView.h
//  fighter
//
//  Created by 李懿哲 on 11/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTRatingBar.h"

@interface FTUserChildSkillTopInfoView : UIView
@property (strong, nonatomic) IBOutlet UILabel *skillName;

@property (strong, nonatomic) IBOutlet UILabel *skillDescLabel;

@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet FTRatingBar *ratingBar;
@property (strong, nonatomic) IBOutlet UIView *bottomDividingLine;
@end
