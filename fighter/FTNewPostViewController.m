//
//  FTNewPostViewController.m
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTNewPostViewController.h"
#import "FTArenaNetwork.h"
#import "FTQiniuNetwork.h"
#import "QiniuSDK.h"
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import <objc/runtime.h>
#import "FTArenaChooseLabelView.h"

@interface FTNewPostViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, FTArenaChooseLabelDelegate>
@property (nonatomic, strong)UICollectionView *mediaCollcetionView;
@property (nonatomic, strong)NSMutableArray *dataArray;

@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSURL *movieURL;
@property (nonatomic, strong)NSString *lastChosenMediaType;

@property (nonatomic, strong)NSMutableArray *imageURLArray;
@property (nonatomic, strong)NSMutableArray *videoURLArray;
@property (nonatomic, strong)FTArenaChooseLabelView *chooseLabelView;
@property (nonatomic, strong)NSString *typeOfLabel;//选择的标签
@property (nonatomic, assign) BOOL isSyncToArena;
@property (strong, nonatomic) IBOutlet UIView *labelTypeView;

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

- (void)viewDidAppear:(BOOL)animated{
    //设置scrollView的contentSize
        _scrollView.contentSize = CGSizeMake(0, 750);
    
}
- (void)initBaseData{

    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]initWithCapacity:16];
        
        //设置”添加图片“为默认的数据
        NSDictionary *defaultData = @{@"image":[UIImage imageNamed:@"添加图片"]};
        [_dataArray addObject:defaultData];
    }
    
    //默认不显示同步选项
//    _isShowSyncView = NO;
    //是否同步到格斗场，默认为是
    if (_isShowSyncView) {
        _isSyncToArena = NO;
        [self refreshSyncButton];
    }else{
        _isSyncToArena = YES;
    }
    
}

- (void)setSubViews{
    if (_moduleBean) {
        _labelTypeView.hidden = YES;
        _typeOfLabel = _moduleBean.name;
    }
    
    //去掉底部的遮罩层
    self.bottomGradualChangeView.hidden = YES;
    //设置顶部的按钮
    [self setTopButton];
    
    [self setMediaPickerView];
    
    //设置titleTextField的placeHold属性
    // 描述占位文字属性
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor colorWithHex:0xb4b4b4];
    //富文本属性
    NSAttributedString *acountPlaceholder = [[NSAttributedString alloc] initWithString:@"添加一个拉风的标题..." attributes:attr];
    [_titleTextField setAttributedPlaceholder:acountPlaceholder];
    
    //是否同步到格斗场
    if (_isShowSyncView) {
        _syncView.hidden = NO;
    }else{
        _syncView.hidden = YES;
    }
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
    
    NSLog(@"%ld, %ld", (long)indexPath.section, indexPath.row);
    NSData *data = _dataArray[indexPath.row][@"data"];
    if (data == nil) {
        //data是空
        NSLog(@"添加按钮被点击");

        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"拍摄视频或照片", @"从本地选取视频或照片", nil];
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
        //判断图片的张数和视频的个数，如果超出限制，则各处提示，不让继续添加
        if([self getImageCount] >= 10){
            [self showHUDWithMessage:@"图片最多为10张" withImagePickerController:picker  isDismiss:YES];
            return;
        }
        UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
        
        //把获取的图片以字典方式添加进_dataArray
        NSDictionary *dic = @{@"image":chosenImage, @"data":UIImageJPEGRepresentation(chosenImage, 1), @"type":@"image"};
        [_dataArray insertObject:dic atIndex:_dataArray.count - 1];
        [self setHeightConstraint];
        [_mediaCollcetionView reloadData];
        
    }else if([self.lastChosenMediaType isEqualToString:(NSString *)kUTTypeMovie]){

        NSLog(@"视频数量:%d", [self getVideoCount]);
        if([self getVideoCount] >= 5){
            [self showHUDWithMessage:@"视频不能超过5个" withImagePickerController:picker isDismiss:YES];
            return;
        }

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


-(UIImage *)getThumbnailImage:(NSURL *)videoURL {
    
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
        [deleteButton setImage:[UIImage imageNamed:@"selected_del"] forState:UIControlStateNormal];

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
        rOfView.origin.y = -136;
        self.view.frame = rOfView;
    }
}
- (void)keyBoardHide{
    NSLog(@"键盘收回");
    CGRect rOfView = self.view.frame;
    rOfView.origin.y = 64;
    self.view.frame = rOfView;
}

