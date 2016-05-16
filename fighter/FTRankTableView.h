//
//  FTRankTableView.h
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, FTRankTableViewType) {
    FTRankTableViewTypeNone = 0,   // 系统默认样式
    FTRankTableViewTypeKind,  // 格斗种类
    FTRankTableViewTypeLevel, // 格斗重量级
    FTRankTableViewTypeMatch, // 格斗赛事
   
};

typedef NS_ENUM(NSInteger, FTAnimationDirection) {
    FTAnimationDirectionToTop = 0,   // 系统默认方向
    FTAnimationDirectionToLeft,  //
    FTAnimationDirectionToToBottom, //
    FTAnimationDirectionToRight, //
    
};

@interface FTRankTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) FTRankTableViewType type;
@property (nonatomic, assign) FTAnimationDirection direction;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) CGFloat tableW;//默认宽度
//@property (nonatomic, assign) CGFloat originX;//默认
//@property (nonatomic, assign) CGFloat originY;//默认

@property (nonatomic, assign) CGFloat offsetX;//X轴偏移量
@property (nonatomic, assign) CGFloat offsetY;//Y轴偏移量




- (instancetype)initWithButton:(UIButton*)button
                          type:(FTRankTableViewType) type
                        option:(void(^)(FTRankTableView* searchTableView))option;

- (void) setAnimation ;
@end
