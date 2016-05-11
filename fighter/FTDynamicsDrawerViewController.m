//
//  FTDynamicsDrawerViewController.m
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDynamicsDrawerViewController.h"
#import "FTDrawerStyler.h"

//defin一些常量
#define LeftMenuDefaultOpenStateRevealWidthHorizontal [UIScreen mainScreen].bounds.size.width *0.7 ////267.0;
#define LeftMenuDefaultOpenStateRevealWidthVertical 300

const CGFloat LeftMenuOpenAnimationOvershot = 30.0;
const CGFloat PaneViewVelocityThreshold = 5.0;
const CGFloat PaneViewVelocityMultiplier = 5.0;

NSString * const LeftMenuBoundaryIdentifier = @"LeftMenuBoundaryIdentifier";

static BOOL LeftMenuDirectionIsNonMasked(FTDynamicsDrawerDirection drawerDirection)
{
    
    switch (drawerDirection) {
        case FTDynamicsDrawerDirectionNone:
        case FTDynamicsDrawerDirectionTop:
        case FTDynamicsDrawerDirectionLeft:
        case FTDynamicsDrawerDirectionBottom:
        case FTDynamicsDrawerDirectionRight:
            return YES;
        default:
            return NO;
    }
}

static BOOL LeftMenuDirectionIsCardinal(FTDynamicsDrawerDirection drawerDirection)
{
    switch (drawerDirection) {
        case FTDynamicsDrawerDirectionTop:
        case FTDynamicsDrawerDirectionLeft:
        case FTDynamicsDrawerDirectionBottom:
        case FTDynamicsDrawerDirectionRight:
            return YES;
        default:
            return NO;
    }
}

static BOOL LeftMenuDirectionIsValid(FTDynamicsDrawerDirection drawerDirection)
{
    
    switch (drawerDirection) {
        case FTDynamicsDrawerDirectionNone:
        case FTDynamicsDrawerDirectionTop:
        case FTDynamicsDrawerDirectionLeft:
        case FTDynamicsDrawerDirectionBottom:
        case FTDynamicsDrawerDirectionRight:
        case FTDynamicsDrawerDirectionHorizontal:
        case FTDynamicsDrawerDirectionVertical:
            return YES;
        default:
            return NO;
    }
}

void LeftMenuDirectionActionForMaskedValues(FTDynamicsDrawerDirection direction, DrawerActionBlock action)
{
    for (FTDynamicsDrawerDirection currentDirection = FTDynamicsDrawerDirectionTop; currentDirection <= FTDynamicsDrawerDirectionRight; currentDirection <<= 1) {
        if (currentDirection & direction) {
            action(currentDirection);
        }
    }
}


#pragma mark - UIView Extend
typedef void (^ViewActionBlock)(UIView *view);
@interface UIView (ViewHierarchyAction)
- (void)superviewHierarchyAction:(ViewActionBlock)viewAction;
@end
@implementation UIView (ViewHierarchyAction)
- (void)superviewHierarchyAction:(ViewActionBlock)viewAction
{
    viewAction(self);
    [self.superview superviewHierarchyAction:viewAction];
}
@end



#pragma mark - FTDynamicsDrawerViewController Extend
@interface FTDynamicsDrawerViewController () <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>
{
    FTDynamicsDrawerDirection _currentLeftMenuDirection;
    FTDynamicsDrawerDirection _possibleLeftMenuDirection;
    
    UIViewController *_drawerViewController;//左侧的菜单栏controller
    UIViewController *_paneViewController;//装载主页面的容器controller
    FTDynamicsDrawerPaneState _paneState;
}

@property (nonatomic, assign) BOOL paneViewSlideOffAnimationEnabled;

@property (nonatomic, copy) void (^dynamicAnimatorCompletion)(void);

@property (nonatomic, assign) BOOL animatingRotation;
@property (nonatomic, assign) FTDynamicsDrawerDirection currentLeftMenuDirection;
@property (nonatomic, assign) FTDynamicsDrawerDirection possibleLeftMenuDirection;
// Gestures
@property (nonatomic, strong) NSMutableSet *touchForwardingClasses;
@property (nonatomic, strong) UIPanGestureRecognizer *panePanGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *paneTapGestureRecognizer;

// Internal Properties
@property (nonatomic, strong) NSMutableDictionary *drawerViewControllers;
@property (nonatomic, strong) NSMutableDictionary *revealWidth;

@property (nonatomic, strong) NSMutableDictionary *paneDragRevealEnabled;
@property (nonatomic, strong) NSMutableDictionary *paneTapToCloseEnabled;
@property (nonatomic, strong) NSMutableDictionary *stylers;

// Dyanimcs
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIPushBehavior *panePushBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *paneElasticityBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *bounceElasticityBehavior;
@property (nonatomic, strong) UIGravityBehavior *paneGravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *paneBoundaryCollisionBehavior;

@property (nonatomic, assign) CGFloat gravityMagnitude;
@property (nonatomic, assign) CGFloat elasticity;
@property (nonatomic, assign) CGFloat bounceElasticity;
@property (nonatomic, assign) CGFloat bounceMagnitude;


@end


@implementation FTDynamicsDrawerViewController
@dynamic paneViewController ;
@dynamic paneState;

#pragma mark - NSObject
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialize];
    }
    return self;
}

- (void)dealloc
{
    [self.paneView removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - UIViewController
//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self initialize];
//    }
//    return self;
//}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    _paneState = FTDynamicsDrawerPaneStateClosed;
    _currentLeftMenuDirection = FTDynamicsDrawerDirectionNone;
    
    self.paneViewSlideOffAnimationEnabled = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    self.shouldAlignStatusBarToPaneView = NO;
    
    self.drawerViewControllers = [NSMutableDictionary new];
    self.revealWidth = [NSMutableDictionary new];
    self.paneDragRevealEnabled = [NSMutableDictionary new];
    self.paneTapToCloseEnabled = [NSMutableDictionary new];
    self.stylers = [NSMutableDictionary new];
    
    self.touchForwardingClasses = [NSMutableSet setWithArray:@[[UISlider class], [UISwitch class]]];
    
    self.drawerView = [UIView new];
    self.drawerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    NSLog(@"drawerView.size:%f",self.drawerView.bounds.size.width);
    NSLog(@"drawerView.size:%f",self.drawerView.bounds.size.height);
    self.paneView = [UIView new];
    self.paneView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    NSLog(@"paneView.size:%f",self.paneView.bounds.size.width);
    NSLog(@"paneView.size:%f",self.paneView.bounds.size.height);
    
    self.panePanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panePanned:)];
    self.panePanGestureRecognizer.minimumNumberOfTouches = 1;
    self.panePanGestureRecognizer.maximumNumberOfTouches = 1;
    self.panePanGestureRecognizer.delegate = self;
    [self.paneView addGestureRecognizer:self.panePanGestureRecognizer];
    
    self.paneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(paneTapped:)];
    self.paneTapGestureRecognizer.numberOfTouchesRequired = 1;
    self.paneTapGestureRecognizer.numberOfTapsRequired = 1;
    self.paneTapGestureRecognizer.delegate = self;
    [self.paneView addGestureRecognizer:self.paneTapGestureRecognizer];
    
    self.gravityMagnitude = 8;  //重力系数
    self.elasticity = 0.0;      //弹性系数
    self.bounceElasticity = 0.1;
    self.bounceMagnitude = 50.0;
    
