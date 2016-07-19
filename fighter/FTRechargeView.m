//
//  FTRechargeView.m
//  fighter
//
//  Created by kang on 16/7/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRechargeView.h"

@implementation FTRechargeView

- (id) init {

    NSArray *nibContents = [[NSBundle mainBundle] loadNibNamed:@"FTRechargeView" owner:nil options:nil];
    
    // Find the view among nib contents (not too hard assuming there is only one view in it).
    self  = [nibContents lastObject];
    if (self) {
        
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        
    }
    return self;
}



- (void) initSubviews {

    NSArray *subviews = self.subviews;
    
    self.balance = [subviews objectAtIndex:3];
    
    [self.balance setText:@"0P"];
}
@end
