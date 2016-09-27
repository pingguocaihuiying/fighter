//
//  FTGymOrderCourseView.m
//  fighter
//
//  Created by 李懿哲 on 26/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymOrderCourseView.h"

@interface FTGymOrderCourseView ()
{
    
    BOOL changeState;
    
}

@end
@implementation FTGymOrderCourseView

-(void) awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
    self.opaque = NO;
    
    changeState = NO;
    self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, 112, 0, 0);
    self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, -112, 0, 112);
    
}


- (IBAction)segmentedButtonAction:(id)sender {
    
    changeState = !changeState;
    
    if (changeState) {
        
        [self.segmentedButton setTitle:@"不可预约" forState:UIControlStateNormal];
        [self.segmentedButton setTitleColor:Main_Text_Color forState:UIControlStateNormal];
        [self.segmentedButton setBackgroundImage:[UIImage imageNamed:@"切换状态-灰bg"] forState:UIControlStateNormal];
        
        self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 30);
        self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }else {
        
        [self.segmentedButton setTitle:@"可预约" forState:UIControlStateNormal];
        [self.segmentedButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self.segmentedButton setBackgroundImage:[UIImage imageNamed:@"切换状态-红bg"] forState:UIControlStateNormal];
        
        self.segmentedButton.imageEdgeInsets = UIEdgeInsetsMake(0, 112, 0, 0);
        self.segmentedButton.titleEdgeInsets = UIEdgeInsetsMake(0, -112, 0, 112);
    }
    
    
}

@end
