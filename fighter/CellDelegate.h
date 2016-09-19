//
//  CellDelegate.h
//  fighter
//
//  Created by kang on 16/9/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CellDelegate <NSObject>

@optional
- (void) endEditCell;
- (void) removeSubView:(id)object;
@end
