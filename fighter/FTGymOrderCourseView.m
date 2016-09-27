//
//  FTGymOrderCourseView.m
//  fighter
//
//  Created by 李懿哲 on 26/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymOrderCourseView.h"


@interface FTGymOrderCourseView()
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel1;
@property (strong, nonatomic) IBOutlet UIButton *button1;
@property (strong, nonatomic) IBOutlet UIButton *button2;


@end

@implementation FTGymOrderCourseView

- (void)awakeFromNib{
    [super awakeFromNib];
    _seperatorView1.backgroundColor = Cell_Space_Color;
}


@end
