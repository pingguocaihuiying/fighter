//
//  AlbumViewController.h
//  ishealth
//
//  Created by ishanghealth on 14-8-19.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface AlbumViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray * assetsGroups;
@property (nonatomic, strong) UITableView * contentTableView;

@end
