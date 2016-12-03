//
//  FTAssetsViewController.h
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FTUserViewController.h"

@interface FTAssetsViewController : FTUserViewController
@property (nonatomic, strong) ALAssetsGroup * assetsGroup;
@property (nonatomic, strong) NSMutableArray * assets;

- (id)initWithAssetsGroups:(ALAssetsGroup *)_assetsGroup;

@end
