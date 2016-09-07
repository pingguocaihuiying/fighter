//
//  FTShopOrderViewController.h
//  fighter
//
//  Created by kang on 16/9/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTShopOrderViewController : FTBaseViewController

@property(nonatomic,strong) NSString *needRefreshUrl;
@property(nonatomic,strong) NSURLRequest *request;
@property(nonatomic, strong) NSString *orederNO;


-(id)initWithUrl:(NSString*)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
