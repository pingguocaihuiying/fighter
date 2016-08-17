//
//  FTDynamicsDrawerViewController.h
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTUserBean.h"
#import "OpenSliderDelegate.h"

/**
 The drawer direction defines the direction that a `FTDynamicsDrawerViewController` instance's `paneView` can be opened in.
 
 The values can be masked in some (but not all) cases. See the parameters of individual methods to ensure compatibility with the `MSDynamicsDrawerDirection` that is being passed.
 */

typedef NS_OPTIONS(NSInteger, FTDynamicsDrawerDirection) {
    FTDynamicsDrawerDirectionNone       = UIRectEdgeNone,
    FTDynamicsDrawerDirectionTop        = UIRectEdgeTop,
    FTDynamicsDrawerDirectionLeft       = UIRectEdgeLeft,
    FTDynamicsDrawerDirectionBottom     = UIRectEdgeBottom,
    FTDynamicsDrawerDirectionRight      = UIRectEdgeRight,
    FTDynamicsDrawerDirectionHorizontal = (UIRectEdgeLeft | UIRectEdgeRight),
    FTDynamicsDrawerDirectionVertical   = (UIRectEdgeTop | UIRectEdgeBottom),
};

/**
 The possible drawer/pane visibility states of `FTDynamicsDrawerViewController`.
 @see paneState
 @see setPaneState:animated:allowUserInterruption:completion:
 @see setPaneState:inDirection:animated:allowUserInterruption:completion:
 */
typedef NS_ENUM(NSInteger, FTDynamicsDrawerPaneState) {
    FTDynamicsDrawerPaneStateClosed,   // Drawer view entirely hidden by pane view
    FTDynamicsDrawerPaneStateOpen,     // Drawer view revealed to open width
    FTDynamicsDrawerPaneStateOpenWide, // Drawer view entirely visible
};

typedef void (^DrawerActionBlock)(FTDynamicsDrawerDirection maskedValue);

@interface FTDynamicsDrawerViewController : UIViewController <OpenSliderDelegate>

@property (nonatomic, assign) BOOL shouldAlignStatusBarToPaneView;

@property (nonatomic, strong) UIViewController *paneViewController;
@property (nonatomic, strong) UIViewController *drawerViewController;
@property (nonatomic, assign) FTDynamicsDrawerPaneState paneState;

@property (nonatomic, strong) UIView *drawerView;
@property (nonatomic, strong) UIView *paneView;

// 设置主界面点击或者滑动弹出用户中心的响应区域宽度
@property (nonatomic, assign) NSInteger openSlideWidth;

- (void)setPaneState:(FTDynamicsDrawerPaneState)paneState animated:(BOOL)animated allowUserInterruption:(BOOL)allowUserInterruption completion:(void (^)(void))completion;

- (void)setPaneState:(FTDynamicsDrawerPaneState)paneState inDirection:(FTDynamicsDrawerDirection)direction animated:(BOOL)animated allowUserInterruption:(BOOL)allowUserInterruption completion:(void (^)(void))completion;

- (void)setPaneViewController:(UIViewController *)paneViewController animated:(BOOL)animated completion:(void (^)(void))completion;
- (void)setDrawerViewController:(UIViewController *)drawerViewController forDirection:(FTDynamicsDrawerDirection)direction;

- (CGFloat)revealWidthForDirection:(FTDynamicsDrawerDirection)direction;
- (void)addStylersFromArray:(NSArray *)stylers forDirection:(FTDynamicsDrawerDirection)direction;

@end





@protocol FTDynamicsTransDelegate <NSObject>
@optional

- (void)transitionToVC:(int)index withUrl:(BOOL )type;
- (void)changeLeftReverseButtonFunction:(int)funtype sender:(UIViewController *)uivc action:(SEL)section;
- (void)needChangeAvatarInMenu:(FTUserBean *)userdata;
- (void)transitionToPlan;

- (void) leftButtonClicked:(UIButton *) button;

- (void) addButtonToArray:(UIButton *)button;

@end

