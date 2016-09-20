//
//  FTGymLevelCell.m
//  fighter
//
//  Created by kang on 16/9/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymLevelCell.h"

@implementation FTGymLevelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.imagesViews = @[
                         _levelImage1,
                         _levelImage2,
                         _levelImage3,
                         _levelImage4,
                         _levelImage5,
                         ];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
//    NSLog(@"touches");
    
    if (touches.count > 1) {
        return;
    }
    
    UITouch *touch = [touches.allObjects objectAtIndex:0];
    CGPoint point = [touch locationInView:self];
    for (int i = 0; i< 5; i++) {
        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
        if (CGRectContainsPoint(imageView.frame, point) ) {
            [self setImageToIndex:i];
            break;
        }
    }
}


- (void) setImageToIndex:(int) index {
    
//    NSLog(@"index=%i",index);
    
    for (int i = index; i >= 0 ; i--) {
        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-红"]];
    }
    for (int i = index+1; i < 5 ; i++) {
        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-灰"]];
    }
}




@end
