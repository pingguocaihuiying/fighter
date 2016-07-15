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
#import "FTGymTimeSectionTableViewCell.h"

@interface FTGymDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, setTicketViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSDictionary *gymInfoDic;//拳馆信息
@property (weak, nonatomic) IBOutlet UILabel *gymServicePriceLabel;//拳馆使用基础费用
@property (weak, nonatomic) IBOutlet UILabel *gymAddressLabel;//拳馆地址
@property (nonatomic, assign) BOOL isFreeTicket;//门票是否免费
@property (nonatomic, strong) NSMutableArray *supportItemsArray;//支持的设施


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gymInfoTopViewHeight;
@property (weak, nonatomic) IBOutlet UICollectionView *supportItemsCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsViewHeight;//labelsView高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelsFatherViewHeight;//labelsView父视图的高度（需要根据labelView高度去改变）
@property (weak, nonatomic) IBOutlet UIView *labelsView;
@property (nonatomic, strong) UIView *priceContentView;
@property (nonatomic, strong) FTSetTicketPriceViewTableViewCell *setTicketPriceView;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;//门票价格

@property (nonatomic, strong) NSArray *timeSectionsArray;//拳馆的固定时间段
@property (nonatomic, strong) NSArray *placesArray;//拳馆的场地列表
@property (nonatomic, strong) NSMutableDictionary *placesUsingInfoDic;//场地、时间段的占用情况

//时间段tableivews的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t0Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t1Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t2Heihgt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t3Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t4Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t5Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *t6Height;

@property (nonatomic, assign) NSInteger selectedWeekday;//选中的周几
@property (nonatomic, assign) NSInteger todayWeekday;//今天是周几
@property (nonatomic, copy) NSString *selectedTimeSectionString;//选中的时间段
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UIButton *preWeek;
@property (weak, nonatomic) IBOutlet UIButton *nextWeek;

@property (nonatomic, assign) int curWeekOffset;//默认为0，往后偏移一周为1，往后偏移两周为2
@property (nonatomic, assign) int selectedWeekOffset;//当前选中的week偏移数，

@property (nonatomic, assign) NSTimeInterval selectedDateTimestamp;//选中的比赛日期的时间戳


@end

@implementation FTGymDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSupportItemsCollection];
    [self initBaseData];
    [self initSubViews];
    [self getGymInfo];
    [self getTimeSlots];//获取拳馆固定的时间段
    
}

- (void)initSubViews{
    //隐藏下方的渐变view
    self.bottomGradualChangeView.hidden = YES;
    
    //设置日期
    [self setDateLabels];
    
    //隐藏渐变图层
    self.bottomGradualChangeView.hidden = YES;
    [self setNavigationBar];
    
    //初始化tableviews
    [self initTableViews];
    
}

