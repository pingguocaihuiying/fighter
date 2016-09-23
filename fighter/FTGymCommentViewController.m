//
//  FTGymCommentViewController.m
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentViewController.h"
#import "FTGymLevelCell.h"
#import "FTGymCommentCell.h"
#import "FTGymPhotoCell.h"
#import "FTCameraAndAlbum.h"
#import "UIImage+LabelImage.h"
#import <AVFoundation/AVFoundation.h>
#import "NSString+Size.h"
#import "QiniuSDK.h"
#import "FTQiniuNetwork.h"


@interface FTGymCommentViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *urls;

//@property(nonatomic, copy) NSString *urls;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, strong) NSNumber *comfort; // 舒适度
@property(nonatomic, strong) NSNumber *strength; // 实力
@property(nonatomic, strong) NSNumber *teachLevel;// 教学水平

@end

@implementation FTGymCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setNavigationBar];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

- (void) initData {

    _photos = [[NSMutableArray alloc]initWithCapacity:10];
    _urls = [[NSMutableArray alloc]initWithCapacity:10];
    
    self.comfort = [NSNumber numberWithInteger:5];
    self.strength = [NSNumber numberWithInteger:5];
    self.teachLevel = [NSNumber numberWithInteger:5];
    
}

- (void) setNavigationBar {
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //导航栏右侧按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [submitBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [submitBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
}


- (void) setTableView {

    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymLevelCell" bundle:nil] forCellReuseIdentifier:@"LevelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymPhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 50.0; // 设置为一个接近于行高“平均值”的数值
}

#pragma mark - response 

- (void) backBtnAction:(id) sender {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void) addPhotoBtnAction:(id) sender {
    
    if (self.photos.count >= 10) {
        [self.view showMessage:@"图片和视频最多只能添加10个"];
        return ;
    }
    FTCameraAndAlbum *cameraView = [[FTCameraAndAlbum alloc]init];
    [cameraView.albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView.cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    cameraView.delegate = self;
    [self.view addSubview:cameraView];
}


/**
 相机获取媒体

 @param sender  camera Button
 */
- (void) cameraBtnAction :(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
//    
//    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
//        
//        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
//        _imgPickerController.delegate = self;
//        _imgPickerController.allowsEditing = YES;
//        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
//    }

    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}


/**
 相册选择媒体

 @param sender album button
 */
- (void) albumBtnAction:(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
//    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
//        
//        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
//        _imgPickerController.delegate = self;
//        _imgPickerController.allowsEditing = YES;
//        _imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
//    }

    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void) submitBtnAction:(id) sender {
    
    if (self.comment == nil||self.comment.length == 0) {
        [self.view showMessage:@"评论文字不能为空"];
        return;
    }
    
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:self.comment forKey:@"comment"];
    [prams setObject:self.objId forKey:@"objId"];
    
    if (self.urls) {
        [prams setObject:self.urls forKey:@"urls"];
    }
    
    if (self.comfort) {
        [prams setObject:self.comfort forKey:@"comfort"];
    }
    
    
    if (self.strength) {
        [prams setObject:self.strength forKey:@"strength"];
    }
    
    
    if (self.teachLevel) {
        [prams setObject:self.teachLevel forKey:@"teachLevel"];
    }
    
    
    // 上传图片到七牛
    [self uploadPhtosToQiniu];
    
    
    NSString *mediaUrls = [_urls componentsJoinedByString:@","];
    if (mediaUrls.length > 0) {
        [prams setObject:mediaUrls forKey:@"urls"];
    }
    // 提交评论
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking addGymCommentWithPramDic:prams option:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"dic:%@",dict);
        NSLog(@"message:%@",dict[@"message"]);
        
        if (dict == nil) {
            [self.view showMessage:@"网络不稳定，请稍后再试~"];
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            
            [self.view showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
    }];
    
}

- (void) uploadPhtosToQiniu {

//    NSString *userId = [FTUserBean loginUser].olduserid;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    for ( int i = 0; i < _photos.count; i++ ) {
        
        NSDictionary *dic = [_photos objectAtIndex:i];
        NSData *mediaData = dic[@"data"];
        NSString *key = [_urls objectAtIndex:i];
        
        [FTQiniuNetwork getQiniuTokenWithMediaType:dic[@"type"] andKey:key andOption:^(NSString *token) {//***获取token
            NSLog(@"token : %@", token);
            
            QNUploadManager *upManager = [[QNUploadManager alloc] init];
            
            [upManager putData:mediaData key:key token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                          NSLog(@"info : %@", info);
                          NSString *status = [NSString stringWithFormat:@"%d", info.statusCode];
                          NSLog(@"info status : %@", status);
                          NSLog(@"resp : %@", resp);
                          NSLog(@"key : %@", key);
                          
                      } option:nil];
            
        }];//***获取token block回调结束
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}


