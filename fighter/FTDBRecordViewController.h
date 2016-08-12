//
//  FTDBRecordViewController.h
//  fighter
//
//  Created by kang on 16/8/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"

@interface FTDBRecordViewController : FTBaseViewController2

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,strong) NSString *needRefreshUrl;
@property(nonatomic,strong) NSURLRequest *request;

-(id)initWithUrl:(NSString*)url;
-(id)initWithUrlByPresent:(NSString *)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
