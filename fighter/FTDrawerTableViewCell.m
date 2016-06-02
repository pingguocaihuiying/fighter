//
//  FTDrawerTableViewCell.m
//  fighter
//
//  Created by kang on 16/4/26.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerTableViewCell.h"


@implementation FTDrawerTableViewCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



- (void) setTitleWithString:(NSString *)string {
    
    self.cellTitle.text = string;
}
@end
