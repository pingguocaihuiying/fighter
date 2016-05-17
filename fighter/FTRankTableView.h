//
//  FTRankTableView.h
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, FTRankTableViewStyle) {
    FTRankTableViewStyleNone = 0,   // 系统默认样式
    FTRankTableViewStyleLeft,  // 格斗种类
    FTRankTableViewStyleCenter, // 格斗重量级
    FTRankTableViewStyleRight, // 格斗赛事
   
};

typedef NS_ENUM(NSInteger, FTAnimationDirection) {
    FTAnimationDirectionToTop = 0,   // 系统默认方向
    FTAnimationDirectionToLeft,  //
    FTAnimationDirectionToToBottom, //
    FTAnimationDirectionToRight, //
    
};


@protocol FTSelectCellDelegate <NSObject>

- (void) selectedValue:(NSDictionary *)value;

@end


@interface FTRankTableView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) FTRankTableViewStyle style;
@property (nonatomic, assign) FTAnimationDirection direction;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) CGFloat tableW;//默认宽度
@property (nonatomic, assign) CGFloat tableH;//默认高度
//@property (nonatomic, assign) CGFloat originX;//默认
//@property (nonatomic, assign) CGFloat originY;//默认

@property (nonatomic, assign) CGFloat offsetX;//X轴偏移量
@property (nonatomic, assign) CGFloat offsetY;//Y轴偏移量


@property (nonatomic, weak)  id<FTSelectCellDelegate> selectDelegate;

- (instancetype)initWithButton:(UIButton*)button
                          style:(FTRankTableViewStyle) style
                        option:(void(^)(FTRankTableView* searchTableView))option;

- (void) setAnimation ;
@end
