//
//  FTRankHeaderCell.m
//  fighter
//
//  Created by kang on 16/5/17.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankHeaderCell.h"

@implementation FTRankHeaderCell

- (void)awakeFromNib {
    // Initialization code
}


- (void) setBriefLabelText:(NSString *)text {
    
    
    self.briefLabel.numberOfLines = 0; // 需要把显示行数设置成无限制
    
//    CGRect oldFrame = self.briefLabel.frame;
//    NSLog(@"oldframe.w:%f",oldFrame.size.width);
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
    [self.briefLabel setAttributedText:attributedString];
    [self.briefLabel sizeToFit];
    
//    CGSize size =  [text sizeWithAttributes:
//                    [NSDictionary dictionaryWithObjectsAndKeys:self.briefLabel.font,NSFontAttributeName,paragraphStyle,NSParagraphStyleAttributeName, nil]];
//    
//
//    NSLog(@"size.w:%f",size.width);
//    NSInteger multiple = ceil(size.width/oldFrame.size.width);
//    oldFrame = CGRectMake(oldFrame.origin.x,
//                          160-size.height*multiple,
//                          size.width,
//                          size.height);
//    [self.briefLabel setFrame:oldFrame];
}



-(CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:7];
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(210, 50)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font,NSParagraphStyleAttributeName: paragraphStyle}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}



/**
 
 @return 根据字符串的的长度来计算UITextView的高度
 */
+(float)heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    float height = [[NSString stringWithFormat:@"%@\n",value] boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size.height;
    
    return height;
}

/**
 
 UITextView根据内容自动改变frame
 */
+ (void)textViewDidChange:(UITextView *)textView
{
    [textView flashScrollIndicators];   // 闪动滚动条
    static CGFloat maxHeight = 130.0f;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if (size.height >= maxHeight)
    {
        size.height = maxHeight;
        textView.scrollEnabled = YES;   // 允许滚动
    }
    else
    {
        textView.scrollEnabled = NO;    // 不允许滚动，当textview的大小足以容纳它的text的时候，需要设置scrollEnabed为NO，否则会出现光标乱滚动的情况
    }
    textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
