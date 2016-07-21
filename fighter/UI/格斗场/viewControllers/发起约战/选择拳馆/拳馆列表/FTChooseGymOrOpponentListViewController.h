//
//  FTChooseGymListViewController.h
//  fighter
//
//  Created by Liyz on 6/30/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTLaunchNewMatchViewController.h"

typedef NS_ENUM(NSInteger, FTGymOrOpponentType) {
    FTGymListType = 0,
    FTOpponentListType
};
@interface FTChooseGymOrOpponentListViewController : FTBaseViewController
@property (nonatomic, assign)FTGymOrOpponentType listType;
@property (assign, nonatomic) FTMatchType matchType;
@property (nonatomic, copy) NSString *choosedOpponentID;//选择的拳手ID
@property (nonatomic, copy) NSString *choosedOpponentName;//选择的拳手名字
@end