#if defined(DEBUG_DYNAMICS)
    self.gravityMagnitude = 0.05;
#endif
    
#if defined(DEBUG_LAYOUT)
    self.drawerView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
    self.drawerView.layer.borderColor = [[UIColor redColor] CGColor];
    self.drawerView.layer.borderWidth = 2.0;
    self.paneView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    self.paneView.layer.borderColor = [[UIColor greenColor] CGColor];
    self.paneView.layer.borderWidth = 2.0;
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.drawerView];
    [self.view addSubview:self.paneView];
    
    self.drawerView.frame = (CGRect){CGPointZero, self.view.frame.size};
    self.paneView.frame = (CGRect){CGPointZero, self.view.frame.size};
    
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [self.paneView addObserver:self forKeyPath:@"frame" options:0 context:NULL];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.dynamicAnimator.delegate = self;
    self.paneBoundaryCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.paneView]];
    self.paneGravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.paneView]];
    self.panePushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.paneView] mode:UIPushBehaviorModeInstantaneous];
    self.paneElasticityBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.paneView]];
    
    __weak typeof(self) weakSelf = self;
    self.paneGravityBehavior.action = ^{
        [weakSelf paneViewDidUpdateFrame];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义setter 和 getter 方法
- (FTDynamicsDrawerPaneState)paneState
{
    return _paneState;
}

- (void)setPaneState:(FTDynamicsDrawerPaneState)newPaneState
{
    [self setPaneState:newPaneState animated:NO allowUserInterruption:NO completion:nil];
    
}


- (FTDynamicsDrawerDirection)currentLeftMenuDirection
{
    return _currentLeftMenuDirection;
}

- (void)setCurrentLeftMenuDirection:(FTDynamicsDrawerDirection)currentLeftMenuDirection
{
    NSAssert(LeftMenuDirectionIsNonMasked(currentLeftMenuDirection), @"Only accepts non-masked directions as current reveal direction");
    
    if (_currentLeftMenuDirection == currentLeftMenuDirection) return;
    _currentLeftMenuDirection = currentLeftMenuDirection;
    
    self.drawerViewController = self.drawerViewControllers[@(currentLeftMenuDirection)];
    
    // Reset the drawer view's transform when the reveal direction is changed
    self.drawerView.transform = CGAffineTransformIdentity;
    
    // Disable pane view interaction when not closed
    [self setPaneViewControllerViewUserInteractionEnabled:(currentLeftMenuDirection == FTDynamicsDrawerDirectionNone)];
    
    [self updateStylers];
}

- (void)setPaneState:(FTDynamicsDrawerPaneState)paneState inDirection:(FTDynamicsDrawerDirection)direction
{
    [self setPaneState:paneState inDirection:direction animated:NO allowUserInterruption:NO completion:nil];
}


#pragma mark - paneViweController
- (UIViewController *)paneViewController
{
    return _paneViewController;
}

- (void)setPaneViewController:(UIViewController *)newPaneViewController
{
    
    [self replaceViewController:self.paneViewController
             withViewController:newPaneViewController
                inContainerView:self.paneView
                     completion:^{
                         _paneViewController = newPaneViewController;
                         if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                         {
                             [self setNeedsStatusBarAppearanceUpdate];
                         }
                     }];
}

- (void)setPaneState:(FTDynamicsDrawerPaneState)paneState animated:(BOOL)animated allowUserInterruption:(BOOL)allowUserInterruption completion:(void (^)(void))completion; {
    
    if ((paneState != FTDynamicsDrawerPaneStateClosed) && (self.currentLeftMenuDirection == FTDynamicsDrawerDirectionNone)) {
        NSAssert(LeftMenuDirectionIsCardinal(self.possibleLeftMenuDirection), @"Unable to set pane to an open state with multiple possible reveal directions");
        [self setPaneState:paneState inDirection:self.possibleLeftMenuDirection animated:animated allowUserInterruption:allowUserInterruption completion:completion];
    } else {
        [self setPaneState:paneState inDirection:self.possibleLeftMenuDirection animated:animated allowUserInterruption:allowUserInterruption completion:completion];
    }
}

//设置paneViewcontroller
- (void)setPaneViewController:(UIViewController *)paneViewController animated:(BOOL)animated completion:(void (^)(void))completion;
{
    NSParameterAssert(paneViewController);
    if (!animated) {
        self.paneViewController = paneViewController;
        if (completion) completion();
        return;
    }
    //如果跳转的controller不是当前需要显示的，则跳转
    if (self.paneViewController != paneViewController) {
        [self.paneViewController willMoveToParentViewController:nil];
        [self.paneViewController beginAppearanceTransition:NO animated:animated];
        
        void(^transitionToNewPaneViewController)() = ^{
            [paneViewController willMoveToParentViewController:self];
            [self.paneViewController.view removeFromSuperview];
            [self.paneViewController removeFromParentViewController];
            [self.paneViewController didMoveToParentViewController:nil];
            [self.paneViewController endAppearanceTransition];
            [self addChildViewController:paneViewController];
            paneViewController.view.frame = (CGRect){CGPointZero, self.paneView.frame.size};
            [paneViewController beginAppearanceTransition:YES animated:animated];
            [self.paneView addSubview:paneViewController.view];
            _paneViewController = paneViewController;
            // Force redraw of the new pane view (drastically smoothes animation)
            [self.paneView setNeedsDisplay];
            [CATransaction flush];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
            {
                [self setNeedsStatusBarAppearanceUpdate];
            }
            // After drawing has finished, add new pane view controller view and close
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                _paneViewController = paneViewController;
                [self setPaneState:FTDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:YES completion:^{
                    [paneViewController didMoveToParentViewController:weakSelf];
                    [paneViewController endAppearanceTransition];
                    if (completion) completion();
                }];
            });
        };
        if (self.paneViewSlideOffAnimationEnabled) {
            [self setPaneState:FTDynamicsDrawerPaneStateOpenWide animated:animated allowUserInterruption:NO completion:transitionToNewPaneViewController];
        } else {
            transitionToNewPaneViewController();
        }
    }
    // If trying to set to the currently visible pane view controller, just close
    else {//如果跳转的controller正是当前显示的，则不跳转
        [self setPaneState:FTDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:NO completion:^{
            if (completion) completion();
        }];
    }
}

