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

@optional
- (void)clickedWithIndex:(NSIndexPath *)indexPath;

- (void)clickedPlayButton:(NSIndexPath *)indexPath;

- (void)clickedShareButton:(NSIndexPath *)indexPath;

@end

@interface FTBaseTableViewCell : UITableViewCell


@property (nonatomic, weak)id<FTTableViewCellClickedDelegate> clickedDelegate;


- (void)setWithBean:(FTBaseBean *)bean;
@end

