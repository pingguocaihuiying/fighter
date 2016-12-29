//
//  FTNewsCell.m
//  fighter
//
//  Created by kang on 16/7/25.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTNewsCell.h"

@implementation FTNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[UIColor clearColor]];
    self.selected = NO;
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    self.imageHeightConstraint.constant = 210 * SCALE;
    
    [self.commentLabel setTextColor:Secondary_Text_Color];
    [self.favorLabel setTextColor:Secondary_Text_Color];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)thumbButtonClicked:(id)sender {
    NSLog(@"thumb button clicked.");
}
- (IBAction)commentButtonClicked:(id)sender {
    NSLog(@"comment button clicked.");
}

- (void)setWithBean:(FTNewsBean *)bean{//根据bean设置cell的显示内容
    
    if ([bean.isReader isEqualToString:@"YES"]) {
        [self.newsTitleLabel setTextColor:Main_Text_Color];
    }else {
        [self.newsTitleLabel setTextColor:[UIColor whiteColor]];
    }
    
    //设置来源标签的颜色
    self.fromLabel.textColor = Secondary_Text_Color;
    self.fromLabel.text = [NSString stringWithFormat:@"来源：%@", bean.author];

    self.newsTitleLabel.text = bean.title;
    
    NSString *imageURLString;
    if (bean.img_small_one && [bean.img_small_one length] > 0) {
        imageURLString = bean.img_small_one;
    }else if (bean.img_big && [bean.img_big length] > 0){
        imageURLString = bean.img_big;
    }
    
    imageURLString = [FTTools replaceImageURLToHttpsDomain:imageURLString];
    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"轮播大图-空"]];
//    [self.newsImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"轮播大图-空"] options:SDWebImageAllowInvalidSSLCertificates];
    
    //设置评论数、点赞数
    [self.favorLabel setText:bean.voteCount];
    [self .commentLabel setText: bean.commentCount];
    
//    NSString *commentCount = [NSString stringWithFormat:@"(%@)", bean.commentCount];
//    NSString *voteCount = [NSString stringWithFormat:@"(%@)", bean.voteCount];
//    self.numOfCommentLabel.text = commentCount;
//    self.numOfthumbLabel.text = voteCount;
    
    //根据newsType去设置类型图片
    self.labelImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:bean.newsType]];
    
    if ([bean.newsType isEqualToString:@"News"]) {
        [self.playButton setHidden:YES];
    }else {
        [self.playButton setHidden:NO];
    }
}


- (IBAction)playButtonAction:(id)sender {
    
    if([self.clickedDelegate respondsToSelector:@selector(clickedPlayButton:)]){
        [self.clickedDelegate clickedPlayButton:self.indexPath];
    }
}



//- (IBAction)thumbButtonAction:(id)sender {
////    if([self.clickedDelegate respondsToSelector:@selector(clickedWithIndex:)]){
////        [self.clickedDelegate clickedWithIndex:indexPath];
////    }
//}
//- (IBAction)comentButtonAction:(id)sender {
////    if([self.clickedDelegate respondsToSelector:@selector(clickedWithIndex:)]){
////        [self.clickedDelegate clickedWithIndex:indexPath];
////    }
//}

//- (IBAction)shareButtonAction:(id)sender {
//    if([self.clickedDelegate respondsToSelector:@selector(clickedShareButton:)]){
//        [self.clickedDelegate clickedShareButton:self.indexPath];
//    }
//}
@end
