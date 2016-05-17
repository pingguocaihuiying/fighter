//
//  FTRankTableVIewCell.m
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankTableVIewCell.h"

@implementation FTRankTableVIewCell

- (void)awakeFromNib {
    // Initialization code
}



- (void) layoutSubviews {
    
    //    [self.titleLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];/
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.weightLabel setTextColor:Main_Text_Color];
    [self.heightLabel setTextColor:Main_Text_Color];
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    
}


- (void ) drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, Cell_Space_Color.CGColor);
    CGContextStrokeRect(context, CGRectMake(69, rect.size.height - 0.25, rect.size.width, 0.25));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
