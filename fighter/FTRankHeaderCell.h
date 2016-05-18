//
//  FTRankHeaderCell.h
//  fighter
//
//  Created by kang on 16/5/17.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTRankHeaderCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UILabel *briefLabel;


- (void) setBriefLabelText:(NSString *)text;
@end
