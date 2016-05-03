//
//  FTDrawerTableViewCell.h
//  fighter
//
//  Created by kang on 16/4/26.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDrawerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellTitle;
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;

- (void) setTitleWithString:(NSString *)string;
@end
