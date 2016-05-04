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
#import "FTThreeImageInfoTableViewCell.h"
#import "FTOneBigImageInfoTableViewCell.h"
#import "FTBaseTableViewCell.h"
#import "FTVideoTableViewCell.h"
#import "FTBaseBean.h"
#import "FTVideoBean.h"
#import "FTNewsBean.h"

@interface FTTableViewController ()

@end

@implementation FTTableViewController

- (void)dealloc
{
    self.sourceArray = nil;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tableView.frame = CGRectMake(0, 200, 320, 400);
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.showsVerticalScrollIndicator = NO;
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
    return _sourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.sourceArray[indexPath.row];

    
    
    FTBaseTableViewCell *cell = [FTBaseTableViewCell new];

    if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {//如果有网络数据源
        NSLog(@"网络数据已经加载");
        NSString *layout = dic[@"layout"];
            //如果是大图
        if ([layout isEqualToString:@"1"]) {//大图
            static NSString *cellider1 = @"cell1";
            cell = [tableView dequeueReusableCellWithIdentifier:cellider1];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneBigImageInfoTableViewCell" owner:self options:nil]firstObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if ([layout isEqualToString:@"3"]) {//三图
            static NSString *cellider2 = @"cell2";
            cell = [tableView dequeueReusableCellWithIdentifier:cellider2];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTThreeImageInfoTableViewCell" owner:self options:nil]firstObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if ([layout isEqualToString:@"2"]) {//一图
            static NSString *cellider3 = @"cell3";
            cell = [tableView dequeueReusableCellWithIdentifier:cellider3];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneImageInfoTableViewCell" owner:self options:nil]firstObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if(layout == nil){//如果为nil，则是视频
            NSLog(@"layout is nil");
            static NSString *cellider4 = @"cell4";
            cell = [tableView dequeueReusableCellWithIdentifier:cellider4];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTVideoTableViewCell" owner:self options:nil]firstObject];
                cell.backgroundColor = [UIColor clearColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        //改变cell的值
        FTBaseBean *bean;
        if ([layout isEqualToString:@"1"] | [layout isEqualToString:@"2"] | [layout isEqualToString:@"3"]) {
            bean = [FTNewsBean new];
        }if (layout == nil) {
            bean = [FTVideoBean new];
        }
//        [bean setValuesForKeysWithDictionary:dic];//这种写法在服务器新增字段时，客户端会崩溃
        [bean setValuesWithDic:dic];
        [cell setWithBean:bean];
    }else{//如果没有网络数据源
        NSLog(@"第一次加载，无网络数据");
        static NSString *cellider = @"cell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellider];
        if (cell == nil) {
            
            cell = [[FTOneImageInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneBigImageInfoTableViewCell" owner:self options:nil]firstObject];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }
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
//    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.sourceArray[indexPath.row];
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *layout = dic[@"layout"];
        if ([layout isEqualToString:@"1"]) {
            return 218;
        }else if([layout isEqualToString:@"3"]){
            return 163;
        }
        else if([layout isEqualToString:@"2"]){
        return 146 ;//一张小图的cell，图片等比例放大了1.5倍
        }
    }
    return 130;//130是视频界面的cell高度
}

- (void)tableView:(FTTableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"cell clicked.");
    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectWithIndex:)]){
    [self.FTdelegate fttableView:self didSelectWithIndex:indexPath];
    }
    
}

@end
