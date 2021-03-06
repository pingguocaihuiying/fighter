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
        [self.tableView registerNib:[UINib nibWithNibName:@"FTNewsCell" bundle:nil] forCellReuseIdentifier:@"newsCell"];
        self.tableView.estimatedRowHeight = 252;
        
    }else if(self.listType == FTCellTypeArena){//帖子
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
        [self.tableView registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
        self.tableView.estimatedRowHeight = 217;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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

    }
    cell.clickedDelegate = self;
    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    
    if (self.listType == FTCellTypeNews) {
        height = 210 *SCALE +45;
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
