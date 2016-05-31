//
//  UILabel+FTLYZLabel.m
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "UILabel+FTLYZLabel.h"

@implementation UILabel (FTLYZLabel)
+ (void)setRowGapOfLabel:(UILabel *)label withValue:(int )value{
    //调整行高
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];//调整行间距
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    label.attributedText = attributedString;
    [label sizeToFit];
}
@end
