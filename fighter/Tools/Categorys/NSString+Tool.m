//
//  NSString+Tool.m
//  fighter
//
//  Created by kang on 2016/10/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSString+Tool.h"

@implementation NSString (Tool)

- (NSString *) removeString:(NSString *)willRemoveString {
 
    NSMutableString *string = [NSMutableString self];
    
    NSRange range = [self rangeOfString:willRemoveString];
    if (range.location != NSNotFound) {
        [string deleteCharactersInRange:range];
    }
    
    return string;
}
@end
