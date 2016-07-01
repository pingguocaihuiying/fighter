//
//  FTGymDetailViewController.m
//  fighter
//
//  Created by Liyz on 7/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymDetailViewController.h"
#import "FTGymSupportItemsCollectionViewCell.h"

@interface FTGymDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gymInfoTopViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *supportItemsCollectionView;

@end

@implementation FTGymDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
    [self setSupportItemsCollection];
}

- (void)initSubViews{
    [self setNavigationBar];
    
}

- (void)setNavigationBar{
    self.navigationItem.title = @"必图培训中心";//设置默认标题
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"确认合作" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
}

//设置上方支持的item
- (void)setSupportItemsCollection{
    //创建一个collectionView的属性设置处理器
    UICollectionViewFlowLayout *flow = [UICollectionViewFlowLayout new];
    
    //行间距
        flow.minimumLineSpacing = 20;
    //列间距
    flow.minimumInteritemSpacing = 0;
    
    
    float width = (SCREEN_WIDTH -  8) / 4;
    
    float height = 42;
    flow.itemSize = CGSizeMake(width, height);
    //section内嵌距离设置
    flow.sectionInset = UIEdgeInsetsMake(20, 0, 20, 0);
    
    _supportItemsCollectionView.delegate = self;
    _supportItemsCollectionView.dataSource = self;
    _supportItemsCollectionView.collectionViewLayout = flow;

    [_supportItemsCollectionView registerNib:[UINib nibWithNibName:@"FTGymSupportItemsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"supportItemsCell"];
    /**
     *  设置top view的高度，如果是二行，为253
                               1行，－62 ＝ 191
                               3行 ，＋ 62 ＝ 315
     */
    [_supportItemsCollectionView reloadData];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTGymSupportItemsCollectionViewCell *supportItemsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"supportItemsCell" forIndexPath:indexPath];
    
    return supportItemsCell;
}
#pragma -mark -初始化collectionView

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonClicked{
    NSLog(@"确定");
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
