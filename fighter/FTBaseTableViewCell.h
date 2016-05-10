//
//  FTBaseTableViewCell.h
//  fighter
//
//  Created by Liyz on 4/13/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseBean.h"

@protocol FTTableViewCellClickedDelegate <NSObject>

- (void)clickedWithIndex:(NSIndexPath *)indexPath;

@end

@interface FTBaseTableViewCell : UITableViewCell


@property (nonatomic, weak)id<FTTableViewCellClickedDelegate> clickedDelegate;


- (void)setWithBean:(FTBaseBean *)bean;

@end

