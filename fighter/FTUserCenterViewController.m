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

#import "FTPropertyCell.h"
#import "FTAuthenticationCell.h"
#import "FTPhoneCheckCell.h"
#import "FTLabelCell.h"
#import "FTAvatarCell.h"
#import "FTAuthenticationView.h"

@interface FTUserCenterViewController () <UITableViewDataSource,UITableViewDelegate,FTPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

{
    BOOL isregisted;
    NSInteger _t;
    NSTimer * _timer;
}

@property (nonatomic, weak) UIButton *sendCheckCodeBtn;
@end

@implementation FTUserCenterViewController

#pragma mark - life cycle

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

- (void) initSubviews {
    
    [self initPushNavigationBar];
    
    [self initTableView];
    
}

- (void) initPushNavigationBar {

    if ([_navigationSkipType isEqualToString:@"PRESENT"]) {
        //设置左侧按钮
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                       initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-取消"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(dismissBtnAction:)];
        //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }else {
        //设置左侧按钮
        UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                       initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                       style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(popBtnAction:)];
        //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    if (localUser.tel.length > 0) {
        return ;
    }
    
    //导航栏右侧按钮,绑定手机号
    UIButton *bindingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindingBtn setTitle:@"确定" forState:UIControlStateNormal];
    [bindingBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [bindingBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [bindingBtn addTarget:self action:@selector(bindingPhone:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bindingBtn];
    
}


- (void) initTableView {

    //    [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell4" bundle:nil] forCellReuseIdentifier:@"userCellId"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTPropertyCell" bundle:nil] forCellReuseIdentifier:@"PropertyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTAuthenticationCell" bundle:nil] forCellReuseIdentifier:@"AuthenticationCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTPhoneCheckCell" bundle:nil] forCellReuseIdentifier:@"PhoneCheckCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTLabelCell" bundle:nil] forCellReuseIdentifier:@"LabelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTAvatarCell" bundle:nil] forCellReuseIdentifier:@"AvatarCell"];
    
    //tableView 设置代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = Cell_Space_Color;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - 绑定手机
- (void) bindingPhone:(id)sender {

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    __weak FTPhoneCheckCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell.phoneTextField resignFirstResponder];
    [cell.checkCodeTextField resignFirstResponder];
    
    NSRange _range = [cell.checkCodeTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不能包含空格"];
        return;
    }
    
    if (cell.checkCodeTextField.text.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码不能为空"];
        return ;
    }else {
        if(cell.checkCodeTextField.text.length  != 6){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码长度不正确"];
            return;
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetWorking bindingPhoneNumber:cell.phoneTextField.text
                  checkCode:cell.checkCodeTextField.text
                     option:^(NSDictionary *dict) {
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         NSLog(@"dict:%@",dict);
                         if (dict != nil) {
                             
                             bool status = [dict[@"status"] boolValue];
                             NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                             NSLog(@"message:%@",message);
                             
                             if (status == true) {
                                 
                                 [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"绑定手机成功"];
                                 
                                 //从本地读取存储的用户信息
                                 FTUserBean *localUser = [FTUserBean loginUser];
                                 localUser.tel = cell.phoneTextField.text;
                                 
                                 //更新本地数据
                                 NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                                 [[NSUserDefaults standardUserDefaults]setObject:userData forKey:LoginUser];
                                 [[NSUserDefaults standardUserDefaults]synchronize];
                                 
                                 
                             }else {
                                
                                 [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                 
                             }
                         }else {
                             
                             [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"网络错误"];
                         }
                     }];
}

#pragma mark - 发送验证码

- (void)sentCheckCodeAction:(id)sender {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    __weak FTPhoneCheckCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell.phoneTextField resignFirstResponder];
    [cell.checkCodeTextField resignFirstResponder];
    
    NSRange _range = [cell.phoneTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能包含空格"];
        return;
    }
    
    if (cell.phoneTextField.text.length == 0 ) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号不能为空"];
        return ;
    }else {
        if(cell.phoneTextField.text.length  != 11){
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"手机号长度不正确"];
            return;
        }
    }
    
    
    //    if ( ![[Regex new] isMobileNumber:self.acountTextField.text]) {
    //        [self showHUDWithMessage:@"手机号不正确"];
    //        return;
    //    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getCheckCodeForNewBindingPhone:cell.phoneTextField.text
                                 option:^(NSDictionary *dict) {
                                     
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     NSLog(@"dict:%@",dict);
                                     if (dict != nil) {
                                         
                                         bool status = [dict[@"status"] boolValue];
                                         NSString *message = [dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                         NSLog(@"message:%@",message);
                                         
                                         
                                         if (status == true) {
                                             
                                             [cell.sentCheckCodeBtn setEnabled:NO];
                                             _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateSendCheckCodeButton:) userInfo:nil repeats:YES];
                                             _t = 60;
                                             [self setSendCheckCodeBtnText:_t];
                                             
                                             
                                         }else {
                                             NSLog(@"message : %@", [dict[@"message"] class]);
                                             [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                             //                [self showHUDWithMessage:@"验证码发送失败，稍后再试"];
                                         }
                                     }else {
                                         [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"验证码发送失败，稍后再试"];
                                         
                                     }
                                     
                                 }];
    
    
    
}

