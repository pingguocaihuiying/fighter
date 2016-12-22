//
//  FTCoachPhotosDetailViewController.m
//  fighter
//
//  Created by 李懿哲 on 20/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachPhotosDetailViewController.h"

#import "FTSegmentButtonView.h"
#import "FTVideoCollectionViewCell.h"
#import "FTCoachVideoViewController.h"
#import "FTUserCommentOfCoachTableViewCell.h"
#import "FTShareView.h"
#import "FTCoachsCommentByUserBean.h"

@interface FTCoachPhotosDetailViewController ()<FTSegmentButtonViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) FTSegmentButtonView *segButtonView;//三选按钮
@property (strong, nonatomic) IBOutlet UIView *segButtonViewContainer;//三选按钮容器view
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) UIScrollView *fullScreenScrollView;//全屏显示照片的collectionView

@property (strong, nonatomic) IBOutlet UIView *mainView;
//scrollView content的宽高
@property (nonatomic, assign) CGFloat scrollViewContentWidth;
@property (nonatomic, assign) CGFloat scrollViewContentHeight;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *commentsBeanArray;
@property (nonatomic, assign) int pageNum;//当前评论的页数
@end

@implementation FTCoachPhotosDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];//初始化基本数据（配置）
    [self initSubViews];//设置subViews
    [self updateDisplay];//更新数据（UI）
}

#pragma mark -初始化基本数据（配置）
- (void)initBaseData{
    //定义scrollView的宽高
    _scrollViewContentWidth = SCREEN_WIDTH;
    _scrollViewContentHeight = SCREEN_HEIGHT - 64 - 5 - 35 - 10;
    _pageNum = 1;
}

#pragma mark -初始化subViews
- (void)initSubViews{
    [self initNaviViews];//初始化导航栏
    [self initSegmentButtonView];//设置多选按钮
    [self initCollectionView];//初始化collectionView
    [self setFullScreenScrollView];//初始化全屏显示的scrollView
    [self initTableView];//初始化教练的评分列表
}

- (void)updateDisplay{
    switch (_index) {
        case 0:
            [self leftButtonClicked];
            _segButtonView.buttonLeft.selected = YES;
            _segButtonView.buttonMiddle.selected = NO;
            _segButtonView.buttonRight.selected = NO;
            break;
        case 1:
            [self middleButtonClicked];
            _segButtonView.buttonLeft.selected = NO;
            _segButtonView.buttonMiddle.selected = YES;
            _segButtonView.buttonRight.selected = NO;
            break;
        case 2:
            [self rightButtonClicked];
            _segButtonView.buttonLeft.selected = NO;
            _segButtonView.buttonMiddle.selected = NO;
            _segButtonView.buttonRight.selected = YES;
            break;
        default:
            break;
    }
}

- (void)initNaviViews{
    self.navigationItem.title = @"私教详情";
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked)];
    rightButtonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}


- (void)rightBarButtonItemClicked{
    FTShareView *shareView = [FTShareView new];
    
    //分享标题: “教练名 - 拳馆名“
    NSString *title = [NSString stringWithFormat:@"%@ - %@", _coachBean.name, _gymName];
    
    NSString *_webUrlString = [NSString stringWithFormat:@"%@?userId=%@", HomepageCoachWebViewURL, _coachBean.userId];//链接地址
    
    //分享简述
    [shareView setTitle:title];
    [shareView setSummary:_coachBean.brief];
    [shareView setImageUrl:_coachBean.headUrl];
    [shareView setUrl:_webUrlString];
    
    [self.view addSubview:shareView];
}
- (void)initSegmentButtonView{
    _segButtonView = [[[NSBundle mainBundle]loadNibNamed:@"FTSegmentButtonView" owner:self options:nil] firstObject];
    _segButtonView.frame = _segButtonViewContainer.bounds;
    [_segButtonView setButtonCount:3];
    //设置按钮title
    [_segButtonView.buttonLeft setTitle:@"教练相册" forState:UIControlStateNormal];
    [_segButtonView.buttonMiddle setTitle:@"教学视频" forState:UIControlStateNormal];
    [_segButtonView.buttonRight setTitle:@"学员评价" forState:UIControlStateNormal];
    
    _segButtonView.delegate = self;//设置代理
    
    [_segButtonViewContainer addSubview:_segButtonView];
}

- (void)leftButtonClicked{
    _index = 0;
    _beanArray = _photoArray;
    _tableView.hidden = YES;
    _collectionView.hidden = NO;
    [_collectionView reloadData];
}

- (void)middleButtonClicked{
    _index = 1;
    _beanArray = _videoArray;
    _tableView.hidden = YES;
    _collectionView.hidden = NO;
    
    [_collectionView reloadData];
}
- (void)rightButtonClicked{
    _index = 2;
    _collectionView.hidden = YES;
    _tableView.hidden = NO;
    [self loadUserCommentFromServer];
}
- (void)setCollectionView
{
    if (self.collectionView == nil) {
        [self initCollectionView];
    }
}
- (void)initCollectionView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
    //    flow.minimumLineSpacing = 15 * SCALE;
    //列间距
    flow.minimumInteritemSpacing = 16 * SCALE;
    
    
    float width = 164 * SCALE;
