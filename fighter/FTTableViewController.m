//
//  FTTableViewController.m
//  TestPageViewController
//
//  Created by SunSet on 14-12-2.
//  Copyright (c) 2014年 SunSet. All rights reserved.
//

#import "FTTableViewController.h"
#import "SDCycleScrollView.h"
#import "FTOneImageInfoTableViewCell.h"

@interface FTTableViewController ()

@end

@implementation FTTableViewController

- (void)dealloc
{
    self.sourceArrry = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.frame = CGRectMake(0, 200, 320, 400);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneImageInfoTableViewCell" owner:self options:nil]firstObject];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    cell.textLabel.text = _sourceArrry[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIScrollView *scrollView = [self getHeaderView];
    return scrollView;
}

- (UIScrollView *)getHeaderView{
        

    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 119;
}


@end
