//
//  FTDrawerViewController.h
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTDrawerViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIView *drawerView;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

//用户编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editingBtn;
//用户名label
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//用户性别label
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
//用户年龄label
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
//用户身高label
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
//用户体重label
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
//用户兴趣标签collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionLayout;

//关注和收藏的tableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//账号设置按钮
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;


@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIButton *weichatLoginBtn;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