- (void)setPaneState:(FTDynamicsDrawerPaneState)paneState
         inDirection:(FTDynamicsDrawerDirection)direction
            animated:(BOOL)animated
allowUserInterruption:(BOOL)allowUserInterruption
          completion:(void (^)(void))completion;
{
    NSAssert(((self.possibleLeftMenuDirection & direction) == direction), @"Unable to bounce open with impossible or multiple directions");
    NSLog(@"setPaneState   self.possibleLeftMenuDirection = %ld",(long)self.possibleLeftMenuDirection);
    
    //    __block typeof(self.paneState) PaneState = self.paneState;
    void(^internalCompletion)() = ^ {
        //        PaneState = paneState;
        _paneState = paneState;
        if (completion != nil) completion();
    };
    
    self.currentLeftMenuDirection = direction;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
        if (animated) {
            [self addDynamicsBehaviorsToCreatePaneState:paneState];
            
            if (!allowUserInterruption)
            {
                [self setViewUserInteractionEnabled:NO];
            }
            __weak typeof(self) weakSelf = self;
            self.dynamicAnimatorCompletion = ^{
                if (!allowUserInterruption) [weakSelf setViewUserInteractionEnabled:YES];
                internalCompletion();
            };
        } else {
            self.paneView.frame = (CGRect){[self paneViewOriginForPaneState:paneState], self.paneView.frame.size};
            internalCompletion();
        }
    }else{
        [UIView animateWithDuration:0.6f animations:^{
            if (!allowUserInterruption) [self setViewUserInteractionEnabled:NO];
            self.paneView.frame = (CGRect){[self paneViewOriginForPaneState:paneState], self.paneView.frame.size};
        } completion:^(BOOL finished) {
            if(finished){
                __weak typeof(self) weakSelf = self;
                if (!allowUserInterruption) [weakSelf setViewUserInteractionEnabled:YES];
                if(paneState == FTDynamicsDrawerPaneStateClosed){
                    self.currentLeftMenuDirection = 0;
                }
                internalCompletion();
            }
        }];
    }
}

