//
//  FTArenaChooseLabelView.m
//  fighter
//
//  Created by Liyz on 5/24/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaChooseLabelView.h"


@interface FTArenaChooseLabelView ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong)UIView *mainContentView;
@property (nonatomic, strong)UICollectionView *labelCollectionView;
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic, strong)UIButton *confirmButton;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, copy)NSString *curItemValueEn;
@end

@implementation FTArenaChooseLabelView

-(instancetype)init{
    if (self = [super init]) {
        [self initBaseData];
        [self initSubviews];
    }
    return self;
}

- (void)initBaseData{
    _dataArray = [[NSMutableArray alloc ] initWithArray:[FTNWGetCategory sharedCategories]];
    if (_isBoxerOrCoach) {//如果是拳手或教练，显示“训练”标签
        [_dataArray addObject:@{@"itemValue":@"训练", @"itemValueEn":@"Train"}];    
    }
    
    
}

- (void)initSubviews{
    
    //增加半透明全屏背景imageView
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0.4;
    [self addSubview:bgView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewTap)];
//    bgView.userInteractionEnabled = YES;
//    [self addGestureRecognizer:tap];
    
    //设置中间主要内容的view
    _mainContentView = [[UIView alloc]init];
    
    _mainContentView.frame = CGRectMake(SCREEN_WIDTH / 2 - 280 / 2, SCREEN_HEIGHT / 2 - 280 / 2, 280, (19 + 15 + 33 * (_dataArray.count + 1) / 2 + 15 + 15) + 49);
//    _mainContentView.backgroundColor = [UIColor colorWithHex:0x1E1E1E];
    _mainContentView.backgroundColor = [[UIColor alloc]initWithRed:30 / 255.0 green:30 / 255.0 blue:30 / 255.0 alpha:1];
    
    //添加金属边框的背景
    UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"弹出框背景"]];
    bgImageView.frame = _mainContentView.bounds;
    [_mainContentView addSubview:bgImageView];
    //添加标题
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.width = 100;
    _titleLabel.height = 19;
    _titleLabel.left = _mainContentView.width / 2 - _titleLabel.width / 2;
    _titleLabel.top = 19;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.text = @"项目分类";
    _titleLabel.font = [UIFont systemFontOfSize:15];
    _titleLabel.textColor = [UIColor whiteColor];
    [_mainContentView addSubview:_titleLabel];
    //初始化collectionView
    [self setLabelCollectView];
    //设置“确定”按钮
    [self setConfirmbutton];

    
    
    [self addSubview:_mainContentView];
}


- (void)bgViewTap{
    NSLog(@"bgView tap.");
}

- (void)setConfirmbutton{
    _confirmButton = [[UIButton alloc]init];
    _confirmButton.width = 200;
    _confirmButton.height = 30;
    _confirmButton.left = _mainContentView.width / 2 - _confirmButton.width / 2;
    _confirmButton.top = 34 + _labelCollectionView.height + 19;
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [_mainContentView addSubview:_confirmButton];
    
}

- (void)confirmButtonClicked{
    if ([self.delegate respondsToSelector:@selector(chooseLabel:)]) {
        [self.delegate chooseLabel:_curItemValueEn];
    }
}

-(void)setLabelCollectView{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
    flow.minimumLineSpacing = 15;
    //列间距
    flow.minimumInteritemSpacing = 1;
    
    //cell大小设置
    flow.itemSize = CGSizeMake(100, 18);
    
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(15, 28, 15, 28);
    
    //滚动方向
    //           flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _labelCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 19 + _titleLabel.height, _mainContentView.width, 33 * (_dataArray.count + 1) / 2 + 15) collectionViewLayout:flow];
    _labelCollectionView.delegate = self;
    _labelCollectionView.dataSource = self;
    
    _labelCollectionView.backgroundColor = [[UIColor alloc]initWithRed:30 / 255.0 green:30 / 255.0 blue:30 / 255.0 alpha:1];
    [_mainContentView addSubview:_labelCollectionView];

    
    //注册一个collectionViewCCell队列
    [_labelCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}
//有多少组
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return  1;
}

//选中触发的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld, %ld", indexPath.section, indexPath.row);
    NSLog(@"itemValueEn : %@", _dataArray[indexPath.row][@"itemValueEn"]);
    _curItemValueEn = _dataArray[indexPath.row][@"itemValueEn"];
    [_labelCollectionView reloadData];
    
}

//某组有多少行
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

//返回cell
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [UICollectionViewCell new];
    }
    NSDictionary *dic = _dataArray[indexPath.row];
    //添加小圆圈
//    UIButton *circleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
//    [circleButton setBackgroundImage:[UIImage imageNamed:@"弹出框用-类别选择-空"] forState:UIControlStateNormal];
//    [cell addSubview:circleButton];
    UIImageView *circleImageView = [cell viewWithTag:1000];
    if (circleImageView == nil) {
        circleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        circleImageView.tag = 1000;
        [cell addSubview:circleImageView];
    }
    if (!_curItemValueEn) {
        _curItemValueEn = @"";
    }
//    circleImageView.image = [UIImage imageNamed: @"弹出框用-类别选择-空"];
    circleImageView.image = [UIImage imageNamed:[_curItemValueEn isEqualToString:dic[@"itemValueEn"]] ? @"弹出框用-类别选择-选中" : @"弹出框用-类别选择-空"];
    
    //添加标签名称
    UILabel *labelName = [cell viewWithTag:1001];
    if (labelName == nil) {
        labelName = [[UILabel alloc]initWithFrame:CGRectMake(28, 3, cell.width - 28, 12)];
        labelName.tag = 1001;
        [cell addSubview:labelName];
    }
    
    labelName.font = [UIFont systemFontOfSize:12];
    
    labelName.text = dic[@"itemValue"];
    labelName.textColor = [UIColor whiteColor];
    
    return cell;
}
@end
