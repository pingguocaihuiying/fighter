//
//  FTGymSourceTableView.h
//  fighter
//
//  Created by 李懿哲 on 22/09/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface FTGymSourceTableView : UITableView

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *dateString;//日期
@property (nonatomic, copy) NSString *timeStampString;//那天的任一时间戳
@end
