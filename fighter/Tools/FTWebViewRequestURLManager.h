//
//  FTWebViewRequestURLManager.h
//  fighter
//
//  Created by 李懿哲 on 05/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTWebViewRequestURLManager : NSObject

/**
 处理webView一些特殊请求：如点击头像、点击评论回复，跳转商店、拳馆、私教等

 @param requestURL requestURL
 */
+ (void) managerURLRequest:(NSURLRequest *)request withViewController:(UIViewController *)viewController;
@end