- (void)setTopButton{
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置发布按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(newPostButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
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
    if (_typeOfLabel == nil || [_typeOfLabel isEqualToString:@""] ) {
        [self showHUDWithMessage:@"请先选择一个项目分类" isPop:NO];
        return;
    }
    
    //限制标题的长度
    NSString *titleContent = self.titleTextField.text;
    titleContent = [titleContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (titleContent.length < 6) {
        [self showHUDWithMessage:@"标题长度不能少于6个字" isPop:NO];
        return;
    }
    
    //限制内容不能为空
    NSString *content = self.titleTextField.text;
    content = [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (content.length < 1) {
        [self showHUDWithMessage:@"帖子内容不能为空" isPop:NO];
        return;
    }
    [self hideKeyboard];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    for(NSDictionary *dic in _dataArray){
        if(!dic[@"data"]){
            [_dataArray removeObject:dic];
        }
    }
    
    for(NSDictionary *dic in _dataArray){
        if (!_imageURLArray) {
            _imageURLArray = [[NSMutableArray alloc]initWithCapacity:10];
        }
        if (!_videoURLArray) {
            _videoURLArray = [[NSMutableArray alloc]initWithCapacity:5];
        }
        NSData *mediaData = dic[@"data"];
        NSString *userId = [FTUserTools getLocalUser].olduserid;
//        NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        NSString *key;
        
        NSString *type = dic[@"type"];
        NSLog(@"type : %@", type);
        //视频的key值要加上mp4作为后缀

        NSString *timeString = [self fixStringForDate:[NSDate date]];
        if([type isEqualToString:@"image"]){
                        key = [NSString stringWithFormat:@"%@_%@",timeString, userId];//key值取userId＋时间戳
        }else if([type isEqualToString:@"video"]){
//            key = [NSString stringWithFormat:@"%@%@mp4", userId, ts];//key值取userId＋时间戳+mp4
            key = [NSString stringWithFormat:@"%@_%@mp4",timeString, userId];//key值取userId＋时间戳+mp4
        }
        
        if([type isEqualToString:@"image"]){
            [_imageURLArray addObject:key];
        }else if([type isEqualToString:@"video"]){
            [_videoURLArray addObject:key];
        }
        
        [FTQiniuNetwork getQiniuTokenWithMediaType:dic[@"type"] andKey:key andOption:^(NSString *token) {//***获取token
        NSLog(@"token : %@", token);
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];



//            NSDictionary *optionDic = @{@"persistentOps":@"avthumb/mp4"};
//            QNUploadOption *option = [[QNUploadOption alloc]initWithMime:nil progressHandler:nil params:nil checkCrc:NO cancellationSignal:nil];
            
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
    [self uploadPostsToServer];
}

- (NSString *)fixStringForDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    NSString *fixString = [dateFormatter stringFromDate:date];
    return fixString;
}

- (void)uploadPostsToServer{
    
    FTArenaNetwork *arenaNetwork = [FTArenaNetwork new];
    FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
    
    NSString *userId = localUser.olduserid;
    NSString *loginToken = localUser.token;
    NSString *ts = [NSString stringWithFormat:@"%f", [[NSDate date]timeIntervalSince1970]];
    NSString *title = self.titleTextField.text;
    if (title == nil || [title isEqualToString:@""]) {
        [self showHUDWithMessage:@"标题不能为空" isPop:NO];
    }
    
    //如果是训练视频，限制必须传视频
    if ([_typeOfLabel isEqualToString:@"Train"]) {
        if (!_videoURLArray || _videoURLArray.count < 1) {
            [self showHUDWithMessage:@"选择训练标签需要上传视频" isPop:NO];
        }
    }
    
    NSString *content = self.contentTextView.text;
    NSString *tableName = @"damageblog";
//    NSString *nickname = localUser.username;
//    NSString *headUrl = localUser.headpic;
    NSString *urlPrefix = @"7xtvwy.com1.z0.glb.clouddn.com";
    NSString *pictureUrlNames = @"";
    if (_imageURLArray.count > 0) {
            pictureUrlNames = [_imageURLArray componentsJoinedByString:@","];
    }
    
    NSString *videoUrlNames  = @"";
    if (_videoURLArray.count > 0) {
        videoUrlNames= [_videoURLArray componentsJoinedByString:@","];
    }
    
    NSString *thumbUrl = @"";
    NSString *labels = _typeOfLabel;
    
    //    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", content, headUrl, loginToken,nickname,pictureUrlNames,tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@", content, labels, loginToken,pictureUrlNames, _isSyncToArena ? @"1" : @"", tableName,thumbUrl,title,ts,urlPrefix,userId,videoUrlNames ,NewPostCheckKey]];
    
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
                          @"checkSign":checkSign,
                          @"source":_isSyncToArena ? @"1" : @""// 同步为1，不同步为空
                          };
    
    [arenaNetwork newPostWithDic:dic andOption:^(NSDictionary *dict) {
        NSLog(@"status : %@, message : %@", dict[@"status"], dict[@"message"]);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([dict[@"status"] isEqualToString:@"success"]) {
            
            NSLog(@"帖子发成功了");
            [self showHUDWithMessage:@"发布成功"isPop:YES];
        }else{
            [self showHUDWithMessage:dict[@"message"]isPop:NO];
        }
    }];
}
//[self showHUDWithMessage:@"视频不能超过2个" isPop:NO withImagePickerController:picker isDismiss:YES];
- (void)showHUDWithMessage:(NSString *)message withImagePickerController:(UIImagePickerController *)picker isDismiss:(BOOL)isDismiss{
    if (isDismiss) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
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
#pragma -mark - 添加标签按钮被点击
- (IBAction)addLabelButtonClicked:(id)sender {
    


    
    if (_chooseLabelView == nil) {
     _chooseLabelView = [[FTArenaChooseLabelView alloc]init];
        
        
        //如果用户有identity字段，则说明不是普通用户（是拳手或教练）
        FTUserBean *localUser = [FTUserTools getLocalUser];//获取本地用户
        
        
        if (localUser.identity) {
            _chooseLabelView.isBoxerOrCoach = YES;
        }
        _chooseLabelView.delegate = self;
        [self.view addSubview:_chooseLabelView];
    }else{
        _chooseLabelView.hidden = NO;
    }
}


- (void)popVC{
//    [self.delegate updateCountWithNewsBean:_newsBean indexPath:self.indexPath];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark - 处理选择标签的回调
- (void)chooseLabel:itemValueEn{
    NSLog(@"itemValueEn: %@", itemValueEn);
    
    if (![itemValueEn isEqualToString:@""]) {
        _typeImageView.hidden = NO;
        _typeOfLabel = itemValueEn;
        _typeImageView.image = [UIImage imageNamed:[FTTools getChLabelNameWithEnLabelName:itemValueEn]];
        [_addLabelButton setImage:[UIImage imageNamed:@"修改标签"] forState:UIControlStateNormal];
    }
    _chooseLabelView.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)syncButtonClicked:(id)sender {//是否同步按钮被点击后，改变值，刷新界面显示
    _isSyncToArena = !_isSyncToArena;
    [self refreshSyncButton];
}
- (void)refreshSyncButton{

    [_syncButton setBackgroundImage:[UIImage imageNamed:_isSyncToArena ? @"弹出框用-类别选择-选中" : @"弹出框用-类别选择-空"] forState:UIControlStateNormal];

}
@end
