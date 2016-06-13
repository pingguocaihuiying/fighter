//
//  UserCenterViewController.m
//  fighter
//
//  Created by kang on 16/5/5.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTUserCenterViewController.h"
#import "UIButton+WebCache.h"
#import "FTTableViewCell4.h"
#import "FTPropertySetingViewController.h"
#import "FTDatePickerView.h"
#import "FTHeightPickerView.h"
#import "FTWeightPickerView.h"
#import "FTSexPickerView.h"
#import "FTPickerViewDelegate.h"
#import "FTPhotoPickerView.h"
#import "FTCityPickerView.h"
#import "FTAlbumsViewController.h"
#import "FTImagPickerNavigationController.h"
#import "NetWorking.h"
#import "FTUserBean.h"
#import "MBProgressHUD.h"
#import "UIWindow+MBProgressHUD.h"
#import "FTDrawerCollectionCell.h"

@interface FTUserCenterViewController () <UITableViewDataSource,UITableViewDelegate,FTPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{

    BOOL isregisted;
}
@end

@implementation FTUserCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    // Do any additional setup after loading the view from its nib.
    
    [self initSubviews];
}

- (void) viewDidAppear:(BOOL)animated {
    
    //添加监听器，监听login
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateResponse:) name:@"loginAction" object:nil];
}

- (void) initSubviews {
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置按钮圆角
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.avatarBtn.layer setMasksToBounds:YES];
    self.avatarBtn.layer.cornerRadius = 20.0;
    [self.avatarBtn  sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                            forState:UIControlStateNormal
                                    placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell4" bundle:nil] forCellReuseIdentifier:@"userCellId"];
    //tableView 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = Cell_Space_Color;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    
}

#pragma mark - response 

//监听器事件
- (void) updateResponse:(id) sender {
    
    [self.tableView reloadData];
}

- (void) backBtnAction:(id) sender {

    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (IBAction)avatarBtnAction:(id)sender {
    
    FTPhotoPickerView *datePicker = [[FTPhotoPickerView alloc]init];
    [datePicker.albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [datePicker.cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    datePicker.delegate = self;
    [self.view addSubview:datePicker];
}

- (void) cameraBtnAction :(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
    }
    
}

- (void) albumBtnAction:(id) sender {
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
//    FTAlbumsViewController * _albumViewController = [[FTAlbumsViewController alloc] init];
////    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:_albumViewController];
//    @try {
//        
//        FTImagPickerNavigationController * _naviController = [[FTImagPickerNavigationController alloc]
//                                                              initWithRootViewController:_albumViewController
//                                                              successBlock:^(UIImage *image) {
//                                                                  
//                                                                  NSLog(@"image:%@",image);
//                                                                  //更新用户头像
//                                                                  [self updateHeaderPicture:image];
//                                                                  [self.avatarBtn setImage:image forState:UIControlStateNormal];
//                                                                  return ;
//                                                                  
//                                                              }];
//        
//        [self.navigationController presentViewController:_naviController animated:YES completion:nil];
////        [self.navigationController pushViewController:_naviController animated:YES];
//
//    }
//    @catch (NSException *exception) {
//        NSLog(@"exception:%@",exception);
//    }
//    @finally {
//        
//    }

    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
    }
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
}

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45 ;
}

//-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//    return 0.5;
//}


//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *header = [[UIView alloc]init];
//    header.backgroundColor = [UIColor colorWithHex:0x505050];
//    return header;
//}