//    float height = 143 * SCALE;
    float height = 116 * SCALE;
    flow.itemSize = CGSizeMake(width, height);
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 109) collectionViewLayout:flow];
    _collectionView.backgroundColor = [UIColor clearColor];
    CGRect r = _collectionView.frame;
    r.size.width = SCREEN_WIDTH;
    _collectionView.frame = r;
    
    [_mainView addSubview:_collectionView];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
    [_collectionView registerNib:[UINib nibWithNibName:@"FTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    FTCoachPhotoBean *bean = _beanArray[indexPath.row];
    if (_index == 0) {
        
        _fullScreenScrollView.hidden = NO;
        [UIApplication sharedApplication].statusBarHidden = YES;
        
        [_fullScreenScrollView setContentOffset:CGPointMake(_scrollViewContentWidth * indexPath.row, 0) animated:NO];//点击后调整scrollView的便宜位置使之与点击的cell对应
        
    } else if (_index == 1) {
        FTCoachVideoViewController *coachVideoViewController = [FTCoachVideoViewController new];
        coachVideoViewController.videoBean = bean;
        [self.navigationController pushViewController:coachVideoViewController animated:YES];
    }
        NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _beanArray.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTVideoCollectionViewCell" owner:self options:nil]firstObject];
    }
    FTCoachPhotoBean *coachPhotoBean = _beanArray[indexPath.row];
    [cell setWithCoachPhotoBean:coachPhotoBean];
    return cell;
}

- (void)setFullScreenScrollViewContents{
    _fullScreenScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _photoArray.count, SCREEN_HEIGHT);
    for (int i = 0; i < _photoArray.count; i++) {
        FTCoachPhotoBean *photoBean = _photoArray[i];
            UIImageView *photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            photoImageView.contentMode = UIViewContentModeScaleAspectFit;
            [photoImageView sd_setImageWithURL:[NSURL URLWithString:photoBean.url] placeholderImage:[UIImage imageNamed:@"小占位图"]];
            [_fullScreenScrollView addSubview:photoImageView];
    }
}
- (void)setFullScreenScrollView{
    _fullScreenScrollView = [UIScrollView new];
    _fullScreenScrollView.frame = [UIScreen mainScreen].bounds;
    _fullScreenScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _photoArray.count , SCREEN_HEIGHT);
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
}

- (void)initTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 109)];;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainView addSubview:_tableView];
    _tableView.estimatedRowHeight = 102;
    [_tableView registerNib:[UINib nibWithNibName:@"FTUserCommentOfCoachTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _commentsBeanArray.count;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    FTCoachsCommentByUserBean *bean = _commentsBeanArray[indexPath.row];
//    NSString *str = bean.evaluation;
//    
//    
//    UILabel *label = [UILabel new];
//    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(label.frame.size.width, MAXFLOAT)].height;
//    NSNumber *count = @((labelHeight) / _titleLabel.font.lineHeight);
//    NSInteger linecount = [count integerValue];
//    NSLog(@"共 %td 行", [count integerValue]);
//
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTUserCommentOfCoachTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    FTCoachsCommentByUserBean *bean = _commentsBeanArray[indexPath.row];
    [cell setWithBean:bean];
    
    if (0 == indexPath.row) {
        cell.topDividingLine.hidden = NO;
        cell.bottomDividingLine.hidden = YES;
    }else if (_commentsBeanArray.count - 1 == indexPath.row){
        cell.topDividingLine.hidden = YES;
        cell.bottomDividingLine.hidden = NO;
    }else{
        cell.topDividingLine.hidden = YES;
        cell.bottomDividingLine.hidden = YES;
    }
    return cell;
}

- (void)loadUserCommentFromServer{
    NSLog(@"加载评论...");
    [NetWorking getCoachCommentsByUserPhotosByID:_coachBean.userId andPageNum:[NSString stringWithFormat:@"%d", _pageNum] withBlock:^(NSDictionary *dic) {
        NSString *status = dic[@"status"];
        if ([status isEqualToString:@"success"]) {
            
            if (_pageNum == 1) {
                _commentsBeanArray = [NSMutableArray new];
                
            }
            
            NSArray *dicArray = dic[@"data"];
            for(NSDictionary *dic in dicArray){
                FTCoachsCommentByUserBean *coachsCommentByUserBean = [FTCoachsCommentByUserBean new];
                [coachsCommentByUserBean setValuesWithDic:dic];
                [_commentsBeanArray addObject:coachsCommentByUserBean];
            }
            [_tableView reloadData];
        } else {
            //没有获取到
        }
    }];
    
}

@end
