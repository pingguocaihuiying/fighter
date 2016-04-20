//
//  TestViewController.h
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTNewsBean.h"

@interface FTNewsDetail2ViewController : FTBaseViewController
@property (nonatomic ,copy)NSString *urlString;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasThumbUp;
@property (nonatomic, strong)FTNewsBean *bean;
@end
