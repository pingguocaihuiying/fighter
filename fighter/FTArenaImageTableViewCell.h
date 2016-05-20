//
//  FTArenaImageTableViewCell.h
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTArenaImageTableViewCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;

@end
