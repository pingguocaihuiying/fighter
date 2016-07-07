//
//  FTDrawerCell.h
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDrawerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UILabel *subtitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

@property (weak, nonatomic) IBOutlet UIView *spaceView;

- (void) setTitleWithString:(NSString *)string;

@end
