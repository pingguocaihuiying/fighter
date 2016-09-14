//
//  FTGymCommentCell.m
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentCell.h"


@implementation FTGymCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _textView.placeholder = @"说点什么...";
    _textView.placeholderColor = Main_Text_Color;
    _textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - delegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    return YES;
}


//- (void)textViewDidBeginEditing:(UITextView *)textView;
//- (void)textViewDidEndEditing:(UITextView *)textView;
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;
//- (void)textViewDidChange:(UITextView *)textView;
//
//- (void)textViewDidChangeSelection:(UITextView *)textView;
//
//- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);
//- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0);

@end
