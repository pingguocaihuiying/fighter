//
//  FTChooseGymListViewController.h
//  fighter
//
//  Created by Liyz on 6/30/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
typedef NS_ENUM(NSInteger, FTGymOrOpponentType) {
    FTGymListType = 0,
    FTOpponentListType
};
@interface FTChooseGymOrOpponentListViewController : FTBaseViewController
@property (nonatomic, assign)FTGymOrOpponentType listType;
@end