//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIEdgeInsets edgeInsets;
////    if (indexPath.row == 5) {
//////         edgeInsets = UIEdgeInsetsMake(0, self.tableView.frame.size.width, 0, 0);
////        edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
////        
////    }else {
////        edgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
////    }
//    edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
//    
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
//    {
//        NSLog(@"cell ...............");
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
//    {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"userCellId"];
//     FTTableViewCell4 *cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTableViewCell4" owner:nil options:nil]firstObject];
    
    
    if (indexPath.row == 0) {
        cell.UserPropertyLabel.text = @"姓名 ：";
        cell.propertyContentLabel.text = @"--";
        
    }else if (indexPath.row == 1) {
        cell.UserPropertyLabel.text = @"性别 ：";
        cell.propertyContentLabel.text = @"--";
        
    }else if (indexPath.row == 2) {
        cell.UserPropertyLabel.text = @"身高 ：";
        cell.propertyContentLabel.text = @"--cm";
        
    }else if (indexPath.row == 3) {
        cell.UserPropertyLabel.text = @"体重 ：";
        cell.propertyContentLabel.text = @"--kg";
       
    }else if (indexPath.row == 4) {
        cell.UserPropertyLabel.text = @"生日 ：";
        cell.propertyContentLabel.text = @"--";
       
    }else if (indexPath.row == 5) {
        cell.UserPropertyLabel.text = @"所在地 ：";
        cell.propertyContentLabel.text = @"--";
        
        
    }
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (localUser) {
        if (indexPath.row == 0) {
            if (localUser.username.length >0) {
                cell.propertyContentLabel.text = [localUser.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                cell.propertyContentLabel.text = localUser.username;;
            }
            
        }else if (indexPath.row == 1) {
            if (localUser.sex.length >0) {
                cell.propertyContentLabel.text = [localUser.sex  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                cell.propertyContentLabel.text = localUser.sex;
            }
        }else if (indexPath.row == 2) {
            if (localUser.height.length >0) {
                cell.propertyContentLabel.text = [localUser.height stringByAppendingString:@"cm"];
            }
        }else if (indexPath.row == 3) {
            if (localUser.weight.length >0) {
                cell.propertyContentLabel.text = [localUser.weight stringByAppendingString:@"kg"];
            }
            
        }else if (indexPath.row == 4) {
            if (localUser.birthday.length >0) {
                cell.propertyContentLabel.text = localUser.formaterBirthday;
                NSLog(@"birthday:%@",localUser.formaterBirthday);
            }
            
        }else if (indexPath.row == 5) {
            if (localUser.birthday.length >0) {
                cell.propertyContentLabel.text = [localUser.address stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
        }
        
    }
    
    return cell;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    //从本地读取存储的用户信息
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    
    if (indexPath.row == 0) {
        FTPropertySetingViewController *VC = [[FTPropertySetingViewController alloc] init];
        VC.propertyTextField.text = localUser.username;
        VC.title = @"修改姓名";
        [self.navigationController pushViewController:VC animated:YES];
    }else if (indexPath.row == 1) {
        
        FTSexPickerView *heightPicker = [[FTSexPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
    }else if (indexPath.row == 2) {
        
        FTHeightPickerView *heightPicker = [[FTHeightPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
    }else if (indexPath.row == 3) {
        FTWeightPickerView *heightPicker = [[FTWeightPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
    }else if (indexPath.row == 4) {
        FTDatePickerView *datePicker = [[FTDatePickerView alloc]init];
         datePicker.delegate = self;
        [self.view addSubview:datePicker];
    }else if (indexPath.row == 5) {
        FTCityPickerView *datePicker = [[FTCityPickerView alloc]init];
        datePicker.delegate = self;
        [self.view addSubview:datePicker];
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
    if (!isregisted) {
        [collectionView registerClass:[FTDrawerCollectionCell class] forCellWithReuseIdentifier:@"colllectionCellId"];
        isregisted = YES;
    }
    FTDrawerCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"colllectionCellId" forIndexPath:indexPath];
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
            width = 65;
            break;
        case 1:
            width = 36;
            break;
        case 2:
            width = 36;
            break;
        case 3:
            width = 65;
            break;
        case 4:
            width = 36;
            break;
        case 5:
            width = 45;
            break;
        case 6:
            width = 36;
            break;
        case 7:
            width = 36;
            break;
        case 8:
            width = 45;
            break;
        case 9:
            width = 36;
            break;
        case 10:
            width = 45;
            break;
        case 11:
            width = 65;
            break;
        case 12:
            width = 36;
            break;
        default:
            break;
    }
    
    return (CGSize){width,20};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 0, 6, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.f;
}

#pragma mark - FTDatePickerViewDelegate
- (void) didSelectedDate:(NSString *)date type:(FTPickerType)type{
    
    
    if (date && date.length > 0 ) {
        
        [self.tableView reloadData];
    }
    
}


#pragma mark  UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"pics:%@",info);
    UIImage *editImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage * _img = [self contextDrawImage:editImage];
   
    [self.avatarBtn setImage:_img forState:UIControlStateNormal];
    [self updateHeaderPicture:_img];
    
}


//上传头像
- (void) updateHeaderPicture:(UIImage *)editedImage {
    
    /************存储照片到本地*****************/
//    NSString *homePath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    //当前时间n秒以后的日期
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    //从1970年到这个日期的秒数 *1000
    NSTimeInterval last = [dat timeIntervalSince1970]*1000;
    NSString *iconfilePath   = [cachPath stringByAppendingFormat:@"/head%f.png", last];
    [UIImagePNGRepresentation(editedImage) writeToFile:iconfilePath atomically:YES];
    NSURL *localImageUrl = [NSURL fileURLWithPath:iconfilePath];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NetWorking *net = [NetWorking new];
    __unsafe_unretained typeof(self) weakSelf = self;
    [net updateUserHeaderWithLocallUrl:localImageUrl
                         Key:@"img"
                      option:^(NSDictionary *dict) {
                          NSLog(@"dict:%@",dict);
                          if (dict != nil) {
                              
                              [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                              
                              bool status = [dict[@"status"] boolValue];
                              NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
                              
                              if (status == true) {
                                  
                                  //                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:message];
                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                  
                                  
                                  //从本地读取存储的用户信息
                                  NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                                  FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                                  localUser.headpic = dict[@"data"];
                                  
                                  //将用户信息保存在本地
                                  NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                                  [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  [weakSelf.avatarBtn setImage:editedImage forState:UIControlStateNormal];
                                  
                                  
                              }else {
                                  NSLog(@"message : %@", [dict[@"message"] class]);
                                  [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];

                              }
                          }else {
                              
                              [MBProgressHUD hideHUDForView:self.view animated:YES];
                              [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                              
                          }
                      }];
    
}


//手动实现图片压缩，可以写到分类里，封装成常用方法。按照大小进行比例压缩，改变了图片的size。
- (UIImage *)makeThumbnailFromImage:(UIImage *)srcImage scale:(double)imageScale {
    UIImage *thumbnail = nil;
    CGSize imageSize = CGSizeMake(srcImage.size.width * imageScale, srcImage.size.height * imageScale);
    if (srcImage.size.width != imageSize.width || srcImage.size.height != imageSize.height)
    {
        UIGraphicsBeginImageContext(imageSize);
        CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
        [srcImage drawInRect:imageRect];
        thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else
    {
        thumbnail = srcImage;
    }
    return thumbnail;
}


#pragma mark  -处理图片缩放
- (UIImage *)contextDrawImage:(UIImage *)_img
{
    
    NSLog(@"处理图片缩放_img.width = %f",_img.size.width);
    NSLog(@"处理图片缩放_img.height = %f",_img.size.height);
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (_img.size.width>_img.size.height) {
        
        height = 200;
        width = _img.size.width *(height/_img.size.height);
        
    }else{
        
        width = 200;
        height= _img.size.height *(width/_img.size.width);
    }
    
    
    CGSize size=CGSizeMake(width,height);
    
    UIGraphicsBeginImageContext(size);
    
   
    CGRect _rect = CGRectMake(0, 0, width, height);
    // 绘制改变大小的图片
    [_img drawInRect:_rect];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
