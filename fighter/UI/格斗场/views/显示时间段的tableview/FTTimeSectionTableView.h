//
//  FTTimeSectionTableView.h
//  fighter
//
//  Created by Liyz on 08/07/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

typedef NS_ENUM(NSInteger, FTWeek) {
    FTWeekMonday = 1,
    FTWeekTuesday = 2,
    FTWeekWednesday = 3,
    FTWeekThursday = 4,
    FTWeekFriday = 5,
    FTWeekSaturday = 6,
    FTWeekSunday = 7
};

#import <UIKit/UIKit.h>

@interface FTTimeSectionTableView : UITableView

@property (nonatomic, assign) FTWeek day;

@end
