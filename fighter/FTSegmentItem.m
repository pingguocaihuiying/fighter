//
//  FTSegmentItem.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTSegmentItem.h"

@implementation FTSegmentItem

- (id)initWithTitle:(NSString*)title andIcon:(NSObject*)icon
{
    self = [super init];
    if (self) {
        self.title = title;
        self.icon = icon;
        
    }
    return self;
}


- (id)initWithTitle:(NSString*)title selectImg:(NSString*)select normalImg:(NSString *)normal {

    self = [super init];
    if (self) {
        self.title = title;
        self.normalImg = normal;
        self.selectImg = select;
    }
    return self;
}

@end
