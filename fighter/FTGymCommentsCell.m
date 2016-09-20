//
//  FTGymCommentsCell.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentsCell.h"

@implementation FTGymCommentsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    self.imagesViews = @[
//                         _levelImage1,
//                         _levelImage2,
//                         _levelImage3,
//                         _levelImage4,
//                         _levelImage5,
//                         ];
    
}

@end
