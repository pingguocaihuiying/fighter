//
//  FTGymPhotosViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymPhotosViewController.h"
#import "FTGymPhotoCollectionViewCell.h"
#import <MediaPlayer/MediaPlayer.h>

typedef NS_ENUM(int, FTGymPhotoIndex){
    FTGymPhotoIndexByGym = 0,
    FTGymPhotoIndexByUser
};

@interface FTGymPhotosViewController ()<UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

//头部二选标签
@property (strong, nonatomic) IBOutlet UIButton *gymPhotosButton;//左
@property (strong, nonatomic) IBOutlet UIButton *PhotosByUsersButton;//右
@property (strong, nonatomic) IBOutlet UIImageView *bgImageView;//背景

@property (strong, nonatomic) IBOutlet UIView *mainView;

@property (nonatomic, strong) UIScrollView *scrollView;//显示图片列表的scrollView

@property (nonatomic, assign) FTGymPhotoIndex photoIndex;

//scrollView content的宽高
@property (nonatomic, assign) CGFloat scrollViewContentWidth;
@property (nonatomic, assign) CGFloat scrollViewContentHeight;

//两个放照片的collectionView
@property (nonatomic, strong) UICollectionView *photoCollectionViewLeft;
@property (nonatomic, strong) UICollectionView *photoCollectionViewRight;

//collectionView的源数据
@property (nonatomic, strong) NSMutableArray *photoArrayByGym;
@property (nonatomic, strong) NSMutableArray *photoArrayByUser;

@property (nonatomic, strong) UIScrollView *fullScreenScrollView;//全屏显示照片或视频的collectionView

@property (nonatomic, strong)MPMoviePlayerController *moviePlayer;//播放器

@end

@implementation FTGymPhotosViewController


- (void)viewDidDisappear:(BOOL)animated{
    [_fullScreenScrollView removeFromSuperview];
}
//getPhotosByUsersWithCorporationid
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self loadUserPhotoDataFromServer];
    [self setSubViews];
}

- (void)initBaseData{
    _photoIndex = FTGymPhotoIndexByGym;//默认选中的为拳馆照片
    
    //定义scrollView的宽高
    _scrollViewContentWidth = SCREEN_WIDTH;
    _scrollViewContentHeight = SCREEN_HEIGHT - 64 - 5 - 35 - 10;
    
    [self initPhotosArray];//初始化照片数据源
    
}

- (void)loadUserPhotoDataFromServer{
    [NetWorking getPhotosByUsersWithCorporationid:[NSString stringWithFormat:@"%d", _gymDetailBean.id] andOption:^(NSArray *array) {
        [self setUserPhotoArrayWith:array];
    }];
}

- (void)initPhotosArray{
    _photoArrayByGym = [NSMutableArray new];
    _photoArrayByUser = [NSMutableArray new];
    
    //把图片地址放入_photoArrayByGym
    NSArray *imagesArrayLeft = _gymDetailBean.gymImgs;
    if (imagesArrayLeft && [imagesArrayLeft isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < imagesArrayLeft.count; i++) {
            NSLog(@"imagesArrayLeft %d : %@", i, imagesArrayLeft[i]);
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setValue:@"image" forKey:@"type"];
            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", QiniuDomain, imagesArrayLeft[i]];
            [dic setValue:imageUrl forKey:@"imageurl"];
            NSLog(@"left imageUrl : %@", imageUrl);
            [_photoArrayByGym addObject:dic];
        }
    }
    
    //把视频地址追加入_photoArrayByGym
    NSArray *videoArrayLeft = _gymDetailBean.gymVideos;
    if (videoArrayLeft && [videoArrayLeft isKindOfClass:[NSArray class]]) {
        for (int i = 0; i < videoArrayLeft.count; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary new];
            [dic setValue:@"video" forKey:@"type"];//类型
            NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", QiniuDomain, videoArrayLeft[i]];
            NSString *imageUrl = [NSString stringWithFormat:@"%@?vframe/png/offset/0", videoUrl];
            [dic setValue:imageUrl forKey:@"imageurl"];//图片地址
            
            [dic setValue:videoUrl forKey:@"videourl"];//视频地址
            NSLog(@"left videoUrl : %@", videoUrl);
            [_photoArrayByGym addObject:dic];
        }
    }
}

