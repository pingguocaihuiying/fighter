//
//  FTPayCell.m
//  fighter
//
//  Created by kang on 16/7/11.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPayCell.h"

@implementation FTPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void) setPriceLabelPrice:(NSString *) price  Power:(NSString *) power {
    
    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: power attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"P = " attributes: attrDict2];
    
    //第三段
    NSAttributedString *attrStr3 = [[NSAttributedString alloc] initWithString: price attributes: attrDict1];
    //第四段
    NSAttributedString *attrStr4 = [[NSAttributedString alloc] initWithString:@"￥" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    [text appendAttributedString: attrStr3];
    [text appendAttributedString: attrStr4];
    
    _priceLabel.attributedText = text;
}

@end