- (CGPoint)paneViewOriginForPaneState:(FTDynamicsDrawerPaneState)paneState
{
    CGPoint paneViewOrigin = CGPointZero;
    switch (paneState) {
        case FTDynamicsDrawerPaneStateOpen:
            switch (self.currentLeftMenuDirection) {
                case FTDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = self.openStateRevealWidth;
                    break;
                case FTDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = self.openStateRevealWidth;
                    break;
                case FTDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = -self.openStateRevealWidth;
                    break;
                case FTDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = -self.openStateRevealWidth;
                    break;
                default:
                    break;
            }
            break;
        case FTDynamicsDrawerPaneStateOpenWide:
            switch (self.currentLeftMenuDirection) {
                case FTDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = CGRectGetWidth(self.view.frame);
                    break;
                case FTDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = CGRectGetHeight(self.view.frame);
                    break;
                case FTDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = 0.0;
                    break;
                case FTDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = 0.0;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return paneViewOrigin;
}


#pragma mark Pane State
- (void)paneViewDidUpdateFrame
{
    if (self.shouldAlignStatusBarToPaneView) {
        NSString *key = [[NSString alloc] initWithData:[NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72}
                                                                      length:9]
                                              encoding:NSASCIIStringEncoding];
        id object = [UIApplication sharedApplication];
        UIView *statusBar;
        if ([object respondsToSelector:NSSelectorFromString(key)]) {
            statusBar = [object valueForKey:key];
        }
        statusBar.transform = CGAffineTransformMakeTranslation(self.paneView.frame.origin.x, self.paneView.frame.origin.y);
    }
    
    [self updateStylers];
}

#pragma mark Closed Fraction
- (CGFloat)paneViewClosedFraction
{
    CGFloat fraction = 0;
    switch (self.currentLeftMenuDirection) {
        case FTDynamicsDrawerDirectionTop:
            fraction = ((self.openStateRevealWidth - self.paneView.frame.origin.y) / self.openStateRevealWidth);
            break;
        case FTDynamicsDrawerDirectionLeft:
            fraction = ((self.openStateRevealWidth - self.paneView.frame.origin.x) / self.openStateRevealWidth);
            break;
        case FTDynamicsDrawerDirectionBottom:
            fraction = (1.0 - (fabs(self.paneView.frame.origin.y) / self.openStateRevealWidth));
            break;
        case FTDynamicsDrawerDirectionRight:
            fraction = (1.0 - (fabs(self.paneView.frame.origin.x) / self.openStateRevealWidth));
            break;
        default:
            break;
    }
    // Clip to 0.0 < fraction < 1.0
    fraction = (fraction < 0.0) ? 0.0 : fraction;
    fraction = (fraction > 1.0) ? 1.0 : fraction;
    return fraction;
}


#pragma mark - drawerViweController
- (UIViewController *)drawerViewController
{
    return _drawerViewController;
}

- (void)setDrawerViewController:(UIViewController *)drawerViewController
{
    [self replaceViewController:self.drawerViewController withViewController:drawerViewController inContainerView:self.drawerView completion:^{
        _drawerViewController = drawerViewController;
    }];
}

- (void)setDrawerViewController:(UIViewController *)drawerViewController forDirection:(FTDynamicsDrawerDirection)direction
{
    NSAssert(LeftMenuDirectionIsCardinal(direction), @"Only accepts cardinal reveal directions");
    for (UIViewController *currentDrawerViewController in self.drawerViewControllers) {
        NSAssert(currentDrawerViewController != drawerViewController, @"Unable to add a drawer view controller when it's previously been added");
    }
    switch (direction) {
        case FTDynamicsDrawerDirectionLeft:
        {
            NSLog(@"leftdirection = %ld",(long)direction);
        }
            
        case FTDynamicsDrawerDirectionRight:
        {
            NSAssert(!(self.drawerViewControllers[@(FTDynamicsDrawerDirectionTop)] || self.drawerViewControllers[@(FTDynamicsDrawerDirectionBottom)]), @"Unable to simultaneously have top/bottom drawer view controllers while setting left/right drawer view controllers");
            break;
        }
        case FTDynamicsDrawerDirectionTop:{}
        case FTDynamicsDrawerDirectionBottom:
        {
            NSAssert(!(self.drawerViewControllers[@(FTDynamicsDrawerDirectionLeft)] || self.drawerViewControllers[@(FTDynamicsDrawerDirectionRight)]), @"Unable to simultaneously have left/right drawer view controllers while setting top/bottom drawer view controllers");
            break;
        }
        default:
            break;
    }
    UIViewController *existingDrawerViewController = self.drawerViewControllers[@(direction)];
    // New drawer view controller
    if (drawerViewController && (existingDrawerViewController == nil)) {
        self.possibleLeftMenuDirection |= direction;
        self.drawerViewControllers[@(direction)] = drawerViewController;
    }
    // Removing existing drawer view controller
    else if (!drawerViewController && (existingDrawerViewController != nil)) {
        self.possibleLeftMenuDirection ^= direction;
        [self.drawerViewControllers removeObjectForKey:@(direction)];
    }
    // Replace existing drawer view controller
    else if (drawerViewController && existingDrawerViewController) {
        self.drawerViewControllers[@(direction)] = drawerViewController;
    }
}


#pragma mark Possible Reveal Direction

- (FTDynamicsDrawerDirection)possibleLeftMenuDirection
{
    return _possibleLeftMenuDirection;
}

- (void)setPossibleLeftMenuDirection:(FTDynamicsDrawerDirection)possibleLeftMenuDirection
{
    NSAssert(LeftMenuDirectionIsValid(possibleLeftMenuDirection), @"Only accepts valid reveal directions as possible reveal direction");
    _possibleLeftMenuDirection = possibleLeftMenuDirection;
}



#pragma mark - Generic View Controller Containment
- (void)replaceViewController:(UIViewController *)existingViewController withViewController:(UIViewController *)newViewController inContainerView:(UIView *)containerView completion:(void (^)(void))completion
{
    // Add initial view controller
    if (!existingViewController && newViewController) {
        [newViewController willMoveToParentViewController:self];
        [newViewController beginAppearanceTransition:YES animated:NO];
        [self addChildViewController:newViewController];
        
        newViewController.view.frame = (CGRect){CGPointZero, containerView.frame.size};
        [containerView addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        [newViewController endAppearanceTransition];
        if (completion) completion();
    }
    // Remove existing view controller
    else if (existingViewController && !newViewController) {
        [existingViewController willMoveToParentViewController:nil];
        [existingViewController beginAppearanceTransition:NO animated:NO];
        [existingViewController.view removeFromSuperview];
        [existingViewController removeFromParentViewController];
        [existingViewController didMoveToParentViewController:nil];
        [existingViewController endAppearanceTransition];
        if (completion) completion();
    }
    // Replace existing view controller with new view controller
    else if ((existingViewController != newViewController) && newViewController) {
        [newViewController willMoveToParentViewController:self];
        [existingViewController willMoveToParentViewController:nil];
        [existingViewController beginAppearanceTransition:NO animated:NO];
        [existingViewController.view removeFromSuperview];
        [existingViewController removeFromParentViewController];
        [existingViewController didMoveToParentViewController:nil];
        [existingViewController endAppearanceTransition];
        [newViewController beginAppearanceTransition:YES animated:NO];
        newViewController.view.frame = (CGRect){CGPointZero, containerView.frame.size};
        [self addChildViewController:newViewController];
        [containerView addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        [newViewController endAppearanceTransition];
        if (completion) completion();
    }
}


#pragma mark - 设置展示相关属性
- (CGFloat)openStateRevealWidth
{
    return [self revealWidthForDirection:self.currentLeftMenuDirection];
}
- (CGFloat)revealWidthForDirection:(FTDynamicsDrawerDirection)direction
{
    NSAssert(LeftMenuDirectionIsValid(direction), @"Only accepts cardinal directions when querying for reveal width");
    NSNumber *revealWidth = self.revealWidth[@(direction)];
    // Default values
    if (!revealWidth) {
        if (direction & FTDynamicsDrawerDirectionHorizontal) {
            revealWidth = @(SCREEN_WIDTH *0.7);
        } else if (direction & FTDynamicsDrawerDirectionVertical) {
            revealWidth = @(LeftMenuDefaultOpenStateRevealWidthVertical);
        } else {
            revealWidth = @0;
        }
    }
    return [revealWidth floatValue];
}

- (void)setRevealWidth:(CGFloat)revealWidth forDirection:(FTDynamicsDrawerDirection)direction
{
    NSAssert((self.paneState == FTDynamicsDrawerPaneStateClosed), @"Only able to update the reveal width while the pane view is closed");
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection maskedValue){
        self.revealWidth[@(maskedValue)] = @(revealWidth);
    });
}

#pragma mark - User Interaction
- (void)setViewUserInteractionEnabled:(BOOL)enabled
{
    static NSInteger disableCount;
    if (!enabled) {
        disableCount++;
    } else {
        disableCount = MAX((disableCount - 1), 0);
    }
    self.view.userInteractionEnabled = (disableCount == 0);
}

- (void)setPaneViewControllerViewUserInteractionEnabled:(BOOL)enabled
{
    self.paneViewController.view.userInteractionEnabled = enabled;
}

#pragma mark - Stylers
- (void)addStyler:(id <FTDrawerStyler>)styler forDirection:(FTDynamicsDrawerDirection)direction;
{
    __weak typeof(self) weakSel = self;
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection tempDirection){
        __strong typeof(self) strongSel = weakSel;
        // Lazy creation of stylers sets
        if (!strongSel.stylers[@(tempDirection)]) {
            strongSel.stylers[@(tempDirection)] = [NSMutableSet new];
        }
        NSMutableSet *stylersSet = strongSel.stylers[@(tempDirection)];
        [stylersSet addObject:styler];
        BOOL existsInCurrentStylers = NO;
        for (NSSet *currentStylersSet in [strongSel.stylers allValues]) {
            if ([currentStylersSet containsObject:styler]) {
                existsInCurrentStylers = YES;
            }
        }
        if (existsInCurrentStylers && [styler respondsToSelector:@selector(stylerWasAddedToDynamicsDrawerViewController:)]) {
            [styler stylerWasAddedToDynamicsDrawerViewController:strongSel];
        }
    });
    
    [self updateStylers];
}

- (void)removeStyler:(id <FTDrawerStyler>)styler forDirection:(FTDynamicsDrawerDirection)direction;
{
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection maskedValue){
        NSMutableSet *stylersSet = self.stylers[@(maskedValue)];
        [stylersSet removeObject:styler];
        NSInteger containedCount = 0;
        for (NSSet *currentStylersSet in [self.stylers allValues]) {
            if ([currentStylersSet containsObject:styler]) {
                containedCount++;
            }
        }
        if ((containedCount == 0) && [styler respondsToSelector:@selector(stylerWasRemovedFromDynamicsDrawerViewController:)]) {
            [styler stylerWasRemovedFromDynamicsDrawerViewController:self];
        }
    });
    [self updateStylers];
}

- (void)addStylersFromArray:(NSArray *)stylers forDirection:(FTDynamicsDrawerDirection)direction;
{
    for (id <FTDrawerStyler> styler in stylers) {
        [self addStyler:styler forDirection:direction];
    }
}

