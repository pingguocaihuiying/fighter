//
//  FTNewPostViewController.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewPostViewController.h"
#import "FTSelectedCategoriesView.h"
#import "FTArenaNetwork.h"
#import "FTQiniuNetwork.h"
#import "QiniuSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@interface FTNewPostViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong)UICollectionView *mediaCollcetionView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSURL *movieURL;
@property (nonatomic, strong)NSString *lastChosenMediaType;

@property (nonatomic, strong)NSMutableArray *imageURLArray;
@property (nonatomic, strong)NSMutableArray *videoURLArray;
@end

@implementation FTNewPostViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    NSLog(@"initWithNibName");
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
//        _meidiaPickerViewHeight.constant = 38 + 54 * SCALE + 200;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
        NSLog(@"initWithCoder");
    if (self = [super initWithCoder: aDecoder]) {
//        _meidiaPickerViewHeight.constant = 38 + 54 * SCALE + 200;//无效果
    }
    return self;
}

- (void)qiniuUpload{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self setHideKeyboardEvent];
    [self setSubViews];
}

- (void)initBaseData{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:16];
        
        //设置”添加图片“为默认的数据
        NSDictionary *defaultData = @{@"image":[UIImage imageNamed:@"添加图片"]};
        [_dataArray addObject:defaultData];
    }
}

- (void)setSubViews{
    //设置顶部的按钮
    [self setTopButton];
    
    [self setMediaPickerView];
    
    //设置下方的”项目标签“
//    [self setPostCategories];
}

- (void)setHideKeyboardEvent{
    //点击空白收起键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

#pragma -mark -设置选择图片、视频的collectionView
- (void)setMediaPickerView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];

    //行间距
    flow.minimumLineSpacing = 15;
    //列间距
    flow.minimumInteritemSpacing = 8;
    
    //cell大小设置
    flow.itemSize = CGSizeMake(96 * SCALE, 54 * SCALE);
    
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(17, 15, 10, 15);
    
    //滚动方向
    //           flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    _mediaCollcetionView = [[UICollectionView alloc]initWithFrame:self.mediaPickerView.bounds collectionViewLayout:flow];
    if (_mediaCollcetionView == nil) {
    _mediaCollcetionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 8, self.meidiaPickerViewHeight.constant) collectionViewLayout:flow];
    }
    
    _mediaCollcetionView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 8, self.meidiaPickerViewHeight.constant);
    _mediaCollcetionView.backgroundColor = [UIColor clearColor];
    _mediaCollcetionView.scrollEnabled = NO;
    [self.mediaPickerView addSubview:_mediaCollcetionView];
    
    _mediaCollcetionView.delegate = self;
    _mediaCollcetionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
    [_mediaCollcetionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}
#pragma -mark -添加新图片、视频
//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    NSData *data = _dataArray[indexPath.row][@"data"];
    if (data == nil) {
        NSLog(@"data是空，添加按钮被点击");
        //判断图片的张数和视频的个数，如果超出限制，则各处提示，不让继续添加
        if([self getImageCount] >= 10){
            [self showHUDWithMessage:@"图片最多为10张" isPop:NO];
            return;
        }
        if([self getVideoCount] >= 5){
            [self showHUDWithMessage:@"视频不能超过5个" isPop:NO];
            return;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍摄视频或照片", @"从本地选取视频或照片", nil];
        [actionSheet showInView:self.view];
        
    }
}

- (int )getImageCount{
    int imageCount = 0;
    for(NSDictionary *dic in _dataArray){
        if ([dic[@"type"] isEqualToString:@"image"]) {
            imageCount++;
        }
    }
    return imageCount;
}
- (int )getVideoCount{
    int videoCount = 0;
    for(NSDictionary *dic in _dataArray){
        if ([dic[@"type"] isEqualToString:@"video"]) {
            videoCount++;
        }
    }
    return videoCount;
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [self shootPictureOrVideo];
            break;
        }
            
        case 1:
        {
            [self selectExistsPictureOrVideo];
            break;
        }
        default:
            break;
    }
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

