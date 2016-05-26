//
//  TFBoxerHeaderView.m
//  fighter
//
//  Created by kang on 16/5/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBoxerHeaderView.h"

@implementation FTBoxerHeaderView

+ (FTBoxerHeaderView *) headerView {

    NSArray *views =  [[NSBundle mainBundle] loadNibNamed:@"BoxerCenterHeader" owner:nil options:nil];
    
    FTBoxerHeaderView *view = (FTBoxerHeaderView*)[[[views objectAtIndex:0] subviews] objectAtIndex:0];
    
    return view;
}

@end
