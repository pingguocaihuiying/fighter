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

    // Configure the view for the selected state
}


//- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    NSLog(@"touches");
//    
//    if (touches.count > 1) {
//        return;
//    }
//    
//    UITouch *touch = [touches.allObjects objectAtIndex:0];
//    CGPoint point = [touch locationInView:self];
//    for (int i = 0; i< 5; i++) {
//        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
//        if (CGRectContainsPoint(imageView.frame, point) ) {
//            [self setImageToIndex:i];
//            break;
//        }
//    }
//}


- (void) setImageToIndex:(int) index {
    
    NSLog(@"index=%i",index);
    
    for (int i = index; i >= 0 ; i--) {
        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-红"]];
    }
    for (int i = index+1; i < 5 ; i++) {
        UIImageView *imageView = [self.imagesViews objectAtIndex:i];
        [imageView setImage:[UIImage imageNamed:@"火苗-灰"]];
    }
}


- (void) pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event {
    
    NSLog(@"press");
    
    if (presses.count > 1) {
        return;
    }
    
    UIPress *press = [presses.allObjects objectAtIndex:0];
    CGFloat time = press.timestamp;
    if (time >= 2) {
        NSLog(@"long press gesture:%f",time);
        return ;
    }
    
    
    [super pressesBegan:presses withEvent:event];
}


@end
