//
//  HUD.h
//  renzhenzhuan
//
//  Created by Liyz on 4/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUD : NSObject

+ (void)showMessage:(NSString *)message inView:(UIView *)view;

@property (nonatomic, strong)MBProgressHUD *hud;

@end
