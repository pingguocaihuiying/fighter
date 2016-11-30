//
//  FTBoxingBarCollectionViewCell.h
//  fighter
//
//  Created by 李懿哲 on 25/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTModuleBean.h"

@interface FTBoxingBarCollectionViewCell : UICollectionViewCell


/**
 根据属性设置cell

 @param bean FTBoxingBarCollectionViewCell bean
 */
- (void)setWithBean:(FTModuleBean *)bean;

@end