- (void)updateStylers
{
    // Prevent weird animation issues on rotation
    if (self.animatingRotation) {
        return;
    }
    NSMutableSet *activeStylers = [NSMutableSet new];
    if (LeftMenuDirectionIsCardinal(self.currentLeftMenuDirection)) {
        [activeStylers unionSet:self.stylers[@(self.currentLeftMenuDirection)]];
    } else {
        for (NSSet *stylers in [self.stylers allValues]) {
            [activeStylers unionSet:stylers];
        }
    }
    
    for (id <FTDrawerStyler> styler in activeStylers) {
        
        if ([styler respondsToSelector:@selector(dynamicsDrawerViewController:didUpdatePaneClosedFraction:forDirection:)]) {
            [styler dynamicsDrawerViewController:self
                     didUpdatePaneClosedFraction:[self paneViewClosedFraction]
                                    forDirection:self.currentLeftMenuDirection];
            
            NSLog(@"styler did");
        }
//        [styler dynamicsDrawerViewController:self
//                 didUpdatePaneClosedFraction:[self paneViewClosedFraction]
//                                forDirection:self.currentLeftMenuDirection];
    }
}

- (NSArray *)stylersForDirection:(FTDynamicsDrawerDirection)direction;
{
    NSMutableSet *stlyerCollection = [NSMutableSet new];
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection maskedValue){
        [stlyerCollection unionSet:self.stylers[@(maskedValue)]];
    });
    return [stlyerCollection allObjects];
}

#pragma mark - event responses
- (void)paneTapped:(UIPanGestureRecognizer *)gestureRecognizer
{
    
    @try {
        NSLog(@"paneTapped self.currentLeftMenuDirection = %ld ",(long)self.currentLeftMenuDirection);
        NSAssert(LeftMenuDirectionIsCardinal(self.currentLeftMenuDirection), @"Invalid state, must be opened to close");
        NSLog(@"bool = %d ",[self paneTapToCloseEnabledForDirection:self.currentLeftMenuDirection]?YES:NO);
        if ([self paneTapToCloseEnabledForDirection:self.currentLeftMenuDirection]) {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
                [self addDynamicsBehaviorsToCreatePaneState:FTDynamicsDrawerPaneStateClosed];
            }else{
                if (self.currentLeftMenuDirection == FTDynamicsDrawerDirectionNone) {
                    return;
                }
                [UIView animateWithDuration:0.6f animations:^{
                    self.paneView.frame = CGRectMake(0,  self.paneView.frame.origin.y,  self.paneView.frame.size.width,  self.paneView.frame.size.height);
                } completion:^(BOOL finished) {
                    if(finished){
                        [self setPaneViewControllerViewUserInteractionEnabled:YES];
                        self.currentLeftMenuDirection = 0;
                        _paneState = FTDynamicsDrawerPaneStateClosed;
                    }
                }];
            }
        }
        
    }
    @catch(NSException *exception) {
        NSLog(@"paneTapped exception:%@", exception);
    }
    @finally {
        
    }
    
}

