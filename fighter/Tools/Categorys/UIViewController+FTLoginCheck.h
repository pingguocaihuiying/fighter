//
//  UIViewController+FTLoginCheck.h
//  fighter
//
//  Created by 李懿哲 on 29/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (FTLoginCheck)


/**
 检查是否登录，如果已经登陆，返回true；否则，跳转至登录页面

 @return 是否登录
 */
- (BOOL)isLogin;

@end
