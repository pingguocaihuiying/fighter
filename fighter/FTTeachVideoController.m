//
//  FTTeachVideoController.m
//  fighter
//
//  Created by kang on 16/6/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTeachVideoController.h"
#import "FTVideoCollectionViewCell.h"
#import "FTVideoDetailViewController.h"

#import "RBRequestOperationManager.h"
#import "FTNetConfig.h"
#import "ZJModelTool.h"

#import "JHRefresh.h"
#import "FTVideoBean.h"
#import "UIButton+LYZTitle.h"
#import "UIButton+WebCache.h"
#import "MJRefresh.h"
#import "FTCache.h"
#import "FTCacheBean.h"
#import "FTLYZButton.h"
#import "DBManager.h"
#import "NetWorking.h"
#import "FTButton.h"
#import "FTRankTableView.h"
#import "FTTeachVideoCell.h"

@interface FTTeachVideoController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FTVideoDetailDelegate,FTSelectCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)  NSMutableArray *array;
@property (nonatomic, copy)NSString *videosTag;
@end

@implementation FTTeachVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavi];
    self.videosTag = @"1";//默认按时间排序
    [self initSubviews];
    [self getDataWithGetType:@"new" andCurrId:@"-1"];//第一次加载数据
}


//设置导航栏
- (void) setNavi {
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    
//    CGFloat buttonW = (SCREEN_WIDTH - 12*2)/3;
    // 教练地址筛选按钮
    FTButton *rightBtn = [FTButton buttonWithtitle:@"按时间"];
    rightBtn.frame = CGRectMake(20, 0, 95, 40);
    [rightBtn addTarget:self action:@selector(rightBtnBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    //把左边的返回按钮左移
    [ self.navigationItem.rightBarButtonItem setImageInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
}

- (void) initSubviews {
    
    
    [self initCollectionView];
    
    
}

#pragma -mark -初始化collectionView
- (void)initCollectionView{
    
//    _collectionView.backgroundColor = [UIColor clearColor];
    //    CGRect r = _collectionView.frame;
    //    r.size.width = SCREEN_WIDTH;
    //    _collectionView.frame = r;
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //注册一个collectionViewCCell队列
//    [_collectionView registerNib:[UINib nibWithNibName:@"FTVideoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"FTTeachVideoCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    
    [self setJHRefresh];
}

- (void)setJHRefresh{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    
    // 下拉刷新
    self.collectionView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.collectionView.mj_header setHidden:NO];
        [weakSelf getDataWithGetType:@"new" andCurrId:@"-1"];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
    // 上拉刷新
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 显示footer
        weakSelf.collectionView.mj_footer.hidden = NO;
        
        NSString *currId;
        if (weakSelf.array && weakSelf.array.count > 0) {
            currId = [weakSelf.array lastObject][@"videosId"];
            //如果当前是按“最热”来，需要找到最小的id座位current id
            if ([self.videosTag isEqualToString:@"0"]) {
                int minId = [currId intValue];
                
                for (NSDictionary *dic in weakSelf.array) {
                    
                    int videoId = [dic[@"videosId"] intValue];
                    if (videoId < minId) {
                        minId = videoId;
                    }
                }
                
                currId = [NSString stringWithFormat:@"%d", minId];
            }
            
        }else{
            return;
        }
        [weakSelf getDataWithGetType:@"old" andCurrId:currId];
    }];
    // 显示footer
//    self.collectionView.mj_footer.hidden = NO;
    
}

- (void)getDataWithGetType:(NSString *)getType andCurrId:(NSString *)videoCurrId{
    
    NSString *urlString = [FTNetConfig host:Domain path:GetVideoURL];
    
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@",_videoType, videoCurrId, self.videosTag, getType, ts, @"quanjijia222222"]];
    
    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@&otherkey=teach", urlString, _videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], self.videosTag];

    
//    urlString = [NSString stringWithFormat:@"%@?videosType=%@&videosCurrId=%@&getType=%@&ts=%@&checkSign=%@&showType=%@&videosTag=%@", urlString, _videoType, videoCurrId, getType, ts, checkSign, [FTNetConfig showType], self.videosTag];
    NSLog(@"urlString:%@",urlString);
    NetWorking *net = [[NetWorking alloc]init];
    [net getVideos:urlString option:^(NSDictionary *responseDic) {
        
        if (responseDic != nil) {
            NSString *status = responseDic[@"status"];
            if ([status isEqualToString:@"success"]) {
                
                NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:responseDic[@"data"]];
                //                NSLog(@"data:%@",responseDic[@"data"]);
                
                if ([getType isEqualToString:@"new"]) {
                    self.array = mutableArray;
                }else if([getType isEqualToString:@"old"]){
                    [self.array addObjectsFromArray:mutableArray];
                }
                
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];

                
            }else {
                [self.collectionView.mj_header endRefreshing];
                [self.collectionView.mj_footer endRefreshing];
                [self.collectionView reloadData];

            }
            
        }else {
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView reloadData];
        }
    }];

    
}



