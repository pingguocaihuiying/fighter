//
//  FTLaunchNewMatchViewController.h
//  fighter
//
//  Created by Liyz on 6/29/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTLaunchNewMatchViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payModeViewHeight;//支付方式view的高度
@property (weak, nonatomic) IBOutlet UIView *consultPayDetailView;//协议支付详情
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;//项目类型

@end
