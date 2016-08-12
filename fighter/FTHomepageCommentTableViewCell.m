//
//  FTHomepageCommentTableViewCell.m
//  fighter
//
//  Created by Liyz on 6/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTHomepageCommentTableViewCell.h"
#import "UILabel+FTLYZLabel.h"
#import "FTTools.h"

@implementation FTHomepageCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //设置评论内容的行高
    [UILabel setRowGapOfLabel:_commentContentLabel withValue:7];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setWithDic:(NSDictionary *)dic{
    self.authorNameLabel.text = dic[@"createName"] == [NSNull null] ? @"" : dic[@"createName"];
    self.commentContentLabel.text = dic[@"comment"]== [NSNull null] ? @"" : dic[@"comment"];
    NSString *timeStampString = [NSString stringWithFormat:@"%@", dic[@"createTime"] == [NSNull null] ? @"0" : dic[@"createTime"]];
    self.commentTimeLabel.text = [FTTools fixStringForDate:timeStampString];
    NSString *headUrlString = dic[@"headUrl"];
//    [_headImageButton sd_setImageWithURL:[NSURL URLWithString:headUrlString] forState:UIControlStateNormal];
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headUrlString == [NSNull null] ? @"" : headUrlString] placeholderImage:[UIImage imageNamed:@"头像-空"]];
}

- (IBAction)voteButtonClicked:(id)sender {
    NSLog(@"点赞按钮被点击");
}

@end
