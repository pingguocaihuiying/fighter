//
//  FTMatchLiveViewController.h
//  fighter
//
//  Created by mapbar on 16/8/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTMatchLiveViewController : FTBaseViewController
@property (strong, nonatomic) IBOutlet UIWebView *liveWebView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webViewTopHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *customViewTopheight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *blueProgressBarHeight;
@end
