//
//  FTFightingViewController.h
//  fighter
//
//  Created by Liyz on 6/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTFightingViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *currentScrollView;
@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *entryButton;


#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic;
@end
