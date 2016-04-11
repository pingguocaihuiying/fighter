//
//  FTTableViewController.m
//  TestPageViewController
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "FTTableViewController.h"
#import "SDCycleScrollView.h"

@interface FTTableViewController ()<SDCycleScrollViewDelegate>

@end

@implementation FTTableViewController

- (void)dealloc
{
    self.sourceArrry = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 200, 320, 400);
//    self.tableView.frame = CGRectMake(0, 0, 0, 0);
    self.tableView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _sourceArrry.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellider = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellider];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
    }
    cell.textLabel.text = _sourceArrry[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIScrollView *scrollView = [self getHeaderView];
    return scrollView;
}

- (UIScrollView *)getHeaderView{
        
        UIScrollView *containerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        
        containerView.contentSize = CGSizeMake(self.view.frame.size.width, 180);
        [self.view addSubview:containerView];
        
        // 情景二：采用网络图片实现
        NSArray *imagesURLStrings = @[
                                      @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                      @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                      ];
        
        // 情景三：图片配文字
        NSArray *titles = @[@"test1 ",
                            @"test2",
                            @"test3",
                            @"test4"
                            ];
        
        CGFloat w = self.view.bounds.size.width;
        
        SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView2.titlesGroup = titles;
        cycleScrollView2.currentPageDotColor = [UIColor redColor]; // 自定义分页控件小圆标颜色
        [containerView addSubview:cycleScrollView2];
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    return containerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 180;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}

@end
