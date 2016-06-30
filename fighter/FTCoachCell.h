//
//  FTCoachCellTableViewCell.h
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTCoachCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UILabel *fansNum;

@property (weak, nonatomic) IBOutlet UIView *labelsView;


- (void) labelsViewAdapter:(NSString *) labelsString;

- (CGFloat) caculateHeight:(NSString *) labelsString;

@end
