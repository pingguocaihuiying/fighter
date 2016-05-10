//
//  AlbumViewController.m
//  ishealth
//
//  Created by ishanghealth on 14-8-19.
//  Copyright (c) 2014年 cmcc. All rights reserved.
//

#import "AlbumViewController.h"
#import "AssetsViewController.h"
#import "AppDelegate.h"


@interface AlbumViewController ()
- (void)loadAssetsLibrary;

@end

@implementation AlbumViewController
@synthesize  assetsGroups;
@synthesize contentTableView;

static ALAssetsLibrary * assetsLibrary;

- (void)dealloc
{
    if (contentTableView) {
        contentTableView.delegate = nil;
        contentTableView.dataSource = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"所有相册";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calender_cancle.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = item;
    
    
    UITableView * _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), self.view.frame.size.height) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    self.contentTableView = _tableview;
    [self.view addSubview:contentTableView];
    
    [self loadAssetsLibrary];

    
}

#pragma mark- private
- (void)initObject
{
    if (!assetsGroups) {
        NSMutableArray * _assetsGroups = [[NSMutableArray alloc]init];
        self.assetsGroups = _assetsGroups;
    }
    [self.assetsGroups removeAllObjects];
    
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;//防止ALAssetsLibrary的生命周期提前结束，无法传递
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
        assetsLibrary=library;
    });
}

- (void)loadAssetsLibrary
{
    [self initObject];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        @autoreleasepool {
            
            void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
            {
                if (group == nil)  return;
                
                id type = [group valueForProperty:ALAssetsGroupPropertyType];
                if ([type intValue] == ALAssetsGroupSavedPhotos) {
                    [self.assetsGroups insertObject:group atIndex:0];
                } else if ([type intValue] > ALAssetsGroupSavedPhotos) {
                    [self.assetsGroups insertObject:group atIndex:1];
                } else {
                    [self.assetsGroups addObject:group];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [contentTableView reloadData];
                });
            };
            
            void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                //                NSLog(@"A problem occured. Error: %@", error.localizedDescription);
            };
            
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                         usingBlock:assetGroupEnumerator
                                       failureBlock:assetGroupEnumberatorFailure];
            
        }
    });
}

#pragma mark-
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return assetsGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idf = @"albumCell";
    UITableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (!_cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idf];
        [_cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        _cell.contentView.backgroundColor = [UIColor clearColor];
    }
    ALAssetsGroup *group = [self.assetsGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSUInteger numberOfAssets = group.numberOfAssets;
    
    [_cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetsGroups objectAtIndex:indexPath.row] posterImage]]];
    
    NSString * name = [[NSString alloc] initWithFormat:@"%@",[group valueForProperty:ALAssetsGroupPropertyName]];
    _cell.textLabel.text = name;
    
    NSString * _num = [[NSString alloc] initWithFormat:@"%d",numberOfAssets];
    _cell.detailTextLabel.text = _num;
    _cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.contentTableView deselectRowAtIndexPath:indexPath animated:YES];
    //
	AssetsViewController *controller = [[AssetsViewController alloc] initWithAssetsGroups:[self.assetsGroups objectAtIndex:indexPath.row]];
	[self.navigationController pushViewController:controller animated:YES];
}
#pragma mark-
#pragma mark button actions
- (void)backAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