- (void)setDateLabels{

    NSDate *  senddate=[NSDate dateWithTimeIntervalSinceNow: (7 * 24 * 60 * 60) * _curWeekOffset];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyy"];
    NSString *  yearString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"MM"];
    NSString *  monthString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"dd"];
    NSString *  dayString = [dateformatter stringFromDate:senddate];
    [dateformatter setDateFormat:@"EEE"];
    
    NSString *  weekString = [dateformatter stringFromDate:senddate];
    NSLog(@"-%@",weekString);
    int year = [yearString intValue];
    NSLog(@"-%d", year);
    int month = [monthString intValue];
    NSLog(@"--%d", month);
    int day = [dayString intValue];
    NSLog(@"---%d", day);
    
    // 判断当前天是周几，从而计算出当周的周一是几号（负数表示上个月月末）
    if ([weekString  isEqual: @"周一"]) {
        day = day - 1; // 因为下面有 day++;
    } else if ([weekString isEqual:@"周二"]) {
        day = day - 2;
    } else if ([weekString isEqual:@"周三"]) {
        day = day - 3;
    } else if ([weekString isEqual:@"周四"]) {
        day = day - 4;
    } else if ([weekString isEqual:@"周五"]) {
        day = day - 5;
    } else if ([weekString isEqual:@"周六"]) {
        day = day - 6;
    } else if ([weekString isEqual:@"周日"]) {
        day = day - 7;
    }
    
    //设置上个月、下个月的月份
    int curMonth = [monthString intValue];
    int preMonth = curMonth - 1;
    int nextMonth = curMonth + 1;
    if (curMonth < 1) curMonth = 12;
    if (nextMonth > 12) nextMonth = 1;
    
    if (day<0) { // 月初时显示上个月月末的日期
        for (int i = 0; i < 7; i++) {
            // 上个月末往后的月初数字
            int days = [FTTools getDaysInMonth:year month:month-1];
            day++;
            if (day > days) {
                day = 0;
                day++;
                monthString = [NSString stringWithFormat:@"%d", preMonth];//上个月的月份
            }
            // 月初之前的月末数字
            switch (day) {
                case 0: day = days; break;
                case -1: day = days-1; break;
                case -2: day = days-2; break;
                case -3: day = days-3; break;
                case -4: day = days-4; break;
                case -5: day = days-5; break;
                default: break;
            }
            NSLog(@"day : %d", day);
            //添加月·日label
            CGFloat lableWidth = (SCREEN_WIDTH - 15) / 7;//label宽度
            UILabel *dateLabel = [_dateView viewWithTag:10000 + i];
            if (!dateLabel) {
                 dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * lableWidth, 7, lableWidth, 11)];
                dateLabel.tag = 10000+i;
            }
            
            dateLabel.text = [NSString stringWithFormat:@"%d.%d", [monthString intValue], day];
            dateLabel.font = [UIFont systemFontOfSize:11];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.textColor = [UIColor colorWithHex:0x646464];
            [_dateView addSubview:dateLabel];
        }
    } else { // 月末
        for (int i = 0; i < 7; i++) {
            int days = [FTTools getDaysInMonth:year month:month];
            day++;
            if (day > days) {
                day = 0;
                day++;
                
                monthString = [NSString stringWithFormat:@"%d", nextMonth];//下个月的月份
            }
            NSLog(@"day : %d", day);
            
            //添加月·日label
            CGFloat lableWidth = (SCREEN_WIDTH - 15) / 7;//label宽度
            UILabel *dateLabel = [_dateView viewWithTag:10000 + i];
            if (!dateLabel) {
                dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(i * lableWidth, 7, lableWidth, 11)];
                dateLabel.tag = 10000+i;
            }
            dateLabel.text = [NSString stringWithFormat:@"%d.%d", [monthString intValue], day];
            dateLabel.font = [UIFont systemFontOfSize:11];
            dateLabel.textAlignment = NSTextAlignmentCenter;
            dateLabel.textColor = [UIColor colorWithHex:0x646464];
            [_dateView addSubview:dateLabel];
        }
    }
}

