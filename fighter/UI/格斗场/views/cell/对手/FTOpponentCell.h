//
//  FTOpponentCellTableViewCell.h
//  fighter
//
//  Created by Liyz on 7/4/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@protocol opponentSelectedDelegate <NSObject>

- (void)selectOpponentByIndex:(NSInteger)opponentIndex;

@end
@interface FTOpponentCell : FTBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIButton *challengeButton;
@property (nonatomic, weak)id<opponentSelectedDelegate> delegate;
@end
