//
//  ConstraintTool.m
//  fighter
//
//  Created by kang on 2016/11/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "ConstraintTool.h"
#import <objc/runtime.h>

//struct  {
//    CGFloat x;
//    CGFloat y;
//};
@implementation ConstraintTool

//+ (void) AddConstraintTLBR:(CG) toItem:(UIView *)item {
// 
//    CGPoint
//}
//
//+ (void) addTopConstraint:(NSInteger) offset  item:(UIView *)item toItem:(UIView *) toItem {
//    
//    item.translatesAutoresizingMaskIntoConstraints = NO;
//    [item.constraints]
//}


static char KxqExistedConstraintsKey;

- (NSMutableSet *) existedConstraints {
    
    NSMutableSet *constraints = objc_getAssociatedObject(self, &KxqExistedConstraintsKey);
    if (!constraints) {
        constraints = [NSMutableSet set];
        objc_setAssociatedObject(self, &KxqExistedConstraintsKey, constraints, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return constraints;
}

@end
