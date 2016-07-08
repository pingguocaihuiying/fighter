//
//  FTGymDetailViewController.m
//  fighter
//
//  Created by Liyz on 7/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTGymDetailViewController.h"
#import "FTGymSupportItemsCollectionViewCell.h"
#import "FTLaunchNewMatchViewController.h"
#import "FTSetTicketPriceViewTableViewCell.h"
#import "NetWorking.h"

@interface FTGymDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, setTicketViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gymInfoTopViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *supportItemsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsViewHeight;//labelsView高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsFatherViewHeight;//labelsView父视图的高度（需要根据labelView高度去改变）
@property (weak, nonatomic) IBOutlet UIView *labelsView;
@property (nonatomic, strong) UIView *priceContentView;
@property (nonatomic, strong) FTSetTicketPriceViewTableViewCell *setTicketPriceView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@property (nonatomic, strong) NSArray *timeSections;//拳馆的固定时间段

@end

@implementation FTGymDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self getTimeSlots];//获取拳馆固定的时间段
    [self initSubViews];
    [self setSupportItemsCollection];//设置支持设施view
//    [self setSupportLabelsView];//设置支持项目view
}

- (void)initSubViews{
    //隐藏渐变图层
    self.bottomGradualChangeView.hidden = YES;
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

- (void)initBaseData{
    _basicPrice = @"200";
}

- (void)getTimeSlots{
    [NetWorking getGymTimeSlotsById:@"165" andOption:^(NSArray *array) {
        
    }];
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
    //返回前2个vc
    FTLaunchNewMatchViewController *launchNewMatchViewController = self.navigationController.viewControllers[1];
    launchNewMatchViewController.selectedGymLabel.text = @"天下一武馆";
    launchNewMatchViewController.totalTicketPriceLabel.text = [NSString stringWithFormat:@"%d 元", [_basicPrice intValue] + [_extraPrice intValue]];
    [self.navigationController popToViewController:launchNewMatchViewController animated:YES];
}

- (void)setSupportLabelsView{
    NSString *labelsString = @"";
    if (!labelsString ||labelsString.length == 0)
        return;
    
    CGFloat width = SCREEN_WIDTH - 93;
    CGFloat w=0;
    CGFloat h=14;
    CGFloat x=0;
    CGFloat y=0;
    
    NSArray *labels = [labelsString componentsSeparatedByString:@", "];
    
    for (NSString *label in labels) {
        UIImageView *labelView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"格斗标签-%@", label]]];
        w = labelView.frame.size.width;
        h = labelView.frame.size.height;
        if (x + w <= width) {
            labelView.frame = CGRectMake(x, y, w, h);
            x = x + w + 8;
        }else {
            x = 0;
            y = y + h + 6;
            labelView.frame = CGRectMake(x, y, w, h);
        }
        
        [self.labelsView addSubview:labelView];
    }
    _labelsViewHeight.constant = y;
//    _labelsFatherViewHeight.constant = _labelsFatherViewHeight.constant - 20 + y;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)adjustTicketButtonClicked:(id)sender {
    NSLog(@"调整门票价格");
    
    if (!_priceContentView) {
        _priceContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _priceContentView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:_priceContentView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        
        [_priceContentView addSubview:bgView];
        _setTicketPriceView = [[[NSBundle mainBundle]loadNibNamed:@"FTSetTicketPriceViewTableViewCell" owner:nil options:nil]firstObject];
//        _setTicketPriceView.basicPrice = _basicPrice;
        _setTicketPriceView.delegate = self;
        _setTicketPriceView.center = CGPointMake(_priceContentView.center.x, _priceContentView.center.y - 100);
        [_priceContentView addSubview:_setTicketPriceView];
        
        [[[UIApplication sharedApplication]keyWindow] addSubview:_priceContentView];
    }else{
        _priceContentView.hidden = NO;
        [_setTicketPriceView.extraPriceTextField becomeFirstResponder];
    }
}

//调整价格 “确定”
- (void)confirtButtonClickedWithBasicPrice:(NSString *)basicPriceString andExtraPrice:(NSString *)expraPriceString andTotalPrice:(NSString *)totalPrice{
    _priceContentView.hidden = YES;
    _basicPrice = basicPriceString;
    _extraPrice = expraPriceString;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%d", [_basicPrice intValue] + [_extraPrice intValue]];
    _totalPriceLabel.textColor = [UIColor redColor];
}

//调整价格“取消”
- (void)cancelButtonClicked{
    _priceContentView.hidden = YES;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%d", [_basicPrice intValue] + [_extraPrice intValue]];
    _totalPriceLabel.textColor = [UIColor redColor];
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
