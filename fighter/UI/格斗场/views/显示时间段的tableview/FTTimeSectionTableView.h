//
//  FTTimeSectionTableView.h
//  fighter
//
//  Created by Liyz on 08/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

typedef NS_ENUM(NSInteger, FTWeek) {
    FTWeekMonday = 0,
    FTWeekTuesday,
    FTWeekWednesday,
    FTWeekThursday,
    FTWeekFriday,
    FTWeekSaturday,
    FTWeekSunday
};

#import <UIKit/UIKit.h>

@interface FTTimeSectionTableView : UITableView

@property (nonatomic, assign) FTWeek *week;

@end
