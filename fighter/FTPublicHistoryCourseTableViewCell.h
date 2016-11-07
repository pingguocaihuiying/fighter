//
//  FTPublicHistoryCourseTableViewCell.h
//  fighter
//
//  Created by 李懿哲 on 03/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTCourseHistoryBean.h"

@interface FTPublicHistoryCourseTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeSectionLabel;
@property (strong, nonatomic) IBOutlet UILabel *gradeInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightArrowImageview;
@property (strong, nonatomic) IBOutlet UILabel *orderCountLabel;
@property (strong, nonatomic) IBOutlet UIView *bottomDividingLine;

- (void)setWithCourseHistoryBean:(FTCourseHistoryBean *)courseHistoryBean;

@end
