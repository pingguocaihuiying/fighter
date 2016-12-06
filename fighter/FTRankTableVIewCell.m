//
//  FTRankTableVIewCell.m
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankTableVIewCell.h"


@implementation FTRankTableVIewCell

- (void)awakeFromNib {
     [super awakeFromNib];
    // Initialization code
    self.avatarLeadingConstraint.constant = 19 *SCALE;
    self.avatarWidthConstraint.constant = 40 *SCALE;
    self.avatarHeightConstraint.constant = 40 *SCALE;
    
    self.avatarMaskWidthConstraint.constant = 41 *SCALE;
    self.avatarMaskHeightConstraint.constant = 41 *SCALE;
    
    self.loseLeadingConstraint.constant = 37 *SCALE;
    self.tieLeadingConstraint.constant = 37 *SCALE;
    self.KOLeadingConstraint.constant = 37 *SCALE;
    self.KOTrailingConstraint.constant = -14 *SCALE;
    self.NOLeadingConstraint.constant = -60 *SCALE;
    
    self.weightLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.heightLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.winLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.winTextLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.loseLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.loseTextLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.tieLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.tieTextLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.KOLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.KOTextLabel.font = [UIFont systemFontOfSize:11 *SCALE];
    self.NOLabel.font = [UIFont systemFontOfSize:14 *SCALE];
    self.rankLabel.font = [UIFont systemFontOfSize:18 *SCALE];
    
}



- (void) layoutSubviews {
    
    //    [self.titleLabel setTextColor:[UIColor colorWithHex:0xb4b4b4]];/
    [self.nameLabel setTextColor:[UIColor whiteColor]];
    [self.weightLabel setTextColor:Main_Text_Color];
    [self.heightLabel setTextColor:Main_Text_Color];
    
    [self.avatarImageView.layer setMasksToBounds:YES];
    self.avatarImageView.layer.cornerRadius = 20;
    
    [self setBackgroundColor:[UIColor clearColor]];
    
    
    //设置选中颜色
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = [UIColor colorWithHex:0x191919];
    self.selectedBackgroundView = aView;
    
}


- (void) setRankLabelText:(NSString *)text {

    
}


- (void ) drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
    CGContextSetStrokeColorWithColor(context, Cell_Space_Color.CGColor);
    CGContextStrokeRect(context, CGRectMake(69 *SCALE, rect.size.height - 0.25, rect.size.width-77, 0.25));
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
