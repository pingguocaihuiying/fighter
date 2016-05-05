//
//  FTVideoViewController.h
//  fighter
//
//  Created by Liyz on 5/3/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTVideoViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;
@property (weak, nonatomic) IBOutlet UIScrollView *currentScrollView;
@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

//下面是“最热”、“最新”相关的
@property (weak, nonatomic) IBOutlet UIView *containerOfNewOrHotView;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *newestButton;


@end
