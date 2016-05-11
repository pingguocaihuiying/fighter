//
//  FTDrawerStyler.m
//  fighter
//
//  Created by kang on 16/5/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerStyler.h"

#pragma mark - DrawerStyler
@implementation DrawerParallaxStyler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.parallaxOffsetFraction = 0.35;
    }
    return self;
}

+ (instancetype)styler
{
    return [self new];
}

- (void)dynamicsDrawerViewController:(FTDynamicsDrawerViewController *)dynamicsDrawerViewController
         didUpdatePaneClosedFraction:(CGFloat) paneClosedFraction
                        forDirection:(FTDynamicsDrawerDirection)direction
{
    //    NSLog(@"*****************************");
    //    NSLog(@"**********   %f,%ld   ***********",paneClosedFraction,(long)direction);
    //    NSLog(@"*****************************");
    CGFloat paneRevealWidth = [dynamicsDrawerViewController revealWidthForDirection:direction];
    CGFloat translate = ((paneRevealWidth * paneClosedFraction) * self.parallaxOffsetFraction);
    
    if (direction & (FTDynamicsDrawerDirectionTop | FTDynamicsDrawerDirectionLeft)) {
        translate = -translate;
    }
    CGAffineTransform drawerViewTransform = dynamicsDrawerViewController.drawerView.transform;
    if (direction & FTDynamicsDrawerDirectionHorizontal) {
        drawerViewTransform.tx = CGAffineTransformMakeTranslation(translate, 0.0).tx;
    } else if (direction & FTDynamicsDrawerDirectionVertical) {
        drawerViewTransform.ty = CGAffineTransformMakeTranslation(0.0, translate).ty;
    }
    dynamicsDrawerViewController.drawerView.transform = drawerViewTransform;
}

- (void)stylerWasRemovedFromDynamicsDrawerViewController:(FTDynamicsDrawerViewController *)drawerViewController
{
    NSLog(@"************** DrawerParallaxStyler ***************");
    NSLog(@"**************  remove styler   ***************");
    
    CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 0.0);
    CGAffineTransform drawerViewTransform = drawerViewController.drawerView.transform;
    drawerViewTransform.tx = translate.tx;
    drawerViewTransform.ty = translate.ty;
    drawerViewController.drawerView.transform = drawerViewTransform;
}

- (void)stylerWasAddedToDynamicsDrawerViewController:(FTDynamicsDrawerViewController *)dynamicsDrawerViewController
{
    
    
}
@end


#pragma mark - DrawerFadeStyler
@implementation DrawerFadeStyler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.closedAlpha = 0.0;
    }
    return self;
}

+ (instancetype)styler
{
    return [self new];
}

- (void)dynamicsDrawerViewController:(FTDynamicsDrawerViewController *)dynamicsDrawerViewController
         didUpdatePaneClosedFraction:(CGFloat) paneClosedFraction
                        forDirection:(FTDynamicsDrawerDirection)direction
{
    //    NSLog(@"************** DrawerFadeStyler ***************");
    //    NSLog(@"**********   %f,%ld   ***********",paneClosedFraction,(long)direction);
    //    NSLog(@"*****************************");
    dynamicsDrawerViewController.drawerView.alpha = ((1.0 - self.closedAlpha) * (1.0  - paneClosedFraction));
}

- (void)stylerWasRemovedFromDynamicsDrawerViewController:(FTDynamicsDrawerViewController *)drawerViewController
{
    NSLog(@"************** DrawerFadeStyler ***************");
    NSLog(@"**************  remove styler   ***************");
    
    drawerViewController.drawerView.alpha = 1.0;
}

@end


#pragma mark - DrawerScaleStyler
@implementation DrawerScaleStyler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.closedScale = 0.1;
    }
    return self;
}

+ (instancetype)styler
{
    return [self new];
}

- (void)dynamicsDrawerViewController:(FTDynamicsDrawerViewController *)dynamicsDrawerViewController
         didUpdatePaneClosedFraction:(CGFloat) paneClosedFraction
                        forDirection:(FTDynamicsDrawerDirection)direction
{
    //    NSLog(@"*********** DrawerScaleStyler ******************");
    //    NSLog(@"**********   %f,%ld   ***********",paneClosedFraction,(long)direction);
    //    NSLog(@"*****************************");
    
    CGFloat scale = (1.0 - (paneClosedFraction * self.closedScale));
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    CGAffineTransform drawerViewTransform = dynamicsDrawerViewController.drawerView.transform;
    drawerViewTransform.a = scaleTransform.a;
    drawerViewTransform.d = scaleTransform.d;
    dynamicsDrawerViewController.drawerView.transform = drawerViewTransform;
}

- (void)stylerWasRemovedFromDynamicsDrawerViewController:(FTDynamicsDrawerViewController *)drawerViewController
{
    NSLog(@"************** DrawerScaleStyler ***************");
    NSLog(@"**************  remove styler   ***************");
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(1.0, 1.0);
    CGAffineTransform drawerViewTransform = drawerViewController.drawerView.transform;
    drawerViewTransform.a = scaleTransform.a;
    drawerViewTransform.d = scaleTransform.d;
    drawerViewController.drawerView.transform = drawerViewTransform;
}
@end
