//
//  FTDuiBaWebView.h
//  fighter
//
//  Created by kang on 16/8/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDuiBaWebView : UIWebView

@property (nonatomic,assign) id<UIWebViewDelegate> webDelegate;

-(id)initWithFrame:(CGRect)frame andUrl:(NSString*)url;

@end