- (void)setSubViews{
    [self setNavigationSytle];
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    [self setPhotoScrollView];//设置放collectionView的scrollview
    [self setCollectionViews];//设置显示照片的两个collectionView
    [self setFullScreenScrollView];//设置全屏显示照片和视频的collectionView
}

//设置用户上传图片的数据源
- (void)setUserPhotoArrayWith:(NSArray *)array{
    for ( int i = 0; i < array.count; i++) {
        NSDictionary *dicSrc = array[i];
        NSMutableDictionary *dic = [NSMutableDictionary new];
        if ([dicSrc[@"suffix"] isEqualToString:@"0"]) {//suffix 0 是图片，1是视频
            
            NSLog(@"url:%@",dicSrc[@"url"]);
            [dic setValue:@"image" forKey:@"type"];//类型
            NSString *imageUrl = [NSString stringWithFormat:@"%@/%@", QiniuDomain, dicSrc[@"url"]];
            
            imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"imageUrl : %@", imageUrl);
            [dic setValue:imageUrl forKey:@"imageurl"];//图片地址
        } else if ([dicSrc[@"suffix"] isEqualToString:@"1"]) {
            [dic setValue:@"video" forKey:@"type"];//类型
            NSString *videoUrl = [NSString stringWithFormat:@"%@/%@", QiniuDomain, dicSrc[@"url"]];
            NSString *imageUrl = [NSString stringWithFormat:@"%@?vframe/png/offset/0", videoUrl];
            imageUrl = [imageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dic setValue:imageUrl forKey:@"imageurl"];//图片地址
            videoUrl = [videoUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [dic setValue:videoUrl forKey:@"videourl"];//视频地址
            NSLog(@"videoUrl : %@", videoUrl);
        }
        [_photoArrayByUser addObject:dic];

    }
    [_photoCollectionViewRight reloadData];
}

// 设置导航栏
- (void) setNavigationSytle {
    
    //设置默认标题
    self.navigationItem.title = _gymDetailBean.gym_name;
    
    // 导航栏字体和背景
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(backBtnAction:)];
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    // 导航栏转发按钮
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"学员列表-更多"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(moreBtnAction:)];
//    self.navigationItem.rightBarButtonItem = shareButton;
    
    
}

#pragma mark - 初始化scrollView
- (void)setPhotoScrollView{
    
    _scrollView = [UIScrollView new];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.frame = CGRectMake(0, 0, _scrollViewContentWidth, _scrollViewContentHeight);//set frame
    _scrollView.contentSize = CGSizeMake(_scrollViewContentWidth * 2, _scrollViewContentHeight);//内容的宽高
    _scrollView.pagingEnabled = YES;//整页滚动
    _scrollView.bounces = NO;//禁用弹簧效果
    _scrollView.delegate = self;
    [_mainView addSubview:_scrollView];
}

- (void)setCollectionViews{
    //flowlayout
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
    
//    float itemWidth = 
    
    flow.itemSize = CGSizeMake(80 * SCALE, 80 * SCALE);//cell大小
    flow.minimumLineSpacing = 15 * SCALE;//行最小间距
    flow.minimumInteritemSpacing = 0;//列最小间距
    
    //left
    _photoCollectionViewLeft = [[UICollectionView alloc]initWithFrame:CGRectMake(20 * SCALE, 0, _scrollViewContentWidth - 20 * 2 *SCALE, _scrollViewContentHeight)collectionViewLayout:flow];
    [_photoCollectionViewLeft registerNib:[UINib nibWithNibName:@"FTGymPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell1"];//FooCollectionViewCell
    _photoCollectionViewLeft.backgroundColor = [UIColor clearColor];
    _photoCollectionViewLeft.delegate = self;
    _photoCollectionViewLeft.dataSource = self;
    [_scrollView addSubview:_photoCollectionViewLeft];
    
    //right
    //flowlayout2
    UICollectionViewFlowLayout *flow2 = [[UICollectionViewFlowLayout alloc]init];
    flow2.itemSize = CGSizeMake(80 * SCALE, 80 * SCALE);//cell大小
    flow2.minimumLineSpacing = 15 * SCALE;//行最小间距
    flow2.minimumInteritemSpacing = 0;//列最小间距
    _photoCollectionViewRight = [[UICollectionView alloc]initWithFrame:CGRectMake(_scrollViewContentWidth + 20 * SCALE, 0, _scrollViewContentWidth - 20 * 2 *SCALE, _scrollViewContentHeight)collectionViewLayout:flow2];
    [_photoCollectionViewRight registerNib:[UINib nibWithNibName:@"FTGymPhotoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell2"];

    _photoCollectionViewRight.backgroundColor = [UIColor clearColor];
    _photoCollectionViewRight.delegate = self;
    _photoCollectionViewRight.dataSource = self;
    [_scrollView addSubview:_photoCollectionViewRight];
}

- (void)setFullScreenScrollView{
    _fullScreenScrollView = [UIScrollView new];
    _fullScreenScrollView.frame = [UIScreen mainScreen].bounds;
    _fullScreenScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _photoArrayByGym.count , SCREEN_HEIGHT);
    [self setFullScreenScrollViewContents];
    _fullScreenScrollView.pagingEnabled = YES;
    _fullScreenScrollView.delegate = self;
    _fullScreenScrollView.hidden = YES;
    _fullScreenScrollView.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:_fullScreenScrollView];
    
    //添加手势，单点隐藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(fullScreenScrollViewTap:)];
    [_fullScreenScrollView addGestureRecognizer:tap];
}