- (void)initTableViews{
    //设置tableivew的星期几
    _t0.day = 1;
    _t1.day = 2;
    _t2.day = 3;
    _t3.day = 4;
    _t4.day = 5;
    _t5.day = 6;
    _t6.day = 7;
    //注册cell用于复用
    [_t0 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t1 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t2 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t3 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t4 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t5 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    [_t6 registerNib:[UINib nibWithNibName:@"FTGymTimeSectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"timeSectionCell"];
    
    //设置代理
    _t0.delegate = self;
    _t0.dataSource = self;
    _t1.delegate = self;
    _t1.dataSource = self;
    _t2.delegate = self;
    _t2.dataSource = self;
    _t3.delegate = self;
    _t3.dataSource = self;
    _t4.delegate = self;
    _t4.dataSource = self;
    _t5.delegate = self;
    _t5.dataSource = self;
    _t6.delegate = self;
    _t6.dataSource = self;
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
    
    //默认选中的天和时间段下标为－1
    _selectedWeekday = -1;
    
}

/**
 *  获取时间段信息
 */
- (void)getTimeSlots{
    [NetWorking getGymTimeSlotsById:@"165" andOption:^(NSArray *array) {
        _timeSectionsArray = array;
        if (_timeSectionsArray && _timeSectionsArray.count > 0) {
            //获取时间段信息后，根据内容多少设置tableviews的高度，再刷新一次tableview
            [self setTableViewsHeight];
            [self reloadTableViews];
            
            //获取基本的时间段信息后，再获取占用情况
            [self gettimeSectionsUsingInfo];
        }
        
    }];
}


/**
 *  获取拳馆信息
 */
- (void)getGymInfo{
    [NetWorking getGymInfoById:@"158" andOption:^(NSDictionary *dic) {
        _gymInfoDic = dic;
        if (_gymInfoDic && _gymInfoDic.count > 0) {
            [self setGymInfo];
        }
    }];
}


//获取场地使用信息
- (void)gettimeSectionsUsingInfo{
    _todayWeekday = [FTTools getWeekdayOfToday];//每次请求可用时间段时，也刷新今天是周几，避免跨天操作时出现选中日期的计算错误
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", [[NSDate date]timeIntervalSince1970] + (_curWeekOffset * (7 * 24 * 60 * 60)) * 1000];
    [NetWorking getGymPlaceUsingInfoById:@"165" andTimestamp:timestampString  andOption:^(NSArray *array) {
        _placesUsingInfoDic = [NSMutableDictionary new];
        if (array && array.count > 0) {
            for(NSDictionary *dic in array){
                NSString *theDate = [NSString stringWithFormat:@"%@", dic[@"theDate"]];
                NSMutableDictionary *mDic = [[NSMutableDictionary alloc]initWithDictionary:dic];
                [_placesUsingInfoDic setObject:mDic forKey:theDate];
            }
            //获取场地使用信息后，刷新UI
            [self reloadTableViews];
        }
    }];
}

//设置拳馆基础信息
- (void)setGymInfo{
    //拳馆使用基础费用
    _gymServicePriceLabel.text = [NSString stringWithFormat:@"%@", _gymInfoDic[@"service_price"]];
    
    //门票
    //如果拳馆方设定门票为免费，则门票为免费，比赛发起人也不能设置
    NSString *is_sale_ticket = [NSString stringWithFormat:@"%@", _gymInfoDic[@"is_sale_ticket"]];
    if ([is_sale_ticket isEqualToString:@"1"]) {
        _isFreeTicket = YES;
    } else {
        _isFreeTicket = NO;
    }
    
    if (_isFreeTicket) {
        _basicPrice = [NSString stringWithFormat:@"%@ 元", _gymInfoDic[@"ticket_price"]];
        _totalPriceLabel.text = _basicPrice;
    } else {
        _totalPriceLabel.text = @"免费";
        _totalPriceLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
        _adjustTicketButton.hidden = YES;
    }
    
    //设置支持的设施
    [self setSupportItems];
    [_supportItemsCollectionView reloadData];
}


- (void)setSupportItems{
    _supportItemsArray = [NSMutableArray new];
    
//    BOOL supportBathe  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_bathe"]] isEqualToString:@"1"];
//    if (supportBathe) {
//        [_supportItemsArray addObject:@"sup_bathe"];
//    }
//    
//    BOOL supportApparatus  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_prop"]] isEqualToString:@"1"];
//    if (supportApparatus) {
//        [_supportItemsArray addObject:@"sup_prop"];
//    }
//    
//    BOOL supportSecurity  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_security"]] isEqualToString:@"1"];
//    if (supportSecurity) {
//        [_supportItemsArray addObject:@"sup_security"];
//    }
//    
//    BOOL supportShoot  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_shoot"]] isEqualToString:@"1"];
//    if (supportShoot) {
//        [_supportItemsArray addObject:@"sup_shoot"];
//    }
//    
//    BOOL supportWifi  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_wifi"]] isEqualToString:@"1"];
//    if (supportWifi) {
//        [_supportItemsArray addObject:@"sup_wifi"];
//    }
//    
//    BOOL supportReferee  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_referee"]] isEqualToString:@"1"];
//    if (supportReferee) {
//        [_supportItemsArray addObject:@"sup_referee"];
//    }
    BOOL supportBathe  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_bathe"]] isEqualToString:@"1"];
    if (!supportBathe) {
        [_supportItemsArray addObject:@"sup_bathe"];
    }
    
    BOOL supportApparatus  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_prop"]] isEqualToString:@"1"];
    if (!supportApparatus) {
        [_supportItemsArray addObject:@"sup_prop"];
    }
    
    BOOL supportSecurity  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_security"]] isEqualToString:@"1"];
    if (!supportSecurity) {
        [_supportItemsArray addObject:@"sup_security"];
    }
    
    BOOL supportShoot  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_shoot"]] isEqualToString:@"1"];
    if (!supportShoot) {
        [_supportItemsArray addObject:@"sup_shoot"];
    }
    
    BOOL supportWifi  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_wifi"]] isEqualToString:@"1"];
    if (!supportWifi) {
        [_supportItemsArray addObject:@"sup_wifi"];
    }
    
    BOOL supportReferee  = [[NSString stringWithFormat:@"%@", _gymInfoDic[@"sup_referee"]] isEqualToString:@"1"];
    if (!supportReferee) {
        [_supportItemsArray addObject:@"sup_referee"];
    }
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
    if (_supportItemsArray) {
        return _supportItemsArray.count;
    }
    return 0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FTGymSupportItemsCollectionViewCell *supportItemsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"supportItemsCell" forIndexPath:indexPath];
        supportItemsCell.itemImageView.image = [UIImage imageNamed:[FTTools getGymSupportItemImageNameWithItemNameEn:_supportItemsArray[indexPath.row]]];
        supportItemsCell.itemNameLabel.text = [FTTools getGymSupportItemNameWithItemNameEn:_supportItemsArray[indexPath.row]];
    return supportItemsCell;
}
#pragma -mark -初始化collectionView

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)confirmButtonClicked{
    NSLog(@"确定");
    
    //点击确定时，计算选中的日期
    [self getSelectedDayTimestamp];
    
    //返回前2个vc
    FTLaunchNewMatchViewController *launchNewMatchViewController = self.navigationController.viewControllers[1];
    launchNewMatchViewController.selectedGymLabel.text = @"天下一武馆";
    launchNewMatchViewController.totalTicketPriceLabel.text = [NSString stringWithFormat:@"%d 元", [_basicPrice intValue] + [_extraPrice intValue]];
    launchNewMatchViewController.selectedDateTimestamp = _selectedDateTimestamp;
    launchNewMatchViewController.selectedTimeSectionString = _selectedTimeSectionString;
    launchNewMatchViewController.matchTimeLabel.text = [FTTools getDateStringWith:_selectedDateTimestamp andTimeSection:_selectedTimeSectionString];
    
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
    
//    if (!_priceContentView) {
        _priceContentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _priceContentView.backgroundColor = [UIColor clearColor];
        
        UIView *bgView = [[UIView alloc]initWithFrame:_priceContentView.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.8;
        
        [_priceContentView addSubview:bgView];
        _setTicketPriceView = [[[NSBundle mainBundle]loadNibNamed:@"FTSetTicketPriceViewTableViewCell" owner:nil options:nil]firstObject];
        _setTicketPriceView.basicPrice = _basicPrice;
        [_setTicketPriceView setPirceLabelWithBasicPrice:_basicPrice andExtraPrice:_extraPrice];
        _setTicketPriceView.delegate = self;
        _setTicketPriceView.center = CGPointMake(_priceContentView.center.x, _priceContentView.center.y - 100);
        [_priceContentView addSubview:_setTicketPriceView];
        
        [[[UIApplication sharedApplication]keyWindow] addSubview:_priceContentView];
//    }else{
//        _priceContentView.hidden = NO;
//        [_setTicketPriceView.extraPriceTextField becomeFirstResponder];
//    }
}

//调整价格 “确定”
- (void)confirtButtonClickedWithBasicPrice:(NSString *)basicPriceString andExtraPrice:(NSString *)expraPriceString andTotalPrice:(NSString *)totalPrice{
    _priceContentView.hidden = YES;
    _basicPrice = basicPriceString;
    _extraPrice = expraPriceString;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%d 元", [_basicPrice intValue] + [_extraPrice intValue]];
    _totalPriceLabel.textColor = [UIColor redColor];
}

//调整价格“取消”
- (void)cancelButtonClicked{
    _priceContentView.hidden = YES;
    [[[UIApplication sharedApplication]keyWindow]endEditing:YES];
    _totalPriceLabel.text = [NSString stringWithFormat:@"%d", [_basicPrice intValue] + [_extraPrice intValue]];
    _totalPriceLabel.textColor = [UIColor redColor];
}

/**
 *  根据时间段的数量，设置tableview的高度
 */
- (void)setTableViewsHeight{
    CGFloat timeSectionTableViewsHeight = _timeSectionsArray.count * 44;
    _t0Height.constant = timeSectionTableViewsHeight;
    _t1Height.constant = timeSectionTableViewsHeight;
    _t2Heihgt.constant = timeSectionTableViewsHeight;
    _t3Height.constant = timeSectionTableViewsHeight;
    _t4Height.constant = timeSectionTableViewsHeight;
    _t5Height.constant = timeSectionTableViewsHeight;
    _t6Height.constant = timeSectionTableViewsHeight;
}

/**
 *  刷新时间段选择的tableviews
 */
- (void)reloadTableViews{
    [_t0 reloadData];
    [_t1 reloadData];
    [_t2 reloadData];
    [_t3 reloadData];
    [_t4 reloadData];
    [_t5 reloadData];
    [_t6 reloadData];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_timeSectionsArray && _timeSectionsArray.count > 0) {
        return _timeSectionsArray.count;
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTGymTimeSectionTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"timeSectionCell"];
    
    //如果是最后一行，隐藏分割线
    if (indexPath.row == _timeSectionsArray.count - 1) {
        cell.bottomLineView.hidden = YES;
    }
    
    FTTimeSectionTableView *theTableView = (FTTimeSectionTableView *)tableView;
    
    [cell setTimeLabelWithTimeSectionString:_timeSectionsArray[indexPath.row][@"timeSection"]];
    
    NSDictionary *dic = _placesUsingInfoDic[[NSString stringWithFormat:@"%ld", theTableView.day]];//获取某天的可选时间段，如果不存在，则说明无数据
    if (dic) {//如果有数据
        NSString *timeSection1 = dic[@"timeSection"];//可选时间段
        NSString *timeSection2 = _timeSectionsArray[indexPath.row][@"timeSection"];//cell代表的固定时间段
        if ([timeSection1 isEqualToString: timeSection2]) {//
            cell.isAvailable = YES;
            
            BOOL isTheSameWeek = _curWeekOffset == _selectedWeekOffset;//周是否相同
            BOOL isTheSameWeekday = theTableView.day == _selectedWeekday;//weekday是否相同
            BOOL isTheSameTimeSection = [timeSection1 isEqualToString: _selectedTimeSectionString];//时间段是否相同
            
            if (isTheSameWeek && isTheSameWeekday && isTheSameTimeSection) {
                cell.selectionImage.hidden = NO;
            }else{
                cell.selectionImage.hidden = YES;
            }
        } else {
            cell.isAvailable = NO;
        }
        
        
    }else{
        cell.isAvailable = NO;
    }

    [cell updateCellStatus];//更新标签颜色的显示
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FTTimeSectionTableView *theTableView = (FTTimeSectionTableView *)tableView;
    NSMutableDictionary *mdic = _placesUsingInfoDic[[NSString stringWithFormat:@"%ld", theTableView.day]];//获取某天的可选时间段，如果不存在，则说明无数据
    if (mdic) {//如果有数据
        NSString *timeSection1 = mdic[@"timeSection"];//可选时间段
        NSString *timeSection2 = _timeSectionsArray[indexPath.row][@"timeSection"];//cell代表的固定时间段
        if ([timeSection1 isEqualToString: timeSection2]) {//可以选中
            _selectedWeekday = theTableView.day;
            _selectedTimeSectionString = timeSection1;
            _selectedWeekOffset = _curWeekOffset;
//            [mdic setObject:@"YES" forKey:@"isSelected"];
            [theTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self reloadTableViews];
            
            
        } else {
//            [mdic setObject:@"NO" forKey:@"isSelected"];
        }
        
    }else{
        [mdic setObject:@"NO" forKey:@"isSelected"];
    }

}
- (IBAction)preWeek:(id)sender {
    NSLog(@"pre week");
    _curWeekOffset--;
    [self setDateLabels];
    if (_curWeekOffset <= 0) {
        _preWeek.hidden = YES;
    }
    [self gettimeSectionsUsingInfo];
}
- (IBAction)nextWeek:(id)sender {
    NSLog(@"next week");
    _preWeek.hidden = NO;
    _curWeekOffset++;
    [self setDateLabels];
    [self gettimeSectionsUsingInfo];
}

/**
 *  获取选中时间段的timestamp
 */
- (void) getSelectedDayTimestamp{
    NSTimeInterval curTimestamp = [[NSDate date] timeIntervalSince1970];
    _selectedDateTimestamp = curTimestamp + (7 * 24 * 60 * 60) * _curWeekOffset + (_selectedWeekday - [FTTools getWeekdayOfToday]) * (24 * 60 * 60);
    NSLog(@"ts : %f", _selectedDateTimestamp);
}
@end