#pragma mark - delegates 

#pragma mark collection
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSLog(@"section : %ld, row : %ld", indexPath.section, indexPath.row);
    if (self.array) {
        FTVideoDetailViewController *videoDetailVC = [FTVideoDetailViewController new];
        //获取对应的bean，传递给下个vc
        NSDictionary *newsDic = self.array[indexPath.row];
        FTVideoBean *bean = [FTVideoBean new];
        [bean setValuesWithDic:newsDic];
        
//        FTVideoBean *bean = self.self.array[indexPath.row];
//        //标记已读
//        if (![bean.isReader isEqualToString:@"YES"]) {
//            bean.isReader = @"YES";
//            //从数据库取数据
//            DBManager *dbManager = [DBManager shareDBManager];
//            [dbManager connect];
//            [dbManager updateVideosById:bean.videosId isReader:YES];
//            [dbManager close];
//        }
        
        
        videoDetailVC.videoBean = bean;
        NSIndexPath *theIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
        NSLog(@"section : %ld, row : %ld", (long)indexPath.section, (long)indexPath.row);
        videoDetailVC.indexPath = theIndexPath;
        
        videoDetailVC.delegate = self;
        
        [self.navigationController pushViewController:videoDetailVC animated:YES];//因为rootVC没有用tabbar，暂时改变跳转时vc
    }
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FTTeachVideoCell" owner:self options:nil]firstObject];
    }
    
    //获取对应的bean，传递给下个vc
    NSDictionary *newsDic = self.array[indexPath.row];
    FTVideoBean *bean = [FTVideoBean new];
    [bean setValuesWithDic:newsDic];
    
//    FTVideoBean *bean = self.array[indexPath.row];
    [cell setWithBean:bean];
    return cell;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float width = 164 * SCALE;
    float height = 143 * SCALE;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15 * SCALE, 0, 15 * SCALE);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15* SCALE;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 16 * SCALE;;
}

#pragma marl FTVideoDetailDelegate
- (void)updateCountWithVideoBean:(FTVideoBean *)videoBean indexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.array[indexPath.row];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.voteCount] forKey:@"voteCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.viewCount] forKey:@"viewCount"];
    [dic setValue:[NSString stringWithFormat:@"%@", videoBean.commentCount] forKey:@"commentCount"];
    //    NSLog(@"indexPath.row : %ld", indexPath.row);
    self.array[indexPath.row] = dic;
    //    [self.tableViewController.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
}

#pragma mark FTSelectCellDelegate 

- (void) selectedValue:(NSDictionary *)dic {

    self.videosTag = dic[@"itemValueEn"];
    
    [self getDataWithGetType:@"new" andCurrId:@"-1"];
}

- (void) selectedValue:(NSString *)value style:(FTRankTableViewStyle) style {

    self.videosTag = value;
    
   [self getDataWithGetType:@"new" andCurrId:@"-1"];
}

#pragma mark - response 

- (void) backBtnAction:(id)btn {
    
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightBtnBtnAction:(id) sender {

    UIButton *button = sender;
    CGRect frame = [self.view convertRect:button.frame fromView:button.superview];
    
    FTRankTableView *kindTableView = [[FTRankTableView alloc]initWithButton:sender style:FTRankTableViewStyleLeft option:^(FTRankTableView *searchTableView) {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        [tempArray insertObject:@{@"itemValue":@"按时间", @"itemValueEn":@"1"} atIndex:0];
        [tempArray insertObject:@{@"itemValue":@"按人气", @"itemValueEn":@"0"} atIndex:1];
        searchTableView.dataArray = tempArray;
        searchTableView.dataType = FTDataTypeDicArray;
        searchTableView.Btnframe = frame;
        searchTableView.tableW =frame.size.width;
        
        searchTableView.tableH = 40*5;
        
        searchTableView.offsetY = 40;
        searchTableView.offsetX = 0;
        
        searchTableView.cellH = 40;
        [searchTableView caculateTableHeight];

    }];
    kindTableView.selectDelegate = self;
    kindTableView.dataType = FTDataTypeDicArray;
//    [self.view addSubview:kindTableView];
    [[UIApplication sharedApplication].keyWindow addSubview:kindTableView];
//    [kindTableView  setAnimation];
//
//    [kindTableView setDirection:FTAnimationDirectionToTop];
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
