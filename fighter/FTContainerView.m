//
//  FTContainerView.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTContainerView.h"

@implementation FTContainerView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imagesViews = @[
                         _levelImage1,
                         _levelImage2,
                         _levelImage3,
                         _levelImage4,
                         _levelImage5,
                         ];
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
