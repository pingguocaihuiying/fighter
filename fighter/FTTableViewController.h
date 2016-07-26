//
//  TableViewController.h
//  TestPageViewController
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int, FTCellType) {
    FTCellTypeNews = 0,   // 拳讯
    FTCellTypeArena = 1,  // 拳吧
    FTCellTypeFighting = 2  //格斗场
};

@class FTTableViewController;
@protocol FTTableViewdelegate <NSObject>
@optional
- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath;
- (void)fttableView:(FTTableViewController *)tableView didSelectShareButton:(NSIndexPath *)indexPath;

@end

//格斗场主页按钮的点击事件回调代理
@protocol FTFightingMainVCButtonsClickedDelegate <NSObject>

- (void)buttonClickedWithIdentifycation:(NSString *)identifycationString andRaceId:(NSString *)raceId ;

@end

@interface FTTableViewController : UITableViewController
//数据源
@property(nonatomic,strong) NSMutableArray *sourceArray;
//@property (nonatomic, copy)NSString *newsOrVideo;//值为“news”、“video”，用于区分新闻、视频
@property (nonatomic, assign)FTCellType listType;//值为“news”、“video”，用于区分新闻、视频、格斗场

//代理，用于点击cell的传值
@property (nonatomic, weak) id<FTTableViewdelegate> FTdelegate;

//tableview的顺序，第几个
@property (nonatomic, assign) NSInteger order;

@property (weak, nonatomic) id<FTFightingMainVCButtonsClickedDelegate> fightingTableViewButtonsClickedDelegate;
@end

