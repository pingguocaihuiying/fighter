//
//  FTLabelView.m
//  fighter
//
//  Created by kang on 2016/12/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTLabelView.h"

@interface FTLabelView ()
{
    CGFloat w;
    CGFloat h;
    CGFloat fontSize;
    float space;
}

@property (nonatomic,copy) NSString *labelString;


@end

@implementation FTLabelView

- (id) initWithString:(NSString *)labelString {

    self = [super init];
    if (self) {
        self.labelString = labelString;
        [self initProperty];
        [self setSubview];
    }
    
    return self ;
}

- (void) initProperty {

    w=0;
    h=16;
    fontSize = 10;
    space = 8;
}

- (void) setSubview {

    CGSize labelSize = [self.labelString sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(space, (h - labelSize.height)/2 - 1, labelSize.width, labelSize.height)];
    label.text = self.labelString;
    label.font = [UIFont systemFontOfSize:fontSize];
    label.textColor = [UIColor whiteColor];
    self.frame = CGRectMake(0, 0, labelSize.width + space * 2, h);
    w = CGRectGetWidth(self.frame);
    
    //添加背景图片
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, w , h)];
    bgImageView.image = [UIImage imageNamed:@"拳种标签2"];
    
    [self addSubview:bgImageView];
    [self sendSubviewToBack:bgImageView];
    [self addSubview:label];
    
}

@end
