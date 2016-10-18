//
//  FTAuthenticationView.m
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTAuthenticationView.h"
#import "FTPhotoPickerView.h"
#import "FTDatePickerView.h"
//#import "FTPickerViewDelegate.h"
@interface FTAuthenticationView () <UITextFieldDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, FTPickerViewDelegate>

@end

@implementation FTAuthenticationView


- (id)init{
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"FTAuthenticationView" owner:nil options:nil];
    self = [nibViews objectAtIndex:0];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.7];
        self.opaque = NO;
        
        self.contentView.layer.cornerRadius = 15;
        
//        // 描述占位文字属性
//        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//        attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
//        //富文本属性
//        NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写真实姓名" attributes:attr];
//        [self.nameTextField setAttributedPlaceholder:acountPlaceholder];
//        
//        
//        NSMutableDictionary *attr2 = [NSMutableDictionary dictionary];
//        attr2[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
//        NSAttributedString *passwordPlaceholder = [[NSAttributedString alloc] initWithString:@"请填写身份证生日" attributes:attr2];
//        [self.birthTextField setAttributedPlaceholder:passwordPlaceholder];
        
//        self.nameTextField.layer.borderColor = Cell_Space_Color.CGColor;
//        self.birthTextField.layer.borderColor = Cell_Space_Color.CGColor;
        self.nameTextField.layer.borderColor =  [UIColor lightGrayColor].CGColor;
        self.birthTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        self.nameTextField.layer.borderWidth = 0.5;
        self.birthTextField.layer.borderWidth = 0.5;
        
        self.nameTextField.delegate = self;
        self.birthTextField.delegate = self;
        
    }
    
    return self;
}


- (IBAction)cancelBtnAction:(id)sender {
    
    [self removeFromSuperview];
}


- (IBAction)addPhotoBtnAction:(id)sender {
    
    
    [self.nameTextField resignFirstResponder];
    [self.birthTextField resignFirstResponder];
    
    FTPhotoPickerView *datePicker = [[FTPhotoPickerView alloc]init];
    [datePicker.albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [datePicker.cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    datePicker.delegate = self;
    [self addSubview:datePicker];
    
}


- (void) cameraBtnAction :(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if ([self.pushDelegate respondsToSelector:@selector(pushToController:)]) {
            [self.pushDelegate pushToController:_imgPickerController];
        }
    }
}

- (void) albumBtnAction:(id) sender {
    
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([self.pushDelegate respondsToSelector:@selector(pushToController:)]) {
            [self.pushDelegate pushToController:_imgPickerController];
        }
    }
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
}