- (void)panePanned:(UIPanGestureRecognizer *)gestureRecognizer
{
    static FTDynamicsDrawerDirection panDrawerDirection;
    static CGPoint panStartLocationInPane;
    static CGFloat panVelocity;
    
    NSLog(@"panePanned self.currentLeftMenuDirection = %ld ",(long)self.currentLeftMenuDirection);
    @try {
//        NSAssert(LeftMenuDirectionIsCardinal(self.currentLeftMenuDirection), @"Invalid state, must be opened to close");
        
        if ([self paneDragRevealEnabledForDirection:self.currentLeftMenuDirection]) {
            switch (gestureRecognizer.state) {
                case UIGestureRecognizerStateBegan: {
                    panStartLocationInPane = [gestureRecognizer locationInView:self.paneView];
                    if(panStartLocationInPane.x > 40){
                        panDrawerDirection = FTDynamicsDrawerDirectionNone;
                        return;
                    }
                    panDrawerDirection = (FTDynamicsDrawerDirectionNone | self.currentLeftMenuDirection);
                    NSLog(@"UIGestureRecognizerStateBegan");
                    break;
                }
                case UIGestureRecognizerStateChanged: {
                    NSLog(@"UIGestureRecognizerStateChanged.panStartLocationInPane.x = %f ",panStartLocationInPane.x );
                    if(panStartLocationInPane.x > 40){
                        //                NSLog(@"UIGestureRecognizerStateChanged.panStartLocationInPane.x = %f ",panStartLocationInPane.x );
                        return;
                    }
                    CGPoint panLocationInPane = [gestureRecognizer locationInView:self.paneView];
                    // Pan gesture tracking
                    CGRect updatedPaneFrame = self.paneView.frame;
                    CGFloat panDelta = 0.0;
                    if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionHorizontal) {
                        panDelta = (panLocationInPane.x - panStartLocationInPane.x);
                        updatedPaneFrame.origin.x += panDelta;
                    } else if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionVertical) {
                        panDelta = (panLocationInPane.y - panStartLocationInPane.y);
                        updatedPaneFrame.origin.y += panDelta;
                    }
                    // Direction Determination if we have no pan reveal direction or current reveal direction
                    if (panDrawerDirection == FTDynamicsDrawerDirectionNone ||
                        self.currentLeftMenuDirection == FTDynamicsDrawerDirectionNone) {
                        FTDynamicsDrawerDirection potentialPanDrawerDirection = FTDynamicsDrawerDirectionNone;
                        if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionHorizontal) {
                            if (panDelta > 0) {
                                potentialPanDrawerDirection = FTDynamicsDrawerDirectionLeft;
                            } else if (panDelta < 0) {
                                potentialPanDrawerDirection = FTDynamicsDrawerDirectionRight;
                            }
                        } else if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionVertical) {
                            if (panDelta > 0) {
                                potentialPanDrawerDirection = FTDynamicsDrawerDirectionTop;
                            } else if (panDelta < 0) {
                                potentialPanDrawerDirection = FTDynamicsDrawerDirectionBottom;
                            }
                        }
                        if ((potentialPanDrawerDirection != FTDynamicsDrawerDirectionNone)             // Potential reveal direction is not none
                            && (self.possibleLeftMenuDirection & potentialPanDrawerDirection)                  // Potential reveal direction is possible
                            && ([self paneDragRevealEnabledForDirection:potentialPanDrawerDirection])) // Pane drag reveal is enabled for the potential reveal direction
                            
                        {
                            panDrawerDirection = potentialPanDrawerDirection;
                            self.currentLeftMenuDirection = panDrawerDirection;
                        } else {
                            return;
                        }
                    }
                    // If the determined pan reveal direction's pane drag reveal is disabled, return
                    else if (![self paneDragRevealEnabledForDirection:panDrawerDirection]) {
                        return;
                    }
                    // Panning is able to move pane, so remove all animators to prevent conflicting behavior
                    [self.dynamicAnimator removeAllBehaviors];
                    // Frame Bounding
                    CGFloat paneBoundOpenLocation = 0.0;
                    CGFloat paneBoundClosedLocation = 0.0;
                    CGFloat *paneLocation = NULL;
                    switch (self.currentLeftMenuDirection) {
                        case FTDynamicsDrawerDirectionLeft:
                            paneLocation = &updatedPaneFrame.origin.x;
                            paneBoundOpenLocation = [self openStateRevealWidth];
                            break;
                        case FTDynamicsDrawerDirectionRight:
                            paneLocation = &updatedPaneFrame.origin.x;
                            paneBoundClosedLocation = -[self openStateRevealWidth];
                            break;
                        case FTDynamicsDrawerDirectionTop: {
                            paneLocation = &updatedPaneFrame.origin.y;
                            paneBoundOpenLocation = [self openStateRevealWidth];
                            break;
                        case FTDynamicsDrawerDirectionBottom:
                            paneLocation = &updatedPaneFrame.origin.y;
                            paneBoundClosedLocation = -[self openStateRevealWidth];
                            break;
                        default:
                            NSAssert(NO, @"Invalid state, current reveal direction must be set by this point");
                            break;
                        }
                    }
                    BOOL frameBounded = YES;
                    if (*paneLocation <= paneBoundClosedLocation) {
                        *paneLocation = paneBoundClosedLocation;
                    }
                    else if (*paneLocation >= paneBoundOpenLocation) {
                        *paneLocation = paneBoundOpenLocation;
                    }
                    else {
                        frameBounded = NO;
                    }
                    if (self.paneView) {
                        NSLog(@"updatedPaneFrame = %f,%f,%f,%f",updatedPaneFrame.origin.x,updatedPaneFrame.origin.y,updatedPaneFrame.size.width,updatedPaneFrame.size.height);
                    }
                    self.paneView.frame = updatedPaneFrame;
                    // Velocity Calculation 计算速度
                    CGFloat updatedVelocity = 0.0;
                    
                    if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionHorizontal) { //横屏
                        updatedVelocity = -(panStartLocationInPane.x - panLocationInPane.x);
                        
                    } else if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionVertical) {//竖屏
                        updatedVelocity = -(panStartLocationInPane.y - panLocationInPane.y);
                    }
                    // Velocity can be 0 due to an error, so ignore it in that case
                    if ((updatedVelocity != 0.0) && !frameBounded) {
                        panVelocity = updatedVelocity;
                    }
                    NSLog(@"UIGestureRecognizerStateChanged");
                    break;
                }
                case UIGestureRecognizerStateEnded: {
                    
                    NSLog(@"UIGestureRecognizerStateEnded");
                    if (panDrawerDirection == FTDynamicsDrawerDirectionNone) {
                        return;
                    }
                    // Reached the velocity threshold so update to the appropriate state
                    if (fabs(panVelocity) > PaneViewVelocityThreshold) {
                        FTDynamicsDrawerPaneState state = 0;
                        if (self.currentLeftMenuDirection & (FTDynamicsDrawerDirectionTop | FTDynamicsDrawerDirectionLeft)) {
                            state = ((panVelocity > 0) ? FTDynamicsDrawerPaneStateOpen : FTDynamicsDrawerPaneStateClosed);
                        } else if (self.currentLeftMenuDirection & (FTDynamicsDrawerDirectionBottom | FTDynamicsDrawerDirectionRight)) {
                            state = ((panVelocity < 0) ? FTDynamicsDrawerPaneStateOpen : FTDynamicsDrawerPaneStateClosed);
                        } else {
                            NSAssert(NO, @"Invalid state, reveal direction niether positive nor negative");
                        }
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
                            [self addDynamicsBehaviorsToCreatePaneState:state pushMagnitude:(fabs(panVelocity) * PaneViewVelocityMultiplier) pushAngle:[self gravityAngleForState:state direction:self.currentLeftMenuDirection] pushElasticity:self.elasticity];
                        }else{
                            [UIView animateWithDuration:0.6f animations:^{
                                self.paneView.frame = (CGRect){[self paneViewOriginForPaneState:state], self.paneView.frame.size};
                            } completion:^(BOOL finished) {
                                if(finished){
                                    _paneState = (([self paneViewClosedFraction] < 0.5) ? FTDynamicsDrawerPaneStateClosed : FTDynamicsDrawerPaneStateOpen);
                                    self.currentLeftMenuDirection = (([self paneViewClosedFraction] < 0.5) ? 2 : 0);
                                }
                            }];
                        }
                    }
                    // If we're released past half-way, snap to completion with no bounce, otherwise, snap to back to the starting position with no bounce
                    else {
                        FTDynamicsDrawerPaneState state = (([self paneViewClosedFraction] > 0.5) ? FTDynamicsDrawerPaneStateClosed : FTDynamicsDrawerPaneStateOpen);
                        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
                            [self addDynamicsBehaviorsToCreatePaneState:state];
                        }else{
                            [UIView animateWithDuration:0.6f animations:^{
                                self.paneView.frame = (CGRect){[self paneViewOriginForPaneState:state], self.paneView.frame.size};
                            } completion:^(BOOL finished) {
                                if(finished){
                                    _paneState = (([self paneViewClosedFraction] < 0.5) ? FTDynamicsDrawerPaneStateClosed : FTDynamicsDrawerPaneStateOpen);
                                    self.currentLeftMenuDirection = (([self paneViewClosedFraction] < 0.5) ? 2 : 0);
                                }
                            }];
                        }
                    }
                    break;
                }
                default:
                    break;
            }
            
        }
    }
    @catch (NSException *exception) {
        NSLog(@"exception:%@",exception);
    }
    @finally {
        
    }
    
}

#pragma mark Gestures
- (void)setPaneDragRevealEnabled:(BOOL)paneDraggingEnabled forDirection:(FTDynamicsDrawerDirection)direction
{
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection maskedValue){
        self.paneDragRevealEnabled[@(maskedValue)] = @(paneDraggingEnabled);
    });
}

- (BOOL)paneDragRevealEnabledForDirection:(FTDynamicsDrawerDirection)direction
{
    NSNumber *paneDragRevealEnabled;
    @try {
//        NSAssert(LeftMenuDirectionIsCardinal(direction), @"Only accepts singular directions when querying for drag reveal enabled");
        paneDragRevealEnabled = self.paneDragRevealEnabled[@(direction)];
        if (!paneDragRevealEnabled) paneDragRevealEnabled = @(YES);
    }
    @catch (NSException *exception) {
        NSLog(@"exception :%@",exception);
    }
    @finally {
        
    }
    //    NSNumber *paneDragRevealEnabled = self.paneDragRevealEnabled[@(direction)];
    //    if (!paneDragRevealEnabled) paneDragRevealEnabled = @(YES);
    return [paneDragRevealEnabled boolValue];
}


