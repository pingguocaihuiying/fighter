//
//  FTCoachView.h
//  fighter
//
//  Created by kang on 16/6/24.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPracticeViewController.h"
#import "ViewControllerTransitionDelegate.h"

@interface FTCoachView : UIView
@property (nonatomic, weak) id<ViewControllerTransitionDelegate> delegate;

@end