- (IBAction)submitBtnAction:(id)sender {
    
    
    [self.nameTextField resignFirstResponder];
    [self.birthTextField resignFirstResponder];
    
    
    /************存储照片到本地*****************/
    //    NSString *homePath = [NSHomeDirectory() stringByAppendingString:@"/Documents"];
    NSString * cachPath = [ NSSearchPathForDirectoriesInDomains ( NSCachesDirectory , NSUserDomainMask , YES ) firstObject ];
    //当前时间n秒以后的日期
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    //从1970年到这个日期的秒数 *1000
    NSTimeInterval last = [dat timeIntervalSince1970]*1000;
    NSString *iconfilePath   = [cachPath stringByAppendingFormat:@"/idcard%f.png", last];
    [UIImagePNGRepresentation(self.idImageView.image) writeToFile:iconfilePath atomically:YES];
    NSURL *localImageUrl = [NSURL fileURLWithPath:iconfilePath];
    
    
    // 1、上传身份证照片
    [MBProgressHUD showHUDAddedTo:self animated:YES];
     __unsafe_unretained typeof(self) weakSelf = self;
    [NetWorking uploadUserIdcard:localImageUrl Key:@"img" option:^(NSDictionary *dict) {
        NSLog(@"idcard_dict:%@",dict);
        [MBProgressHUD hideHUDForView:self animated:YES];
        bool status = [dict[@"status"] boolValue];
        if (!status) {
        
            [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            return ;
        }else {
            
            //从本地读取存储的用户信息
            NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
            FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
            localUser.isBoxerChecked = @"0";
            
            //将用户信息保存在本地
            NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
            [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }];
    
    
    [self.nameTextField resignFirstResponder];
    
    NSRange _range = [self.nameTextField.text rangeOfString:@" "];
    if (_range.location != NSNotFound) {
        //有空格
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"姓名不能包含空格"];
        return;
    }
    
    if (self.nameTextField.text.length == 0) {
        [[UIApplication sharedApplication].keyWindow showHUDWithMessage:@"姓名不能为空"];
        return;
    }
    
    NSString *propertValue = [self.nameTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSStringEncoding enc =     CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingISOLatin1);
    [propertValue stringByAddingPercentEscapesUsingEncoding:enc];
    
    
    // 2、跟新用真实姓名
    [MBProgressHUD showHUDAddedTo:self animated:YES];
   
    [NetWorking updateUserByGet:propertValue Key:@"realname" option:^(NSDictionary *dict) {
        NSLog(@"dict:%@",dict);
        if (dict != nil) {
            
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
            bool status = [dict[@"status"] boolValue];
            NSLog(@"message:%@",[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
            
            if (status == true) {
                
                [[UIApplication sharedApplication].keyWindow showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                
                //从本地读取存储的用户信息
                NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
                FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
                localUser.realname = self.nameTextField.text;
                
                //将用户信息保存在本地
                NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:localUser];
                [[NSUserDefaults standardUserDefaults]setObject:userData forKey:@"loginUser"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
            }else {
                NSLog(@"message : %@", [dict[@"message"] class]);
                [[UIApplication sharedApplication].keyWindow  showHUDWithMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            }
        }else {
            [[UIApplication sharedApplication].keyWindow  showHUDWithMessage:@"用户姓名上传失败，请稍后再试"];
            
        }
        
        [self removeFromSuperview];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (textField == self.birthTextField) {
        
        [self.nameTextField resignFirstResponder];
        
        FTDatePickerView *datePicker = [[FTDatePickerView alloc]init];
        datePicker.delegate = self;
        [self addSubview:datePicker];
        return NO;
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
   
    
    CGRect frame = [self convertRect:self.birthTextField.frame fromView:self.contentView];
    
    CGFloat heights = self.frame.size.height;
    
    // 当前点击textfield的坐标的Y值 + 当前点击textFiled的高度 + navigationbar高度- （屏幕高度- 键盘高度）
    
    // 在这一部 就是了一个 当前textfile的的最大Y值 和 键盘的最全高度的差值，用来计算整个view的偏移量
    
    int offset = frame.origin.y + 30 + 64 - ( heights - 216.0);//键盘高度216
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.frame.size.width;
    
    float height = self.frame.size.height;
    
    if(offset > 0) {
        
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        
        self.frame = rect;
        
    }
    
    [UIView commitAnimations];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    self.frame = rect;
    
    [UIView commitAnimations];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

#pragma mark - touchs
- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self.nameTextField resignFirstResponder];
    [self.birthTextField resignFirstResponder];
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.frame.size.width, self.frame.size.height);
    
    self.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - FTPickerViewDelegate
- (void) didSelectedDate:(NSString *) date type:(FTPickerType) type {

    self.birthTextField.text = date;
    
}


#pragma mark  - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"pics:%@",info);
    UIImage *editImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage * _img = [self contextDrawImage:editImage];
    
    [self.idImageView setImage:_img];
    [self.idImageView setHidden:NO];
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
    
    
    NSData *data = UIImageJPEGRepresentation(scaledImage, 1);
    
    
    
    int i = 9;
    
    // 第一次压缩
    while (data.length > 400*1000 && i > 0) {
        data = UIImageJPEGRepresentation(scaledImage, 0.1*i);
        i--;
    }
    
    // 第一次压缩
    int j = 9;
    while (data.length > 400*1000 && j > 0) {
        data = UIImageJPEGRepresentation(scaledImage, 0.01*j);
        j--;
    }
    
    // 如果压缩之后还是太大，裁剪图片
    int k = 0;
    while (data.length > 400*1000 ) {
        
        CGSize size = CGSizeMake(400/(k+1) , 400/(k+1));
        scaledImage = [UIImage imageWithData:data];
        UIGraphicsBeginImageContext(size);
        [scaledImage drawInRect:CGRectMake(0,0,size.width,size.height)];
        scaledImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(scaledImage, 0.5);
        k++;
    }
    
    
    return scaledImage;
}

@end