- (void)setPaneTapToCloseEnabled:(BOOL)paneTapToCloseEnabled forDirection:(FTDynamicsDrawerDirection)direction
{
    LeftMenuDirectionActionForMaskedValues(direction, ^(FTDynamicsDrawerDirection maskedValue){
        self.paneTapToCloseEnabled[@(maskedValue)] = @(paneTapToCloseEnabled);
    });
}
- (BOOL)paneTapToCloseEnabledForDirection:(FTDynamicsDrawerDirection)direction
{
    NSNumber *paneTapToCloseEnabled;
    @try {
        NSAssert(LeftMenuDirectionIsCardinal(direction), @"Only accepts singular directions when querying for drag reveal enabled");
        paneTapToCloseEnabled = self.paneTapToCloseEnabled[@(direction)];
        if (!paneTapToCloseEnabled) paneTapToCloseEnabled = @(YES);
    }
    @catch (NSException *exception) {
        NSLog(@"xception :%@",exception);
    }
    @finally {
        
    }
    //    NSNumber *paneTapToCloseEnabled = self.paneTapToCloseEnabled[@(direction)];
    //    if (!paneTapToCloseEnabled) paneTapToCloseEnabled = @(YES);
    return [paneTapToCloseEnabled boolValue];
}


- (void)registerTouchForwardingClass:(Class)touchForwardingClass
{
    NSAssert([touchForwardingClass isSubclassOfClass:[UIView class]], @"Registered touch forwarding classes must be a subclass of UIView");
    [self.touchForwardingClasses addObject:touchForwardingClass];
}

#pragma mark - system delegates

#pragma mark  UIDynamicAnimatorDelegates
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    // When dynamic animator has paused, a pane state has been reached, so remove all behaviors
    [self.dynamicAnimator removeAllBehaviors];
    
    // Update to the new pane state
    FTDynamicsDrawerPaneState updatedPaneState;
    if ([self paneViewIsPositionedInState:&updatedPaneState]) {
        if (updatedPaneState == FTDynamicsDrawerPaneStateClosed) {
            self.currentLeftMenuDirection = FTDynamicsDrawerDirectionNone;
        }
        self.paneState = updatedPaneState;
    }
    
    [self setPaneViewControllerViewUserInteractionEnabled:(self.paneState == FTDynamicsDrawerPaneStateClosed)];
    
    // Since rotation is disabled while the dynamic animator is running, we invoke this method to cause rotation to happen (if rotation has been initiated during dynamics)
    [UIViewController attemptRotationToDeviceOrientation];
    
    if (self.dynamicAnimatorCompletion) {
        self.dynamicAnimatorCompletion();
        self.dynamicAnimatorCompletion = nil;
    }
}


#pragma mark  UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.panePanGestureRecognizer) {
        __block BOOL shouldReceiveTouch = YES;
        // Enumerate the view's superviews, checking for a touch-forwarding class
        [touch.view superviewHierarchyAction:^(UIView *view) {
            // Only enumerate while still receiving the touch
            if (!shouldReceiveTouch) {
                return;
            }
            // If the touch was in a touch forwarding view, don't handle the gesture
            [self.touchForwardingClasses enumerateObjectsUsingBlock:^(Class touchForwardingClass, BOOL *stop) {
                if ([view isKindOfClass:touchForwardingClass]) {
                    shouldReceiveTouch = NO;
                    *stop = YES;
                }
            }];
        }];
        return shouldReceiveTouch;
    } else if (gestureRecognizer == self.paneTapGestureRecognizer) {
        FTDynamicsDrawerPaneState paneState;
        if ([self paneViewIsPositionedInState:&paneState]) {
            return (paneState != FTDynamicsDrawerPaneStateClosed);
        }
    }
    return YES;
}

- (BOOL)paneViewIsPositionedInState:(FTDynamicsDrawerPaneState *)paneState
{
    BOOL validState = NO;
    for (FTDynamicsDrawerPaneState currentPaneState = FTDynamicsDrawerPaneStateClosed; currentPaneState <= FTDynamicsDrawerPaneStateOpenWide; currentPaneState++) {
        CGPoint paneStatePaneViewOrigin = [self paneViewOriginForPaneState:currentPaneState];
        CGPoint currentPaneViewOrigin = (CGPoint){roundf(self.paneView.frame.origin.x), roundf(self.paneView.frame.origin.y)};
        CGFloat epsilon = 2.0;
        if ((fabs(paneStatePaneViewOrigin.x - currentPaneViewOrigin.x) < epsilon) && (fabs(paneStatePaneViewOrigin.y - currentPaneViewOrigin.y) < epsilon)) {
            validState = YES;
            *paneState = currentPaneState;
            break;
        }
    }
    return validState;
}


#pragma mark  - Bouncing
- (void)bouncePaneOpen
{
    [self bouncePaneOpenAllowingUserInterruption:YES completion:nil];
}

- (void)bouncePaneOpenAllowingUserInterruption:(BOOL)allowingUserInterruption completion:(void (^)(void))completion
{
    NSAssert(LeftMenuDirectionIsCardinal(self.possibleLeftMenuDirection), @"Unable to bounce open with multiple possible reveal directions");
    [self bouncePaneOpenInDirection:self.currentLeftMenuDirection allowUserInterruption:allowingUserInterruption completion:completion];
}

- (void)bouncePaneOpenInDirection:(FTDynamicsDrawerDirection)direction
{
    [self bouncePaneOpenInDirection:direction allowUserInterruption:YES completion:nil];
}

- (void)bouncePaneOpenInDirection:(FTDynamicsDrawerDirection) direction allowUserInterruption:(BOOL)allowUserInterruption completion:(void (^)(void))completion
{
    NSAssert(((self.possibleLeftMenuDirection & direction) == direction), @"Unable to bounce open with impossible/multiple directions");
    
    self.currentLeftMenuDirection = direction;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0){
        [self addDynamicsBehaviorsToCreatePaneState:FTDynamicsDrawerPaneStateClosed pushMagnitude:self.bounceMagnitude pushAngle:[self gravityAngleForState:FTDynamicsDrawerPaneStateOpen direction:direction] pushElasticity:self.bounceElasticity];
        if (!allowUserInterruption) [self setViewUserInteractionEnabled:NO];
        __weak typeof(self) weakSelf = self;
        self.dynamicAnimatorCompletion = ^{
            if (!allowUserInterruption) [weakSelf setViewUserInteractionEnabled:YES];
            if (completion != nil) completion();
        };
    }else{
        [UIView animateWithDuration:0.6f animations:^{
            if (!allowUserInterruption) [self setViewUserInteractionEnabled:NO];
            self.paneView.frame = (CGRect){[self paneViewOriginForPaneState:FTDynamicsDrawerPaneStateClosed], self.paneView.frame.size};
        } completion:^(BOOL finished) {
            if(finished){
                __weak typeof(self) weakSelf = self;
                if (!allowUserInterruption) [weakSelf setViewUserInteractionEnabled:YES];
                if (completion != nil) completion();
            }
        }];
    }
}


