
//
//  FTPostListTableView.m
//  fighter
//
//  Created by 李懿哲 on 28/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTPostListTableView.h"
#import "FTArenaBean.h"
#import "FTBaseTableViewCell.h"

@interface FTPostListTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation FTPostListTableView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
        return self;
    }
    return self;
}

- (void)initSubViews{
    self.backgroundColor = [UIColor clearColor];
    
    self.delegate = self;
    self.dataSource = self;
    [self registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    //注册cell用于重用
    [self registerNib:[UINib nibWithNibName:@"FTArenaTextTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaText"];
    [self registerNib:[UINib nibWithNibName:@"FTArenaImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellArenaImage"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@" %ld", indexPath.row);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height;
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
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTArenaBean *bean = self.sourceArray[indexPath.row];
    
    FTBaseTableViewCell *cell;
    
    static NSString *celliderAreraText = @"cellArenaText";
    static NSString *celliderArenaImage = @"cellArenaImage";
    
    if (bean.pictureUrlNames == nil) {
        bean.pictureUrlNames = @"";
    }
    
    if (bean.videoUrlNames == nil) {
        bean.videoUrlNames = @"";
    }
    
    if (bean) {
        if ([bean.pictureUrlNames isEqualToString:@""] && [bean.videoUrlNames isEqualToString:@""]) {//文本
            cell = [tableView dequeueReusableCellWithIdentifier:celliderAreraText];
        }else{//图片
            cell = [tableView dequeueReusableCellWithIdentifier:celliderArenaImage];
        }
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:celliderAreraText];
    }

    
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setWithBean:bean];
    return cell;
}

@end
