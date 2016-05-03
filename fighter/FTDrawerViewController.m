//
//  FTDrawerViewController.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerViewController.h"
#import "FTDrawerCollectionCell.h"
#import "FTDrawerTableViewCell.h"
#import "masonry.h"
#import "FTDrawerTableViewHeader.h"
#import "WXApi.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"

@interface FTDrawerViewController () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, strong) NSMutableArray *interestsArray;

//@property (nonatomic, strong) FTDrawerTableViewHeader *header;
@end

static NSString *const colllectionCellId = @"colllectionCellId";
static NSString *const tableCellId = @"tableCellId";

@implementation FTDrawerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    _interestsArray = @[ @[综合格斗],
//                       @[sanda]]
    
    [self setLoginedView];
    
    [self setLoginView];
}


- (void) setLoginedView {
    
    NSLog(@"serSubviews");
    
    
    [self.drawerView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    //    [self setSubviews];
    //切换图层，把头像边框放到上层
    [self.drawerView sendSubviewToBack:self.avatarImageView];
    
    //设置身高、体重label字体颜色
    self.heightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    self.weightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    
    [self.collectionView registerClass:[FTDrawerCollectionCell class] forCellWithReuseIdentifier:colllectionCellId];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    //    [self.tableView registerClass:[FTDrawerTableViewCell class] forCellReuseIdentifier:tableCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCellId];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor grayColor];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    CGFloat offsetW = [UIScreen mainScreen].bounds.size.width *0.3;
    
    //子view的右边缘离父view的右边缘40个像素
    NSLayoutConstraint *rightContraint = [NSLayoutConstraint constraintWithItem:self.drawerView
                                                                      attribute:NSLayoutAttributeRight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeRight
                                                                     multiplier:1.0
                                                                       constant:-offsetW];
    
    //把约束添加到父视图上
    [self.drawerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:rightContraint];
}


//设置登录视图

- (void) setLoginView {
    
    [self.loginView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.weichatLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.weichatLoginBtn setTitleColor:[UIColor colorWithHex:0xcccccc] forState:UIControlStateHighlighted];
    
    [self.tipLabel setTextColor:[UIColor colorWithHex:0x505050]];
    
    
    
//    CGFloat offsetW = [UIScreen mainScreen].bounds.size.width *0.3;
//    //子view的右边缘离父view的右边缘40个像素
//    NSLayoutConstraint *rightContraint = [NSLayoutConstraint constraintWithItem:self.loginView
//                                                                      attribute:NSLayoutAttributeRight
//                                                                      relatedBy:NSLayoutRelationEqual
//                                                                         toItem:self.view
//                                                                      attribute:NSLayoutAttributeRight
//                                                                     multiplier:1.0
//                                                                       constant:-offsetW];
//    
//    //把约束添加到父视图上
//    [self.loginView setTranslatesAutoresizingMaskIntoConstraints:NO];
//    [self.view addConstraint:rightContraint];

}


//
- (void) showLoginedViewData {
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        NSLog(@"微信登录");
        if ([WXApi isWXAppInstalled] ) {
            SendAuthReq *req = [[SendAuthReq alloc] init];
            req.scope = @"snsapi_userinfo";
            req.state = @"fighter";
            [WXApi sendReq:req];
            
        }else{
            NSLog(@"目前只支持微信登录，请安装微信");
            [self showHUDWithMessage:@"目前只支持微信登录，请安装微信"];
        }
    }
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FTDrawerCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:colllectionCellId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.fightType = indexPath.row;
    [cell setBackImgView];
    
    
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    switch (indexPath.row) {
        case 0:
            width = 70;
            break;
        case 1:
            width = 40;
            break;
        case 2:
            width = 40;
            break;
        case 3:
            width = 70;
            break;
        case 4:
            width = 40;
            break;
        case 5:
            width = 50;
            break;
        case 6:
            width = 40;
            break;
        case 7:
            width = 40;
            break;
        case 8:
            width = 50;
            break;
        case 9:
            width = 40;
            break;
        case 10:
            width = 50;
            break;
        case 11:
            width = 70;
            break;
        case 12:
            width = 40;
            break;
        default:
            break;
    }

    return (CGSize){width,20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.f;
}


#pragma mark - tableViewDatasource delegate

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 46 ;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.5;
}


- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [[UIView alloc]init];
    header.backgroundColor = [UIColor grayColor];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
    if (cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setImage:[UIImage imageNamed:@"右箭头"]];
        [cell addSubview:imageView];
        
        CGRect frame = cell.textLabel.frame;
        frame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height);
        [cell.textLabel setFrame:frame];
        __weak __typeof(&*cell) weakCell = cell;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakCell.mas_centerY);
            make.right.equalTo(weakCell.mas_right).with.offset(-16);
            make.height.equalTo(@14);
            make.width.equalTo(@7);

        }];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"我的关注";
        cell.textLabel.textColor = [UIColor whiteColor];
    }else {
        cell.textLabel.text = @"我的收藏";
    }
//    FTDrawerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellId];
//    
//    if (!cell) {
//        
////        cell = [[FTDrawerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellId];
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTDrawerTableViewCell" owner:self options:nil]firstObject];
//        [cell setBackgroundColor:[UIColor clearColor]];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"我的关注";
////        [cell setTitleWithString:@"我的关注"];
////        cell.cellTitle.text = @"我的关注";
//        
//    }else {
//        cell.textLabel.text = @"我的关注";
////        cell.cellTitle.text = @"我的收藏";
//    }
//    NSLog(@"cell:%@",cell);
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - private methods

- (void)showHUDWithMessage:(NSString *)message{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        //        HUD = nil;
    }];
}


@end