#pragma mark - UIViewControllerRotation
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // This prevents weird transform issues, set the transform to identity for the duration of the rotation, disables updates during rotation
    self.animatingRotation = YES;
    self.drawerView.transform = CGAffineTransformIdentity;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // This prevents weird transform issues, set the transform to identity for the duration of the rotation, disables updates during rotation
    self.animatingRotation = NO;
    [self updateStylers];
}

- (BOOL)shouldAutorotate
{
    return !self.dynamicAnimator.isRunning;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    UIInterfaceOrientationMask supportedInterfaceOrientations = UIInterfaceOrientationMaskAll;
    if (self.paneViewController) {
        supportedInterfaceOrientations &= self.paneViewController.supportedInterfaceOrientations;
    }
    if (self.drawerViewController) {
        supportedInterfaceOrientations &= self.drawerViewController.supportedInterfaceOrientations;
    }
    return supportedInterfaceOrientations;
}

- (UIViewController *)childViewControllerForStatusBarStyle
{
    return self.paneViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.paneViewController;
}


#pragma mark - Dynamics
- (void)didUpdateDynamicAnimatorAction
{
    [self paneViewDidUpdateFrame];
}

- (void)addDynamicsBehaviorsToCreatePaneState:(FTDynamicsDrawerPaneState)paneState;
{
    [self addDynamicsBehaviorsToCreatePaneState:paneState pushMagnitude:0.0 pushAngle:0.0 pushElasticity:self.elasticity];
}

- (void)addDynamicsBehaviorsToCreatePaneState:(FTDynamicsDrawerPaneState)paneState pushMagnitude:(CGFloat)pushMagnitude pushAngle:(CGFloat)pushAngle pushElasticity:(CGFloat)elasticity
{
    if (self.currentLeftMenuDirection == FTDynamicsDrawerDirectionNone) {
        return;
    }
    
    [self setPaneViewControllerViewUserInteractionEnabled:(paneState == FTDynamicsDrawerPaneStateClosed)];
    
    [self.paneBoundaryCollisionBehavior removeAllBoundaries];
    [self.paneBoundaryCollisionBehavior addBoundaryWithIdentifier:LeftMenuBoundaryIdentifier
                                                          forPath:[self boundaryPathForState:paneState direction:self.currentLeftMenuDirection]];
    [self.dynamicAnimator addBehavior:self.paneBoundaryCollisionBehavior];
    
    self.paneGravityBehavior.magnitude = [self gravityMagnitude];//重力矢量大小
    self.paneGravityBehavior.angle = [self gravityAngleForState:paneState direction:self.currentLeftMenuDirection]; //重力矢量方向
    [self.dynamicAnimator addBehavior:self.paneGravityBehavior];
    
    if (elasticity != 0.0) {
        self.paneElasticityBehavior.elasticity = elasticity;
        [self.dynamicAnimator addBehavior:self.self.paneElasticityBehavior];
    }
    
    if (pushMagnitude != 0.0) {
        self.panePushBehavior.angle = pushAngle;
        self.panePushBehavior.magnitude = pushMagnitude;
        [self.dynamicAnimator addBehavior:self.panePushBehavior];
        self.panePushBehavior.active = YES;
    }
}


- (UIBezierPath *)boundaryPathForState:(FTDynamicsDrawerPaneState)state direction:(FTDynamicsDrawerDirection)direction
{
    NSAssert(LeftMenuDirectionIsCardinal(direction), @"Indeterminate boundary for non-cardinal reveal direction");
    CGRect boundary = CGRectZero;
    boundary.origin = (CGPoint){-1.0, -1.0};
    if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionHorizontal) {
        NSLog(@"self.paneView.frame:%f,%f,%f,%f",self.paneView.frame.origin.x,self.paneView.frame.origin.y,self.paneView.frame.size.width,self.paneView.frame.size.height);
        NSLog(@"self.drawerView.frame:%f,%f,%f,%f",self.drawerView.frame.origin.x,self.drawerView.frame.origin.y,self.drawerView.frame.size.width,self.drawerView.frame.size.height);
        boundary.size.height = (CGRectGetHeight(self.paneView.frame) + 1.0);
        switch (state) {
            case FTDynamicsDrawerPaneStateClosed:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) * 2.0) + LeftMenuOpenAnimationOvershot + 2.0);
                break;
            case FTDynamicsDrawerPaneStateOpen:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) + self.openStateRevealWidth) + 2.0);
                break;
            case FTDynamicsDrawerPaneStateOpenWide:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) * 2.0) + LeftMenuOpenAnimationOvershot + 2.0);
                break;
        }
    }
    else if (self.possibleLeftMenuDirection & FTDynamicsDrawerDirectionVertical) {
        boundary.size.width = (CGRectGetWidth(self.paneView.frame) + 1.0);
        switch (state) {
            case FTDynamicsDrawerPaneStateClosed:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) * 2.0) + LeftMenuOpenAnimationOvershot + 2.0);
                break;
            case FTDynamicsDrawerPaneStateOpen:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) + self.openStateRevealWidth) + 2.0);
                break;
            case FTDynamicsDrawerPaneStateOpenWide:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) * 2.0) + LeftMenuOpenAnimationOvershot + 2.0);
                break;
        }
    }
    switch (direction) {
        case FTDynamicsDrawerDirectionRight:
            boundary.origin.x = ((CGRectGetWidth(self.paneView.frame) + 1.0) - boundary.size.width);
            break;
        case FTDynamicsDrawerDirectionBottom:
            boundary.origin.y = ((CGRectGetHeight(self.paneView.frame) + 1.0) - boundary.size.height);
            break;
        case FTDynamicsDrawerDirectionNone:
            boundary = CGRectZero;
            break;
        default:
            break;
    }
    return [UIBezierPath bezierPathWithRect:boundary];
}


// 计算重力加速度矢量的方向-------与坐标轴的夹角
- (CGFloat)gravityAngleForState:(FTDynamicsDrawerPaneState)state direction:(FTDynamicsDrawerDirection)rirection
{
    NSAssert(LeftMenuDirectionIsCardinal(rirection), @"Indeterminate gravity angle for non-cardinal reveal direction");
    switch (rirection) {
        case FTDynamicsDrawerDirectionTop:
            return ((state != FTDynamicsDrawerPaneStateClosed) ? M_PI_2 : (3.0 * M_PI_2));
        case FTDynamicsDrawerDirectionLeft:
            return ((state != FTDynamicsDrawerPaneStateClosed) ? 0.0 : M_PI);
        case FTDynamicsDrawerDirectionBottom:
            return ((state != FTDynamicsDrawerPaneStateClosed) ? (3.0 * M_PI_2) : M_PI_2);
        case FTDynamicsDrawerDirectionRight:
            return ((state != FTDynamicsDrawerPaneStateClosed) ? M_PI : 0.0);
        default:
            return 0.0;
    }
}


#pragma mark - NSKeyValueObserving
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"frame"] && (object == self.paneView)) {
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            [self paneViewDidUpdateFrame];
        }
    }
}
@end
