//
//  FTArenaPostsDetailViewController.h
//  fighter
//
//  Created by Liyz on 5/20/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTArenaBean.h"

@protocol FTArenaDetailDelegate <NSObject>

- (void)updateCountWithArenaBean:(FTArenaBean *)arenaBean indexPath:(NSIndexPath *)indexPath;

@end

@interface FTArenaPostsDetailViewController : FTBaseViewController

@property (nonatomic, weak)id<FTArenaDetailDelegate> delegate;
@property (nonatomic, strong)FTArenaBean *arenaBean;
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (nonatomic, strong)NSString *webUrlString;

@end
