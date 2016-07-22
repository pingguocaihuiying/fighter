//
//  FTPracticeViewController.h
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@protocol TeachDelegate <NSObject>

- (void) pushToController:(UIViewController *) viewController;

@end

@interface FTPracticeViewController : FTBaseViewController <TeachDelegate>


#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic;

@end
