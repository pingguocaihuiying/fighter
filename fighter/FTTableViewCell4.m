//
//  FTTableViewCell4.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTableViewCell4.h"

@implementation FTTableViewCell4


- (void)awakeFromNib {
    // Initialization code
}

- (void) layoutSubviews {

    [self.propertyContentLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void ) drawRect:(CGRect)rect {
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, Cell_Space_Color.CGColor);
    CGContextStrokeRect(context, CGRectMake(15, rect.size.height - 0.5, rect.size.width-15, 0.5));
    
}

@end