- (void)fullScreenScrollViewTap:(id)sender{
    _fullScreenScrollView.hidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    _moviePlayer.contentURL = [NSURL URLWithString:@""];
}

- (void)setFullScreenScrollViewContents{
    //移除残留的subimageviews，把播放器从视野中移除，避免重叠
    NSArray *subviewsArray = [_fullScreenScrollView subviews];
    for(UIView *subview in subviewsArray){
        if ([subview isKindOfClass:[UIImageView class]]) {
                [subview removeFromSuperview];
        }else if (subview.tag == 9527){
            CGRect r = subview.frame;
            r.origin.x = -1000;
            subview.frame = r;
        }
        
    }
    
    NSInteger number = 0;
    NSArray *photoArray;
    if (_photoIndex == FTGymPhotoIndexByGym) {
        number = _photoArrayByGym.count;
        photoArray = _photoArrayByGym;
    } else if (_photoIndex == FTGymPhotoIndexByUser) {
        number = _photoArrayByUser.count;
        photoArray = _photoArrayByUser;
    }
    _fullScreenScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * photoArray.count, SCREEN_HEIGHT);
    for (int i = 0; i < number; i++) {
        NSDictionary *photoDic = photoArray[i];
        if ([photoDic[@"type"] isEqualToString:@"image"]) {
            UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            photoImageView.contentMode = UIViewContentModeScaleAspectFit;
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:photoDic[@"imageurl"]]];
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:photoDic[@"imageurl"]] placeholderImage:[UIImage imageNamed:@"小占位图"]];
            [_fullScreenScrollView addSubview:photoImageView];
        } else if ([photoDic[@"type"] isEqualToString:@"video"]){
            //初始化播放器(只初始化一次)
            if ( !_moviePlayer) {
                NSURL *url = [NSURL URLWithString:photoDic[@"videourl"]];
                _moviePlayer = [[MPMoviePlayerController alloc]initWithContentURL:url];
                _moviePlayer.view.frame = CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                _moviePlayer.view.tag = 9527;
                [_fullScreenScrollView addSubview:_moviePlayer.view];
                
                //配置属性
                
                //是否自动播放
                _moviePlayer.shouldAutoplay = NO;
                [_moviePlayer prepareToPlay];
                _moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
                [_moviePlayer.view.subviews firstObject].gestureRecognizers = nil;//去掉播放器的默认手势
                //设置播放器的样式
                _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
                //开始播放
//                [_moviePlayer play];

            }
        }

    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger number = 0;
    if (collectionView == _photoCollectionViewLeft) {
        number = _photoArrayByGym.count;
        NSLog(@"left number %ld", number);
        
    } else if (collectionView == _photoCollectionViewRight){
        number = _photoArrayByUser.count;
        NSLog(@"right number %ld", number);
    }
    
    return number;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTGymPhotoCollectionViewCell *cell;
    if (collectionView == _photoCollectionViewLeft) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell1" forIndexPath:indexPath];

        NSDictionary *dic = _photoArrayByGym[indexPath.row];
        NSString *imgURLString = dic[@"imageurl"];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:imgURLString] placeholderImage:[UIImage imageNamed:@"小占位图"]];
        if ([dic[@"type"] isEqualToString:@"video"]) {
            cell.isVideoView.hidden = NO;
        } else {
            cell.isVideoView.hidden = YES;
        }
    }else if (collectionView == _photoCollectionViewRight){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell2" forIndexPath:indexPath];
        NSDictionary *dic = _photoArrayByUser[indexPath.row];
        NSString *imgURLString = dic[@"imageurl"];
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"imageurl"]] placeholderImage:[UIImage imageNamed:@"小占位图"]];
        if ([dic[@"type"] isEqualToString:@"video"]) {
            cell.isVideoView.hidden = NO;
        } else {
            cell.isVideoView.hidden = YES;
        }
    }
    cell.backgroundColor = [UIColor clearColor]; //FooCollectionViewCell
