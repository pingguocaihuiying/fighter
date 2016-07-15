//
//  FTDrawerPayCell.m
//  fighter
//
//  Created by kang on 16/7/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerPayCell.h"

@implementation FTDrawerPayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor clearColor]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.cellTitle.textColor = [UIColor whiteColor];
}




#pragma mark - 显示余额
- (void) setBalanceText:(NSString *) balanceString {
    
    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:16.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: balanceString attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"P" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    
    [self.subtitle setAttributedText:text];
    
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
