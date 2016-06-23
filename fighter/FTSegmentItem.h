//
//  FTSegmentItem.h
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTSegmentItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSObject *icon;
@property (nonatomic, strong) NSString *normalImg;
@property (nonatomic, strong) NSString *selectImg;

- (id)initWithTitle:(NSString*)title andIcon:(NSObject*)icon;

- (id)initWithTitle:(NSString*)title selectImg:(NSString*)select normalImg:(NSString *)normal;

@end
