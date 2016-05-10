//
//  TableViewController.h
//  TestPageViewController
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTTableViewController;
@protocol FTTableViewdelegate <NSObject>
- (void)fttableView:(FTTableViewController *)tableView didSelectWithIndex:(NSIndexPath *)indexPath;
@end

@interface FTTableViewController : UITableViewController
//数据源
@property(nonatomic,strong) NSMutableArray *sourceArray;
@property (nonatomic, copy)NSString *newsOrVideo;//值为“news”、“video”，用于区分新闻、视频

//代理，用于点击cell的传值
@property (nonatomic, weak) id<FTTableViewdelegate> FTdelegate;

//tableview的顺序，第几个
@property (nonatomic, assign) NSInteger order;
@end