- (void) updateSendCheckCodeButton:(id) time {
    _t--;
    if (_t > 0) {
        [self setSendCheckCodeBtnText:_t];
    }else {
        
        [self.sendCheckCodeBtn setEnabled:YES];
        [_timer invalidate];
        
    }
}

- (void) setSendCheckCodeBtnText:(NSInteger)t {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    __weak FTPhoneCheckCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.sendCheckCodeBtn = cell.sentCheckCodeBtn;
    [self.sendCheckCodeBtn setTitle:[NSString stringWithFormat:@"重新发送%ld",t] forState:UIControlStateDisabled];
}

#pragma mark - 认证拳手
- (void) authenticationBtn:(id) sender {

    FTAuthenticationView *authenticationView = [[FTAuthenticationView alloc] init];
    authenticationView.pushDelegate = self;
    
    [self.view addSubview:authenticationView];
}

#pragma mark - response

- (void) popBtnAction:(id) sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EditNotification object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) dismissBtnAction:(id) sender {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:EditNotification object:nil];
        
    }];
    
}


//监听器事件
- (void) updateResponse:(id) sender {
    
    [self.tableView reloadData];
}


- (void)avatarBtnAction:(id)sender {
    
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


#pragma mark - 点击事件

- (void) tapAction:(UIGestureRecognizer *)recognizer {

    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    
    if (localUser.tel.length == 0) {
        NSIndexPath *textFieldIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        __weak FTPhoneCheckCell *textFieldCell = [self.tableView cellForRowAtIndexPath:textFieldIndexPath];
        
        [textFieldCell.phoneTextField resignFirstResponder];
        [textFieldCell.checkCodeTextField resignFirstResponder];
    }
   
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    __weak FTPropertyCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
   
    if (recognizer.view == cell.nameView) { //姓名
       
        
        FTPropertySetingViewController *VC = [[FTPropertySetingViewController alloc] init];
        VC.propertyTextField.text = localUser.username;
        VC.title = @"修改姓名";
        [self.navigationController pushViewController:VC animated:YES];
        
    }else if (recognizer.view == cell.sexView) { //性别
    
        FTSexPickerView *heightPicker = [[FTSexPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
        
    }else if (recognizer.view == cell.heightView) { //身高
        
        FTHeightPickerView *heightPicker = [[FTHeightPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
        
    }else if (recognizer.view == cell.weightView) { //体重
        
        FTWeightPickerView *heightPicker = [[FTWeightPickerView alloc]init];
        heightPicker.delegate = self;
        [self.view addSubview:heightPicker];
        
    }else if (recognizer.view == cell.locationView) { //归属地
        
        FTCityPickerView *datePicker = [[FTCityPickerView alloc]init];
        datePicker.delegate = self;
        [self.view addSubview:datePicker];
        
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    if (localUser.tel.length > 0) {
        return 4;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    if (indexPath.section == 0) {
        return 68;
    }else if (indexPath.section == 1) {
        return 260;
    }else if (indexPath.section == 2) {
        return 51;
    }else if (indexPath.section == 3) {
        
        //从本地读取存储的用户信息
        NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
        FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
        if (localUser.tel.length > 0) {
            return 45;
        }

        return 96;
    }else if (indexPath.section == 4) {
        return 45;
    }
    return 45;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 4) {
        return 20;
    }else {
        return 10;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 4) {
        
        return 20;
    }else {
        return 0;
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [UIView new]; ;
    return header;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    UIView *header = [UIView new];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    FTTableViewCell4 *cell = [tableView dequeueReusableCellWithIdentifier:@"userCellId"];
//     FTTableViewCell4 *cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTableViewCell4" owner:nil options:nil]firstObject];
//
//    
//    if (indexPath.row == 0) {
//        cell.UserPropertyLabel.text = @"姓名 ：";
//        cell.propertyContentLabel.text = @"--";
//        
//    }else if (indexPath.row == 1) {
//        cell.UserPropertyLabel.text = @"性别 ：";
//        cell.propertyContentLabel.text = @"--";
//        
//    }else if (indexPath.row == 2) {
//        cell.UserPropertyLabel.text = @"身高 ：";
//        cell.propertyContentLabel.text = @"--cm";
//        
//    }else if (indexPath.row == 3) {
//        cell.UserPropertyLabel.text = @"体重 ：";
//        cell.propertyContentLabel.text = @"--kg";
//       
//    }else if (indexPath.row == 4) {
//        cell.UserPropertyLabel.text = @"生日 ：";
//        cell.propertyContentLabel.text = @"--";
//       
//    }else if (indexPath.row == 5) {
//        cell.UserPropertyLabel.text = @"所在地 ：";
//        cell.propertyContentLabel.text = @"--";
//        
//        
//    }
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];
    
    if (indexPath.section == 0) {
        FTAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AvatarCell"];
        
        [cell.avatarBtn  sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                   forState:UIControlStateNormal
                           placeholderImage:[UIImage imageNamed:@"头像-空"]];
        
        [cell.avatarBtn addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }else if (indexPath.section == 1) {
        FTPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PropertyCell"];
      
        if (localUser) {
            
            if (localUser.username.length >0) {
                cell.nameLabel.text = [localUser.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //                cell.propertyContentLabel.text = localUser.username;;
            }
            
            if (localUser.sex.length >0) {
                cell.sexLabel.text = [localUser.sex  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                //                cell.propertyContentLabel.text = localUser.sex;
            }
            
            if (localUser.height.length >0) {
                cell.heightLabel.text = [localUser.height stringByAppendingString:@"cm"];
            }
            
            if (localUser.weight.length >0) {
                cell.weightLabel.text = [localUser.weight stringByAppendingString:@"kg"];
            }
            
//            if (localUser.birthday.length >0) {
//                cell.propertyContentLabel.text = localUser.formaterBirthday;
//                NSLog(@"birthday:%@",localUser.formaterBirthday);
//            }
            
            if (localUser.birthday.length >0) {
                cell.locationLabel.text = [localUser.address stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
        }
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]init];
        tapGesture.numberOfTapsRequired = 1;
        [tapGesture addTarget:self action:@selector(tapAction:)];
        [cell.nameView addGestureRecognizer:tapGesture];
        
        UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]init];
        tapGesture2.numberOfTapsRequired = 1;
        [tapGesture2 addTarget:self action:@selector(tapAction:)];
        [cell.sexView addGestureRecognizer:tapGesture2];
        
        UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]init];
        tapGesture3.numberOfTapsRequired = 1;
        [tapGesture3 addTarget:self action:@selector(tapAction:)];
        [cell.heightView addGestureRecognizer:tapGesture3];
        
        UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc]init];
        tapGesture4.numberOfTapsRequired = 1;
        [tapGesture4 addTarget:self action:@selector(tapAction:)];
        [cell.weightView addGestureRecognizer:tapGesture4];
        
        
        UITapGestureRecognizer *tapGesture5 = [[UITapGestureRecognizer alloc]init];
        tapGesture5.numberOfTapsRequired = 1;
        [tapGesture5 addTarget:self action:@selector(tapAction:)];
        [cell.locationView addGestureRecognizer:tapGesture5];
        
        return cell;
        
    }else if (indexPath.section == 2) {
        FTLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
        return cell;
    }else if (indexPath.section == 3) {
        
        if (localUser.tel.length > 0) {
            
            FTAuthenticationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationCell"];
            [cell.authenticationBtn addTarget:self action:@selector(authenticationBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            if (localUser.isBoxerChecked) {
                if ([localUser.isBoxerChecked integerValue] == 1) {
                    [cell.authenticationBtn  setHidden:YES];
                    [cell.authenticationLabel setHidden:NO];
                    [cell.authenticationLabel setText:@"您已经认证为拳手"];
                }else if([localUser.isBoxerChecked integerValue] == 0) {
                    [cell.authenticationBtn  setHidden:YES];
                    [cell.authenticationLabel setHidden:NO];
                    [cell.authenticationLabel setText:@"身份信息正在审核中"];
                }
            }
            
            /**
             *  2016年8月30日 by liyz  隐藏身份认证的信息
             */
            cell.authenticationLabel.hidden = YES;
            
            return cell;
        }else {
            
            FTPhoneCheckCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PhoneCheckCell"];
            [cell.sentCheckCodeBtn addTarget:self action:@selector(sentCheckCodeAction:) forControlEvents:UIControlEventTouchUpInside];
            cell.phoneTextField.delegate = self;
            cell.checkCodeTextField.delegate = self;
            return cell;
        }
       
    }else if (indexPath.section == 4) {
        
        FTAuthenticationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AuthenticationCell"];
        [cell.authenticationBtn addTarget:self action:@selector(authenticationBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (localUser.isBoxerChecked) {
            if ([localUser.isBoxerChecked integerValue] == 1) {
                [cell.authenticationBtn  setHidden:YES];
                [cell.authenticationLabel setHidden:NO];
                [cell.authenticationLabel setText:@"您已经认证为拳手"];
            }else if([localUser.isBoxerChecked integerValue] == 0) {
                [cell.authenticationBtn  setHidden:YES];
                [cell.authenticationLabel setHidden:NO];
                [cell.authenticationLabel setText:@"身份信息正在审核中"];
            }
        }
        return cell;
    }
    
    return nil;

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO];
    
    NSLog(@"1234567890");
    
    //从本地读取存储的用户信息
    FTUserBean *localUser = [FTUserBean loginUser];

    if (localUser.tel.length == 0) {
        NSIndexPath *textFieldIndexPath = [NSIndexPath indexPathForRow:0 inSection:3];
        __weak FTPhoneCheckCell *textFieldCell = [self.tableView cellForRowAtIndexPath:textFieldIndexPath];
        
        [textFieldCell.phoneTextField resignFirstResponder];
        [textFieldCell.checkCodeTextField resignFirstResponder];
    }
   
    
//
//    if (indexPath.row == 0) {
//        FTPropertySetingViewController *VC = [[FTPropertySetingViewController alloc] init];
//        VC.propertyTextField.text = localUser.username;
//        VC.title = @"修改姓名";
//        [self.navigationController pushViewController:VC animated:YES];
//    }else if (indexPath.row == 1) {
//        
//        FTSexPickerView *heightPicker = [[FTSexPickerView alloc]init];
//        heightPicker.delegate = self;
//        [self.view addSubview:heightPicker];
//    }else if (indexPath.row == 2) {
//        
//        FTHeightPickerView *heightPicker = [[FTHeightPickerView alloc]init];
//        heightPicker.delegate = self;
//        [self.view addSubview:heightPicker];
//    }else if (indexPath.row == 3) {
//        FTWeightPickerView *heightPicker = [[FTWeightPickerView alloc]init];
//        heightPicker.delegate = self;
//        [self.view addSubview:heightPicker];
//    }else if (indexPath.row == 4) {
//        FTDatePickerView *datePicker = [[FTDatePickerView alloc]init];
//         datePicker.delegate = self;
//        [self.view addSubview:datePicker];
//    }else if (indexPath.row == 5) {
//        FTCityPickerView *datePicker = [[FTCityPickerView alloc]init];
//        datePicker.delegate = self;
//        [self.view addSubview:datePicker];
//    }
    
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
            width = 68;
            break;
        case 1:
            width = 48.5;
            break;
        case 2:
            width = 48.5;
            break;
        case 3:
            width = 68;
            break;
        case 4:
            width = 48.5;
            break;
        case 5:
            width = 59;
            break;
        case 6:
            width = 48.5;
            break;
        case 7:
            width = 48.5;
            break;
        case 8:
            width = 59;
            break;
        case 9:
            width = 48.5;
            break;
        case 10:
            width = 48.5;
            break;
        case 11:
            width = 68;
            break;
        case 12:
            width = 48.5;
            break;
        default:
            break;
    }
    
    return (CGSize){width,14};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
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


#pragma mark  - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"pics:%@",info);
    UIImage *editImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage * _img = [self contextDrawImage:editImage];
   
    [self updateHeaderPicture:_img];
    
}


#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    __weak FTPhoneCheckCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    CGRect frame = [self.view convertRect:cell.frame fromView:self.tableView];
    
    CGFloat heights = self.view.frame.size.height;
    
    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 + navigationbar高度- （屏幕高度- 键盘高度）
    
    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
    
    int offset = frame.origin.y + 100 + 64 - ( heights - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    
    float height = self.view.frame.size.height;
    
    if(offset > 0) {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        self.view.frame = rect;
        
    }
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:3];
    __weak FTPhoneCheckCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    int MAX_CHARS;
    
    if (textField == cell.checkCodeTextField) {
        MAX_CHARS = 6;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        [newtxt replaceCharactersInRange:range withString:string];
        
        if ([newtxt length] == 6) {
            [cell.sentCheckCodeBtn setEnabled:YES];
        }
        return ([newtxt length] <= MAX_CHARS);
        
    }else if(textField == cell.phoneTextField) {
        
        MAX_CHARS = 11;
        NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
        
        [newtxt replaceCharactersInRange:range withString:string];
        
        return ([newtxt length] <= MAX_CHARS);
    }
    
    return YES;
}

#pragma mark - PushDelegate 

- (void) pushToController:(UIViewController *) viewController {
    
     [self.navigationController presentViewController:viewController animated:YES completion:nil];
    
}

#pragma mark  - 上传头像
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
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [NetWorking updateUserHeaderWithLocallUrl:localImageUrl
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
                                  FTUserBean *localUser = [FTUserBean loginUser];
                                  localUser.headpic = dict[@"data"];
                                  
                                  //将用户信息保存在本地
                                  NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                                  [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                                  [[NSUserDefaults standardUserDefaults]synchronize];
                                  
                                  NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                  [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                                  
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



#pragma mark  - 处理图片缩放
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
