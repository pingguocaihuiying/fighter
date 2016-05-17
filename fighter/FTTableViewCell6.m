//
//  FTTableViewCell6.m
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTableViewCell6.h"

@implementation FTTableViewCell6

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void) layoutSubviews {
    
    //    [self.titleLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];/
    [self.contentLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];
    [self setBackgroundColor:[UIColor clearColor]];
//    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x3c3c3c];
    self.selectedBackgroundView = aView;
    
}

- (void ) drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHex:0x3c3c3c].CGColor);
    CGContextStrokeRect(context, CGRectMake(15, rect.size.height - 0.25, rect.size.width-30, 0.25));
    
}

@end
