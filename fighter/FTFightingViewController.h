//
//  FTFightingViewController.h
//  fighter
//
//  Created by Liyz on 6/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

typedef void(^RankButtonBlock)(UIButton *rankButton);

@interface FTFightingViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIScrollView *currentScrollView;
@property (weak, nonatomic) IBOutlet UIView *currentView;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIButton *entryButton;


#pragma mark push响应方法
- (void) pushToDetailController:(NSDictionary *)dic;

@property (nonatomic, copy) RankButtonBlock ranckButtonBlock;
@property (nonatomic, strong) UIButton *rankBtn;



/**
 show rank button
 */
- (void) showRankButton;


/**
 hide rank button 
 */
- (void) hideRankButton;
@end
