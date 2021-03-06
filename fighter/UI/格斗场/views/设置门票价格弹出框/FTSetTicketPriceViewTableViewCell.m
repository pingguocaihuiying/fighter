//
//  FTSetTicketPriceViewTableViewCell.m
//  fighter
//
//  Created by Liyz on 7/5/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTSetTicketPriceViewTableViewCell.h"
#import "FTTools.h"

@interface FTSetTicketPriceViewTableViewCell()<UITextFieldDelegate>

@end

@implementation FTSetTicketPriceViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _extraPriceView.layer.borderColor = [UIColor colorWithHex:0x505050].CGColor;
    _extraPriceView.layer.borderWidth = 1;
    
    //设置价格输入框的代理
    _extraPriceTextField.delegate = self;
    [_extraPriceTextField becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)confirmButtonClicked:(id)sender {
    [_delegate confirtButtonClickedWithBasicPrice:_basicPrice andExtraPrice:_extraPriceNew andTotalPrice:[NSString stringWithFormat:@"%@%@", _basicPrice, _theNewExtraPrice]];
}
- (IBAction)cancleButtonClicked:(id)sender {
    [_delegate cancelButtonClicked];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"text : %@", textField.text);
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    NSLog(@"textfield即将结束编辑...");
    NSLog(@"即将结束编辑text : %@", textField.text);
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSLog(@"string : %@", string);
    BOOL result = [FTTools isNumText:string];
    if (result) {
        int basicPrice = [_basicPriceLabel.text intValue];
        int extraPriceNew = [[textField.text stringByReplacingCharactersInRange:range withString:string] intValue];
        _extraPriceNew = [NSString stringWithFormat:@"%d", extraPriceNew];
        //限制额外价格的长度，不能大于10000
        if (extraPriceNew > 9999) {
            return false;
        }
        
        int totalPrice = basicPrice + extraPriceNew;
        _theNewExtraPrice = [NSString stringWithFormat:@"%d 元", totalPrice];
        _totalPriceLabel.text = _theNewExtraPrice;
        NSLog(@"totalPrice : %d", totalPrice);
    }
    return result;
}

- (void)setPirceLabelWithBasicPrice:(NSString *)basicPriceString andExtraPrice:(NSString *)extraPriceString{
    if (!basicPriceString) {
        basicPriceString = @"0";
    }
    if (!extraPriceString) {
        extraPriceString = @"0";
    }
    _basicPriceLabel.text = basicPriceString;
    _extraPriceTextField.text = extraPriceString;
    int totalPrice = [basicPriceString intValue] + [extraPriceString intValue];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%d", totalPrice];
}
@end
