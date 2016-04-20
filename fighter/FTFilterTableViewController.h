//
//  FTFilterTableViewController.h
//  fighter
//
//  Created by Liyz on 4/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTFilterDelegate <NSObject>

- (void)updateTypeArray:(NSArray *) typeArray;

@end

@interface FTFilterTableViewController : UITableViewController;
@property (nonatomic, strong)NSArray *arr;
@property (nonatomic, strong)NSMutableArray *arr1;
@property (nonatomic, strong)NSMutableArray *arr2;
@property (nonatomic, weak)id<FTFilterDelegate> delegate;
@end


