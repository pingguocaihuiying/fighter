//
//  CellDelegate.h
//  fighter
//
//  Created by kang on 16/9/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FTMediaType) {
    FTMediaTypeImage,
    FTMediaTypeVedio,
};

typedef NS_ENUM(NSInteger, GymCommentState) {
    GymCommentStateComfort,
    GymCommentStateStrength,
    GymCommentStateTeachLevel,
};

typedef void(^RefreshBlock)();

@protocol CellDelegate <NSObject>

@optional
- (void) endEditCell;
- (void) removeSubView:(id)object;
- (void) gymLevel:(NSInteger)level index:(NSInteger)index;
- (void) gymComment:(NSString *)comment;

- (void) pushViewController:(UIViewController *) viewController;
- (void) pressentViewController:(UIViewController *) viewController;

- (RefreshBlock) getRefreshBlock;

@end