//拍照或拍摄视频
- (void)shootPictureOrVideo {
    [self pickMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//选择存在的媒体文件
#pragma -mark -处理选择的媒体文件
- (void)selectExistsPictureOrVideo {
    [self pickMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.lastChosenMediaType = info[UIImagePickerControllerMediaType];
    if ([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        
        //把获取的图片以字典方式添加进_dataArray
        NSDictionary *dic = @{@"image":chosenImage, @"data":UIImageJPEGRepresentation(chosenImage, 1), @"type":@"image"};
        [_dataArray insertObject:dic atIndex:_dataArray.count - 1];
        [self setHeightConstraint];
        [_mediaCollcetionView reloadData];
        
    }else if([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        NSData *movieData = [NSData dataWithContentsOfURL:videoURL];
        
        UIImage *chosenImage = [self getThumbnailImage:videoURL];
        
        //把选择的视频以字典方式添加进_dataArray
        NSDictionary *dic = @{@"image":chosenImage, @"data":movieData, @"type":@"video"};
        [_dataArray insertObject:dic atIndex:_dataArray.count - 1];
        [self setHeightConstraint];
        [_mediaCollcetionView reloadData];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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

- (void)setHeightConstraint{
    //图片行数
    float rowCount = (_dataArray.count - 1) / 3 + 1;
//    if (_dataArray.count > 15) {
//        rowCount--;
//    }
    //高度
    float height = 0;
    height = 38 + 54 * rowCount * SCALE + 15 * (rowCount- 1);
    NSLog(@"height : %f", height);
    _meidiaPickerViewHeight.constant = height;
    _mediaCollcetionView.height = height;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (_dataArray.count > 15) {
        return 15;
    }else{
        return _dataArray.count;
    }
    
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [UICollectionViewCell new];
    }
    cell.backgroundColor = [UIColor clearColor];
    //删除之前的imageview
    UIImageView *oldImageView = [cell viewWithTag:1000];
    if (oldImageView) {
        [oldImageView removeFromSuperview];
        oldImageView = nil;
    }
    //清除视频标记
    UIImageView *oldVideoFlagImageView = [cell viewWithTag:1001];
    if (oldVideoFlagImageView) {
        [oldVideoFlagImageView removeFromSuperview];
        oldVideoFlagImageView = nil;
    }
    //清除删除按钮
    UIButton *oldDeleteButton = [cell viewWithTag:1003];
    if (oldDeleteButton) {
        [oldDeleteButton removeFromSuperview];
        oldDeleteButton = nil;
    }
    
    //设置cell的图片
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:cell.bounds];

    [cell addSubview:imageView];
    NSDictionary *dic = _dataArray[indexPath.row];
    imageView.image = dic[@"image"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.tag = 1000;
    
    //如果是视频，则增加视频标记
    NSString *type = dic[@"type"];
    if ([type isEqualToString:@"video"]) {
        UIImageView *videoFlagImageView = [UIImageView new];
        videoFlagImageView.tag = 1001;
        videoFlagImageView.frame = CGRectMake(cell.width / 2 - 25 / 2, cell.height / 2 - 25 / 2, 25, 25);
        videoFlagImageView.image = [UIImage imageNamed:@"视频集锦用-小播放按钮"];
        [cell addSubview:videoFlagImageView];
    }
    
    //增加右上角的“删除”按钮
    if(type){
        UIButton *deleteButton = [[UIButton alloc]init];
        deleteButton.tag = 1003;
        deleteButton.frame = CGRectMake(cell.width - 18, 0, 18, 18);
        [deleteButton setImage:[UIImage imageNamed:@"弹出框用-类别选择-选中"] forState:UIControlStateNormal];

        objc_setAssociatedObject(deleteButton, @"index", [NSString stringWithFormat:@"%ld", indexPath.row], OBJC_ASSOCIATION_COPY_NONATOMIC);//给button赋值，用于传递点击cell的下标
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:deleteButton];
    }
    

    return cell;
}

- (void)deleteButtonClicked:(id)sender{
    NSString *indexStr = objc_getAssociatedObject(sender, @"index");
    NSLog(@"%@", indexStr);
    NSInteger index = [indexStr integerValue];
    [_dataArray removeObjectAtIndex:index];
    [self setHeightConstraint];
    [_mediaCollcetionView reloadData];
}

- (void)setPostCategories{
    NSLog(@"bottom : %f", self.contentTextView.bottom);
    FTSelectedCategoriesView *selectCategoriesView = [[FTSelectedCategoriesView alloc]initWithFrame:CGRectMake(4, self.contentTextViewContainer.bottom + 5, SCREEN_WIDTH - 4 * 2, 17 + 15 * 1 + 21)];
    [self.view addSubview:selectCategoriesView];
}

- (void)hideKeyboard{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated{
        //显示navigationBar
    self.navigationController.navigationBarHidden = NO;
    //注册键盘弹起、收回的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)keyBoardShow{
    NSLog(@"键盘弹出");
    if ([self.contentTextView isFirstResponder]) {
        CGRect rOfView = self.view.frame;
        rOfView.origin.y = -200;
        self.view.frame = rOfView;
    }
}
- (void)keyBoardHide{
    NSLog(@"键盘收回");
    CGRect rOfView = self.view.frame;
    rOfView.origin.y = 0;
    self.view.frame = rOfView;
}

- (void)setTopButton{
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
        [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置发布按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(newPostButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],UITextAttributeFont,
                                    nil];
    self.navigationItem.rightBarButtonItem = shareButton;
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
}
/**
 *  发布按钮被点击
 */
#pragma -mark -发新帖
- (void)newPostButtonClicked{
    [self hideKeyboard];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [FTQiniuNetwork getQiniuTokenWithOption:^(NSString *token) {
        NSLog(@"token : %@", token);
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        if (!_imageURLArray) {
            _imageURLArray = [[NSMutableArray alloc]initWithCapacity:10];
        }
        if (!_imageURLArray) {
            _videoURLArray = [[NSMutableArray alloc]initWithCapacity:5];
        }
        
        for(NSDictionary *dic in _dataArray){
            if (!dic[@"data"]) {
                break;
            }
            NSData *mediaData = dic[@"data"];
            NSString *userId = [FTUserTools getLocalUser].olduserid;
            NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
            NSString *key = [NSString stringWithFormat:@"%@%@", userId, ts];//key值取userId＋时间戳
            
            if([dic[@"type"] isEqualToString:@"image"]){
                [_imageURLArray addObject:key];
            }else if([dic[@"type"] isEqualToString:@"video"]){
                [_videoURLArray addObject:key];
            }
//            NSDictionary *optionDic = @{@"persistentOps":@"avthumb/mp4"};
            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:nil params:@{@"persistentOps":@"avthumb/mp4"} checkCrc:NO cancellationSignal:nil];
            
            [upManager putData:mediaData key:key token:token
                      complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//                          NSLog(@"info : %@", info);
                          NSString *status = [NSString stringWithFormat:@"%d", info.statusCode];
                          NSLog(@"info status : %@", status);
                          NSLog(@"resp : %@", resp);
                          NSLog(@"key : %@", key);
                          
                      } option:option];
        }
        
        //把数据上传到格斗家的服务器上
        [self uploadPostsToServer];

    }];


}

- (void)uploadPostsToServer{
    
    FTArenaNetwork *arenaNetwork = [FTArenaNetwork new];
    FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
    
    NSString *userId = localUser.olduserid;
    NSString *loginToken = localUser.token;
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];
    NSString *title = self.titleTextField.text;
    NSString *content = self.contentTextView.text;
    NSString *tableName = @"damageblog";
    NSString *nickname = localUser.username;
    NSString *headUrl = localUser.headpic;
    NSString *urlPrefix = @"http://7xtvwy.com1.z0.glb.clouddn.com";
    NSString *pictureUrlNames = @"";
    if (_imageURLArray.count > 0) {
            pictureUrlNames = [_imageURLArray componentsJoinedByString:@","];
    }
    
    NSString *videoUrlNames  = @"";
    if (_videoURLArray.count > 0) {
        videoUrlNames= [_videoURLArray componentsJoinedByString:@","];
    }
    
    NSString *thumbUrl = @"";
    NSString *labels = @"Boxing";
    
    //    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", content, headUrl, loginToken,nickname,pictureUrlNames,tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@", content, labels, loginToken,pictureUrlNames,tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    
    NSDictionary *dic = @{
                          @"userId":userId,
                          @"loginToken":loginToken,
                          @"ts":ts,
                          @"title":title,
                          @"content":content,
                          @"tableName":tableName,
                          //                          @"nickname":nickname,
                          //                          @"headUrl":headUrl,
                          @"urlPrefix":urlPrefix,
                          @"pictureUrlNames":pictureUrlNames,
                          @"videoUrlNames":videoUrlNames,
                          @"thumbUrl":thumbUrl,
                          @"labels":labels,
                          @"checkSign":checkSign
                          };
    
    [arenaNetwork newPostWithDic:dic andOption:^(NSDictionary *dict) {
        NSLog(@"status : %@, message : %@", dict[@"status"], dict[@"message"]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([dict[@"status"] isEqualToString:@"success"]) {
            [self showHUDWithMessage:dict[@"发布成功"]isPop:YES];
        }else{
            [self showHUDWithMessage:dict[@"message"]isPop:NO];
        }
    }];
}
- (void)showHUDWithMessage:(NSString *)message isPop:(BOOL)isPop{
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES whileExecutingBlock:^{
        sleep(2);
    } completionBlock:^{
        [HUD removeFromSuperview];
        if (isPop) {
            [self popVC];
//            [self.delegate commentSuccess];
        }
        
        //        HUD = nil;
    }];
}
#pragma -mark -添加标签按钮被点击
- (IBAction)addLabelButtonClicked:(id)sender {
    
}

- (void)popVC{
//    [self.delegate updateCountWithNewsBean:_newsBean indexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
