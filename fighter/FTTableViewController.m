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
#import "FTVideoTableViewCell.h"
#import "FTArenaTextTableViewCell.h"
#import "FTArenaImageTableViewCell.h"
#import "FTArenaBean.h"

@interface FTTableViewController ()<FTTableViewCellClickedDelegate>

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
    if (self.listType == FTCellTypeNews) {
        [self.tableView registerNib:[UINib nibWithNibName:@"FTOneBigImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTThreeImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTOneImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
    }else if(self.listType == FTCellTypeArena){
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
    }
    
//    [self.tableView registerNib:[UINib nibWithNibName:@"FTVideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell4"];
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
    
   
    FTBaseTableViewCell *cell;
    if (self.listType == FTCellTypeNews) {
        
        FTNewsBean *bean = self.sourceArray[indexPath.row];
        NSString *layout = bean.layout;
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
                static int count = 0;
                count ++;
                NSLog(@"count : %d", count);
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
        }
        
        [cell setWithBean:bean];
        
        return cell;
    }else if (self.listType == FTCellTypeArena){
        FTArenaBean *bean = self.sourceArray[indexPath.row];
        
        static NSString *celliderAreraText = @"cellArenaText";
        static NSString *celliderArenaImage = @"cellArenaImage";
        
        if ([bean.pictureUrlNames isEqualToString:@""] && [bean.videoUrlNames isEqualToString:@""]) {//文本
        cell = [tableView dequeueReusableCellWithIdentifier:celliderAreraText];
        }else{//图片
        cell = [tableView dequeueReusableCellWithIdentifier:celliderArenaImage];
        }
        
        if ([bean.pictureUrlNames isEqualToString:@""] && [bean.videoUrlNames isEqualToString:@""]) {
        cell = [tableView dequeueReusableCellWithIdentifier:celliderAreraText];
        }else{
        cell = [tableView dequeueReusableCellWithIdentifier:celliderArenaImage];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
       
        
//        NSDictionary *dic = self.sourceArray[indexPath.row];
        //改变cell的值
        
        
//        [bean setValuesWithDic:dic];
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
        return  nil;
    }
        
    return cell;
    
    
//    NSDictionary *dic = self.sourceArray[indexPath.row];
//
//
//    if ([dic isKindOfClass:[NSDictionary class]] && dic.count > 0) {//如果有网络数据源
//        NSLog(@"网络数据已经加载");
//        
//        NSString *layout = dic[@"layout"];
//            //如果是大图
//        if (self.listType == FTCellTypeNews) {
//            if ([layout isEqualToString:@"1"]) {//大图
//                static NSString *cellider1 = @"cell1";
//                cell = [tableView dequeueReusableCellWithIdentifier:cellider1];
//                if (cell == nil) {
//                    cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneBigImageInfoTableViewCell" owner:self options:nil]firstObject];
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//            }else if ([layout isEqualToString:@"3"]) {//三图
//                static NSString *cellider2 = @"cell2";
//                cell = [tableView dequeueReusableCellWithIdentifier:cellider2];
//                if (cell == nil) {
//                    static int count = 0;
//                    count ++;
//                    NSLog(@"count : %d", count);
//                    cell = [[[NSBundle mainBundle]loadNibNamed:@"FTThreeImageInfoTableViewCell" owner:self options:nil]firstObject];
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//            }else if ([layout isEqualToString:@"2"]) {//一图
//                static NSString *cellider3 = @"cell3";
//                cell = [tableView dequeueReusableCellWithIdentifier:cellider3];
//                if (cell == nil) {
//                    cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneImageInfoTableViewCell" owner:self options:nil]firstObject];
//                    cell.backgroundColor = [UIColor clearColor];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }
//            }
//        }
//
//        else if (self.listType == FTCellTypeArena){
//            static NSString *celliderAreraText = @"cellArenaText";
//            static NSString *celliderArenaImage = @"cellArenaImage";
//            cell = [tableView dequeueReusableCellWithIdentifier:celliderArenaImage];
//            if (cell == nil) {
//                NSLog(@"cell is nil");
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTArenaTextTableViewCell" owner:self options:nil]firstObject];
//                cell.backgroundColor = [UIColor clearColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        //改变cell的值
//        FTBaseBean *bean;
//        if ([layout isEqualToString:@"1"] | [layout isEqualToString:@"2"] | [layout isEqualToString:@"3"]) {
//            bean = [FTNewsBean new];
//        }else if (_listType == FTCellTypeArena) {
//            bean = [FTVideoBean new];
//        }
////        [bean setValuesForKeysWithDictionary:dic];//这种写法在服务器新增字段时，客户端会崩溃
//        [bean setValuesWithDic:dic];
//        [cell setWithBean:bean];
//    }else{//如果没有网络数据源
//        NSLog(@"第一次加载，无网络数据");
//        static NSString *cellider = @"cell";
//        cell = [tableView dequeueReusableCellWithIdentifier:cellider];
//        if (cell == nil) {
//            
//            cell = [[FTOneImageInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellider];
//            cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneBigImageInfoTableViewCell" owner:self options:nil]firstObject];
//            cell.backgroundColor = [UIColor clearColor];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        return  nil;
//    }
//    return cell;
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
//    return 380;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (self.listType == FTCellTypeNews) {
        FTNewsBean *bean = self.sourceArray[indexPath.row];
        NSString *layout = bean.layout;
        if ([layout isEqualToString:@"1"]) {
            height = 218;
        }else if([layout isEqualToString:@"3"]){
            height = 163;
        }
        else if([layout isEqualToString:@"2"]){
            height = 146 ;//一张小图的cell，图片等比例放大了1.5倍
        }
    }else if(self.listType == FTCellTypeArena){
        
       FTArenaBean *bean = self.sourceArray[indexPath.row];
        
        NSString *videoUrl = bean.videoUrlNames == nil ? @"" : bean.videoUrlNames;
        NSString *pictureUrl = bean.pictureUrlNames == nil ? @"" : bean.pictureUrlNames;
        
        if ([videoUrl isEqualToString:@""] && [pictureUrl isEqualToString:@""]) {//如果是文本类型的cell
            height = 185;
            NSLog(@"cell height : %f", height);
        }else{//如果是带图片的cell
            height = 217;
            
            CGFloat imageHeight = 92;//图片原始高度
            height = (height - imageHeight) + imageHeight * SCALE;
            
        }

    }
    
    
//    NSLog(@"height : %f", height);
    return height;//130是视频界面的cell高度
}

- (void)tableView:(FTTableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"cell clicked.");
    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectWithIndex:)]){
    [self.FTdelegate fttableView:self didSelectWithIndex:indexPath];
    }
    
}

- (void)clickedWithIndex:(NSIndexPath *)indexPath{
//    NSLog(@"index : %@", indexPath);
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
}
@end
