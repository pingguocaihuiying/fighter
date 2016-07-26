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
#import "FTFightingTableViewCell.h"
#import "FTNewsCell.h"

@interface FTTableViewController ()<FTTableViewCellClickedDelegate, FTFightingTableViewCellButtonsClickedDelegate>

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
    if (self.listType == FTCellTypeNews) {//新闻
//        [self.tableView registerNib:[UINib nibWithNibName:@"FTOneBigImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell1"];
//        [self.tableView registerNib:[UINib nibWithNibName:@"FTThreeImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell2"];
//        [self.tableView registerNib:[UINib nibWithNibName:@"FTOneImageInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell3"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTNewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
    }else if(self.listType == FTCellTypeArena){//帖子
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
    }else if(self.listType == FTCellTypeFighting){//格斗场
        [self.tableView registerNib:[UINib nibWithNibName:@"FTFightingTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellFighting"];
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
    if (_listType == FTCellTypeFighting) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if(_listType == FTCellTypeFighting){
        return 2;
    }
    return _sourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    FTBaseTableViewCell *cell;
    if (self.listType == FTCellTypeNews) {
        
        FTNewsBean *bean = self.sourceArray[indexPath.row];
        
        static NSString *cellider1 = @"newsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellider1];
        
        FTNewsCell *newsCell = (FTNewsCell *)cell;
        newsCell.indexPath = indexPath;

//        NSString *layout = bean.layout;
//        if ([layout isEqualToString:@"1"]) {//大图
//            static NSString *cellider1 = @"cell1";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellider1];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneBigImageInfoTableViewCell" owner:self options:nil]firstObject];
//                cell.backgroundColor = [UIColor clearColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//        }else if ([layout isEqualToString:@"3"]) {//三图
//            static NSString *cellider2 = @"cell2";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellider2];
//            if (cell == nil) {
//                static int count = 0;
//                count ++;
//                NSLog(@"count : %d", count);
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTThreeImageInfoTableViewCell" owner:self options:nil]firstObject];
//                cell.backgroundColor = [UIColor clearColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//        }else if ([layout isEqualToString:@"2"]) {//一图
//            static NSString *cellider3 = @"cell3";
//            cell = [tableView dequeueReusableCellWithIdentifier:cellider3];
//            if (cell == nil) {
//                cell = [[[NSBundle mainBundle]loadNibNamed:@"FTOneImageInfoTableViewCell" owner:self options:nil]firstObject];
//                cell.backgroundColor = [UIColor clearColor];
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            }
//        }
        
        [cell setWithBean:bean];
        
    }else if (self.listType == FTCellTypeArena){
        FTArenaBean *bean = self.sourceArray[indexPath.row];
        
        static NSString *celliderAreraText = @"cellArenaText";
        static NSString *celliderArenaImage = @"cellArenaImage";
        
        if (bean.pictureUrlNames == nil) {
            bean.pictureUrlNames = @"";
        }
        
        if (bean.videoUrlNames == nil) {
            bean.videoUrlNames = @"";
        }
        
        if ([bean.pictureUrlNames isEqualToString:@""] && [bean.videoUrlNames isEqualToString:@""]) {//文本
            cell = [tableView dequeueReusableCellWithIdentifier:celliderAreraText];
        }else{//图片
            cell = [tableView dequeueReusableCellWithIdentifier:celliderArenaImage];
        }
        
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setWithBean:bean];

    }else if (self.listType == FTCellTypeFighting){
//        FTArenaBean *bean = self.sourceArray[indexPath.row];
        
        static NSString *cellIdentityFighting = @"cellFighting";
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentityFighting];
        FTFightingTableViewCell *fightingCell = (FTFightingTableViewCell *)cell;
        fightingCell.buttonsClickedDelegate = self;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }else{
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
    cell.clickedDelegate = self;
    return cell;
}

//headerView高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectio{
    if (_listType == FTCellTypeFighting) {
        return 34;
    }
        return 0;
}

//headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 34)];
//    headerView.backgroundColor = [UIColor yellowColor];
    UILabel *headerlabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 10, 100, 14)];
//    headerlabel.backgroundColor = [UIColor redColor];
    headerlabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    headerlabel.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        headerlabel.text = @"今日赛事";
    }else if (section == 1){
        headerlabel.text = @"明日赛事";
    }
    [headerView addSubview:headerlabel];
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (self.listType == FTCellTypeNews) {
//        FTNewsBean *bean = self.sourceArray[indexPath.row];
//        NSString *layout = bean.layout;
//        if ([layout isEqualToString:@"1"]) {
//            height = 218;
//        }else if([layout isEqualToString:@"3"]){
//            height = 163;
//        }
//        else if([layout isEqualToString:@"2"]){
//            height = 146 ;//一张小图的cell，图片等比例放大了1.5倍
//        }
        height = 210+42+10;
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

    }else if(self.listType == FTCellTypeFighting){
        height = 169;
    }
    
    
//    NSLog(@"height : %f", height);
    return height;//130是视频界面的cell高度
}

- (void)tableView:(FTTableViewController *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"cell clicked.");
    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectWithIndex:)]){
    [self.FTdelegate fttableView:self didSelectWithIndex:indexPath];
    }
    
}

#pragma mark - FTTableViewCellClickedDelegate
- (void)clickedWithIndex:(NSIndexPath *)indexPath{
    
    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectWithIndex:)]){
        [self.FTdelegate fttableView:self didSelectWithIndex:indexPath];
    }
}

- (void) clickedPlayButton:(NSIndexPath *)indexPath {

    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectWithIndex:)]){
        [self.FTdelegate fttableView:self didSelectWithIndex:indexPath];
    }
}

- (void) clickedShareButton:(NSIndexPath *)indexPath {
    
    if([self.FTdelegate respondsToSelector:@selector(fttableView:didSelectShareButton:)]){
        [self.FTdelegate fttableView:self didSelectShareButton:indexPath];
    }
    
}
#pragma mark - FTFightingTableViewCellButtonsClickedDelegate
//格斗场主页面按钮的点击回掉
- (void)buttonClickedWithIdentifycation:(NSString *)identifycationString andRaceId:(NSString *)raceId{
//    NSLog(@"identifycation : %@, raceId : %@", identifycationString, raceId);
    [self.fightingTableViewButtonsClickedDelegate buttonClickedWithIdentifycation:identifycationString andRaceId:raceId];
}
@end