//    FooCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate) {//如果有惯性，此处不处理，留在『惯性结束』中处理
        
    }else{//如果拖拽完成后没有惯性，说明已经停止滚动，需要处理
        NSLog(@"结束拖拽，没有惯性");
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSLog(@"减速结束");
    if (scrollView == _scrollView) {
        
        if (scrollView.contentOffset.x == 0) {
            _photoIndex = FTGymPhotoIndexByGym;
        }else if (scrollView.contentOffset.x == _scrollViewContentWidth){
            _photoIndex = FTGymPhotoIndexByUser;
        }
        [self updatePhotoIndexButtons];
    } else if (scrollView == _fullScreenScrollView) {
        NSLog(@"full scrollview content offset x : %f", scrollView.contentOffset.x);
        NSArray *photoArray = _photoIndex == FTGymPhotoIndexByGym ? _photoArrayByGym : _photoArrayByUser;
        NSInteger offsetX = scrollView.contentOffset.x / SCREEN_WIDTH;
        if ([photoArray[offsetX][@"type"] isEqualToString:@"video"]) {
            [self updateFullScreenScrollViewDisplayWithRow:offsetX andPhotoArray:photoArray];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _photoCollectionViewLeft || collectionView == _photoCollectionViewRight) {
        NSLog(@"left : %ld", indexPath.row);
        _fullScreenScrollView.hidden = NO;
        [UIApplication sharedApplication].statusBarHidden = YES;
        NSArray *photoArray = _photoIndex == FTGymPhotoIndexByGym ? _photoArrayByGym : _photoArrayByUser;
        
        [_fullScreenScrollView setContentOffset:CGPointMake(_scrollViewContentWidth * indexPath.row, 0) animated:NO];//点击后调整scrollView的便宜位置使之与点击的cell对应
        if ([photoArray[indexPath.row][@"type"] isEqualToString:@"video"]) {
            [self updateFullScreenScrollViewDisplayWithRow:indexPath.row andPhotoArray:photoArray];
        }
        
    } else {

    }
}

- (void)updateFullScreenScrollViewDisplayWithRow:(NSInteger)row andPhotoArray:(NSArray *)photoArray{
    _moviePlayer.contentURL = [NSURL URLWithString:photoArray[row][@"videourl"]];
    _moviePlayer.view.frame = CGRectMake(SCREEN_WIDTH * row, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    [_moviePlayer play];
}


- (void)moreBtnAction:(id)sender{
    NSLog(@"更多");
}

- (void)backBtnAction:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击左边按钮
- (IBAction)gymPhotosButtonClicked:(id)sender {
    if (_photoIndex != FTGymPhotoIndexByGym) {
        _photoIndex = FTGymPhotoIndexByGym;
        [self updatePhotoIndexButtons];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self setFullScreenScrollViewContents];
    }

}

#pragma mark - 点击右边按钮
- (IBAction)userPhotosButtonClicked:(id)sender {
    if (_photoIndex != FTGymPhotoIndexByUser) {
    _photoIndex = FTGymPhotoIndexByUser;
    [self updatePhotoIndexButtons];
    [_scrollView setContentOffset:CGPointMake(_scrollViewContentWidth, 0) animated:YES];
    [self setFullScreenScrollViewContents];
    }
}

#pragma mark - 更新上方筛选按钮的显示
- (void)updatePhotoIndexButtons{
    
    switch (_photoIndex) {
        case FTGymPhotoIndexByGym:
            {
                _gymPhotosButton.selected = YES;
                _PhotosByUsersButton.selected = NO;
                _bgImageView.image = [UIImage imageNamed:@"二标签-左选中"];
            }
            break;
        case FTGymPhotoIndexByUser:
        {
            _gymPhotosButton.selected = NO;
            _PhotosByUsersButton.selected = YES;
            _bgImageView.image = [UIImage imageNamed:@"二标签-右选中"];
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
