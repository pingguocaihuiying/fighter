//
//  FTPracticeViewController.h
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "ViewControllerTransitionDelegate.h"

//@protocol TeachDelegate <NSObject>
//@optional
//- (void) pushToController:(UIViewController *) viewController;
//- (void) pressentController:(UIViewController *) viewController;
//
//@end

@interface FTPracticeViewController : FTBaseViewController <ViewControllerTransitionDelegate>


- (void) getMembershipGymsFromWeb;

#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic;

@end
