//
//  FTShopViewController.h
//  fighter
//
//  Created by kang on 16/9/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTShopViewController : FTBaseViewController

@property(nonatomic,copy) NSString *needRefreshUrl;
@property(nonatomic,strong) NSURLRequest *request;
@property(nonatomic,copy) NSString *corporationId;

-(id)initWithUrl:(NSString*)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
