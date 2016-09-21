//
//  FTGymSourceViewController.m
//  fighter
//
//  Created by 李懿哲 on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymSourceViewController.h"

@interface FTGymSourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *balanceLabel;//动态label:余额的值
@property (strong, nonatomic) IBOutlet UILabel *yuanLabel;//固定label：『元』

//collectionView的一些约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewLeftMargin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewRightMargin;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;


@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;//教练的collectionView

//分割线
@property (strong, nonatomic) IBOutlet UIView *seperatorView1;
@property (strong, nonatomic) IBOutlet UIView *seperatorView2;
@property (strong, nonatomic) IBOutlet UIView *seperatorView3;
@property (strong, nonatomic) IBOutlet UIView *seperatorView4;
@property (strong, nonatomic) IBOutlet UIView *seperatorView5;

@end

@implementation FTGymSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)setSubViews{
    [self initSomeViewsBaseProperties];//初始化一些label颜色、分割线颜色等
    [self setNaviView];//设置导航栏
    [self setCollectionView];//设置教练模块的view
}

- (void)initSomeViewsBaseProperties{
    [self.bottomGradualChangeView removeFromSuperview];//移除底部的遮罩
    
    //自定义一些label、分割线（view）的颜色
    _balanceLabel.textColor = Custom_Red;
    _yuanLabel.textColor = Custom_Red;
    _seperatorView1.backgroundColor = Cell_Space_Color;
    _seperatorView2.backgroundColor = Cell_Space_Color;
    _seperatorView3.backgroundColor = Cell_Space_Color;
    _seperatorView4.backgroundColor = Cell_Space_Color;
    _seperatorView5.backgroundColor = Cell_Space_Color;
}

- (void)setNaviView{
    
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
    [leftButton setImageInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
        UIBarButtonItem *gymDetailButton = [[UIBarButtonItem alloc]initWithTitle:@"拳馆详情" style:UIBarButtonItemStylePlain target:self action:@selector(gotoGymDetail)];
        self.navigationItem.rightBarButtonItem = gymDetailButton;
}

- (void)backBtnAction:(id)sender{
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setCollectionView{
    
    //根据设备调整左右间距
    _collectionViewLeftMargin.constant *= SCALE;
    _collectionViewRightMargin.constant *= SCALE;
    
    
    //设置layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        //item宽、高、行间距
    CGFloat itemWidth = 64 * SCALE;
    CGFloat itemHeight = 64 * SCALE + 8 + 14;
    CGFloat lineSpacing = 15 * SCALE;
    
    flowLayout.itemSize = CGSizeMake(itemWidth, itemHeight);//cell大小
    flowLayout.minimumLineSpacing = lineSpacing;//行间距
    flowLayout.minimumInteritemSpacing = 29 * SCALE;//列间距
    _collectionView.collectionViewLayout = flowLayout;
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    //加载cell用于复用
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
    //根据数据源个数，计算collectionView的高度（这段代码应该放在获取数据源之后）
    NSInteger count = 8;//cell总数
    NSInteger line = 0;//行数
    NSInteger numberPerLine = 4;//每行cell数
    if(count % numberPerLine == 0){
        line = count / numberPerLine;
    }else if (count % numberPerLine > 0){
        line = count / numberPerLine + 1;
    }
    _collectionViewHeight.constant = line * itemHeight + (line - 1) * lineSpacing;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)gotoGymDetail{
    
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