#pragma mark - 照片、视频

//拍照或拍摄视频
- (void)shootPictureOrVideo {
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void)selectExistsPictureOrVideo {
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)pickMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] && [mediaTypes count] > 0) {
        NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error accessing media" message:@"Unsupported media source" delegate:nil cancelButtonTitle:@"Draft!" otherButtonTitles:nil];
        [alert show];
    }
}

//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//
//}

#pragma mark  - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"pics:%@",info);
    
    NSString *lastChosenMediaType = info[UIImagePickerControllerMediaType];
    
    FTGymPhotoCell *cell = (FTGymPhotoCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] ];
    
    NSString *userId = [FTUserBean loginUser].olduserid;
    NSString *timeString = [NSString dateString];
    NSString *key;
    
    if ([lastChosenMediaType isEqualToString:(NSString *)kUTTypeImage]) {
        // 照片
        
        UIImage *editImage = [info valueForKey:UIImagePickerControllerOriginalImage];
        UIImage *img = [UIImage editImage:editImage side:200];
        
//        NSURL *imageURL = info[UIImagePickerControllerReferenceURL];
//        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        NSDictionary *dic = @{@"image":img,
                              @"data":UIImageJPEGRepresentation(img, 1),
                              @"type":@"image"};
        
//        [_photos addObject:img];
        [_photos addObject:dic];
        [cell addPhotoToContainer:img type:FTMediaTypeImage];
        
        key = [NSString stringWithFormat:@"%@_%@",timeString, userId];
        [_urls addObject:key];
        
    }else if([lastChosenMediaType isEqualToString:(NSString *)kUTTypeMovie]){
        // 视频
        
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        NSData *movieData = [NSData dataWithContentsOfURL:videoURL];
        
        UIImage *editImage = [self getThumbnailImage:videoURL];
        UIImage *img = [UIImage editImage:editImage side:200];
        
        NSDictionary *dic = @{@"image":img,
                              @"data":movieData,
                              @"type":@"video"};
        [_photos addObject:dic];
        [cell addPhotoToContainer:img type:FTMediaTypeVedio];
        
        key = [NSString stringWithFormat:@"%@_%@mp4",timeString, userId];//key值取userId＋时间戳+mp4
        [_urls addObject:key];
        
    }
}


/**
 获取本地视频缩略图

 @param videoURL 本地视频URL

 @return 返回一张图片
 */
-(UIImage *)getThumbnailImage:(NSURL *)videoURL

{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return thumb;
}



#pragma mark - delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else {
        return 1;
    }
    
    return 0;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if (indexPath.section == 0) {
//        
//        if (indexPath.row < 3) {
//            return 50;
//        }else {
//            return 100;
//        }
//    }else {
//        
//        return 170;
//    }
//    
//    return 0;
//}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return 10;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [UIView new];
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row <3) {
            
            FTGymLevelCell *cell = (FTGymLevelCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
            cell.cellDelegate = self;
            cell.index = indexPath.row;
            
            
            if (indexPath.row == 0) {
                cell.titleLabel.text = @"舒适度：";
            }else if (indexPath.row == 1) {
                 cell.titleLabel.text = @"实力：";
            }
            
            return cell;
        }else {
            
            FTGymCommentCell *cell = (FTGymCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            cell.cellDelegate = self;
            return cell;
        }
    }else {
        
        FTGymPhotoCell *cell = (FTGymPhotoCell *)[tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];
        
        cell.delegate = self;
        cell.cellDelegate = self;
        [cell.addPhotoBtn addTarget:self action:@selector(addPhotoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setPhotoContainerWithArray:_photos];
        
        return cell;
    }
    
    return nil;
}


#pragma mark - Pressent
- (void) pressentController:(UIViewController *) viewController {
    
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}


#pragma mark - cellDelegate

- (void) endEditCell {
    
    NSLog(@"endEditCell");
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void) removeSubView:(id)object {
    
    NSLog(@"removeSubView");
     UIImage *image = (UIImage *)object;
    
    for (NSDictionary *dic in _photos) {
        
        if (dic[@"image"] == image) {
            NSInteger index = [_photos indexOfObject:dic];
            [_photos removeObject:dic];
            [_urls removeObjectAtIndex:index];
            break;
        }
    }
   
    NSLog(@"photos count:%ld",_photos.count);
    
}

- (void) gymLevel:(NSInteger)level index:(NSInteger)index {

    if (index == 0) {
        self.comfort = [NSNumber numberWithInteger:level];
    }else if (index == 1) {
        self.strength = [NSNumber numberWithInteger:level];
    }else if (index == 2) {
        self.teachLevel = [NSNumber numberWithInteger:level];
    }
}

- (void) gymComment:(NSString *)comment {

    self.comment = comment;

}






@end
