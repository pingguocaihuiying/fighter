//
//  FTPhoneCheckCell.m
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPhoneCheckCell.h"

@implementation FTPhoneCheckCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    
    // 描述占位文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    //富文本属性
    NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入手机号码" attributes:attr];
    [self.phoneTextField setAttributedPlaceholder:acountPlaceholder];
   
    
    NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
    attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入验证码" attributes:attr2];
    [self.checkCodeTextField setAttributedPlaceholder:passwordPlaceholder];
    
//    [self.phoneTextField setKeyboardType:UIKeyboardTypePhonePad];
//    [self.checkCodeTextField setKeyboardType:UIKeyboardTypePhonePad];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
