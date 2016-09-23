//
//  FTShopNew.h
//  fighter
//
//  Created by kang on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTShopNewViewController : FTBaseViewController

@property(nonatomic,strong) NSString *needRefreshUrl;
@property(nonatomic,strong) NSURLRequest *request;

-(id)initWithUrl:(NSString*)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
