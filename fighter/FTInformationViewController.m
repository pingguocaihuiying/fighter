//
//  FTInformationViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTInformationViewController.h"
#import "FTTableViewController.h"

@interface FTInformationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property(nonatomic,strong) NSArray *sourceArry;     //数据源
@property(nonatomic,strong) UIPageViewController *pageViewController;   //翻页控制器
@property(nonatomic) NSInteger currentSelectIndex;

@end

@implementation FTInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self initSubViews];
    NSLog(@"资讯view did load");
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
}

- (void)initSubViews{
    [self.searchButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-搜索pre"] forState:UIControlStateHighlighted];
    [self.messageButton setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-消息pre"] forState:UIControlStateHighlighted];
    //设置分类栏
    [self setTypeNaviScrollView];
}

- (void)setTypeNaviScrollView{
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initView];
    self.sourceArry = @[@[@"测试1",@"测试1",@"测试1",@"测试1",@"测试1",@"测试1"],@[@"测试2",@"测试2",@"测试2",@"测试2",@"测试2",@"测试2"],@[@"测试3",@"测试3",@"测试3",@"测试3",@"测试3",@"测试3"],@[@"测试4",@"测试4",@"测试4",@"测试4",@"测试4",@"测试4"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"],@[@"测试5",@"测试5",@"测试5",@"测试5",@"测试5",@"测试5"]];
    
    [self initPageController];;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 视图加载
//视图加载
- (void)initView
{
    NSArray *titles = @[@"全部",@"拳击",@"自由搏击",@"散打",@"泰拳", @"kongfu", @"形意拳"];
    float curContentWidth = 0;
    for (int i = 0; i < titles.count; i++) {
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];

        [bt setTitle:titles[i] forState:UIControlStateNormal];
        bt.titleLabel.font = [UIFont systemFontOfSize:14];
        [bt setTitleColor: Main_Text_Color forState:UIControlStateNormal];
        bt.tag = i+1;
        
        //设置button的宽度
        NSString *content = bt.titleLabel.text;
        UIFont *font = bt.titleLabel.font;
        CGSize size = CGSizeMake(MAXFLOAT, 30.0f);
        CGSize buttonSize = [content boundingRectWithSize:size
                                                  options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                               attributes:@{ NSFontAttributeName:font}
                                                  context:nil].size;
        
        [bt setFrame:CGRectMake(curContentWidth, 0, buttonSize.width, 40)];
        
        [bt addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_currentScrollView addSubview:bt];
        
        
        //添加button下方的指示view
        UIView *indexView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, buttonSize.width, 3)];
        indexView.backgroundColor = [UIColor redColor];
        indexView.tag = 1000 + i;
        indexView.hidden = YES;
        [bt addSubview:indexView];
        
        
        if (i != titles.count - 1) {
            curContentWidth += buttonSize.width + 35;
        }else{
            curContentWidth += buttonSize.width;
        }
        
    }
    self.currentSelectIndex = 0;
    _currentScrollView.showsHorizontalScrollIndicator = NO;
    _currentScrollView.bounces = YES;
    
    _currentScrollView.contentSize = CGSizeMake(curContentWidth, 40);
    
}

- (void)initPageController
{
    FTTableViewController *VC1 = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
    VC1.sourceArrry = _sourceArry[0];
    
    UIPageViewController *pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0}];
    self.pageViewController = pageVC;
    [pageVC.view setFrame:_currentView.bounds];
    pageVC.delegate = self;
    pageVC.dataSource = self;
    [pageVC setViewControllers:@[VC1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
        NSLog(@" 设置完成 ");
    }];
    [self addChildViewController:pageVC];
    [_currentView addSubview:[pageVC view]];
}



#pragma mark - 按钮事件
//
- (void)clickAction:(UIButton *)sender
{
    if(self.currentSelectIndex != sender.tag - 1){
        self.currentSelectIndex = sender.tag-1;
        FTTableViewController *VC = [self controllerWithSourceIndex:sender.tag-1];
        [self.pageViewController setViewControllers:@[VC] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
            NSLog(@" 设置完成 ");
        }];
    }
}


#pragma mark - PrivateAPI
//
- (FTTableViewController *)controllerWithSourceIndex:(NSInteger)index
{
    if (self.sourceArry.count < index) {
        return nil;
    }
    
    FTTableViewController *VC = [[FTTableViewController alloc]initWithStyle:UITableViewStylePlain];
    VC.sourceArrry = _sourceArry[index];
    return VC;
}

//返回当前的索引值
- (NSInteger)indexofController:(FTTableViewController *)viewController
{
    NSInteger index = [self.sourceArry indexOfObject:viewController.sourceArrry];
    return index;
}

#pragma mark - SET方法
//设置当前的按钮颜色
- (void)setCurrentSelectIndex:(NSInteger)index
{
    //取消上面的背景色
    
    if (_currentSelectIndex != NSNotFound) {
        UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
        indexView.hidden = YES;
    }
    
    _currentSelectIndex = index;
    UIView *indexView = [_currentScrollView viewWithTag:_currentSelectIndex + 1000];
    indexView.hidden = NO;
    
    
    
//    //设置scrollView的偏移位置
//    CGRect frame = [self.view convertRect:selectbt.frame fromView:selectbt.superview];
//    if (frame.origin.x + selectbt.frame.size.width > SCREEN_WIDTH) {
//        NSInteger x = _currentScrollView.contentOffset.x;
//        [_currentScrollView setContentOffset:CGPointMake(frame.origin.x + selectbt.frame.size.width - SCREEN_WIDTH + x, 0) animated:YES];
//    }
//    else if (frame.origin.x < 0){
//        [_currentScrollView setContentOffset:CGPointZero animated:YES];
//    }
    
}


#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self controllerWithSourceIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self indexofController:(FTTableViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.sourceArry count]) {
        return nil;
    }
    return [self controllerWithSourceIndex:index];
}


#pragma mark - UIPageViewControllerDelegate
//即将转换开始的方法
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    //    NSLog(@" 开始动画  %@ ",[pendingViewControllers valueForKey:@"sourceArrry"]);
}


//动画结束后回调的方法
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)complete
{
    FTTableViewController *VC = [pageViewController.viewControllers lastObject];
    self.currentSelectIndex = [self indexofController:VC];
    //    NSLog(@" 动画结束 %@ ",pageViewController.viewControllers);
}
- (IBAction)searchButtonClicked:(id)sender {
    NSLog(@"search button clicked.");
}
- (IBAction)messageButtonClicked:(id)sender {
    NSLog(@"message button clicked.");
}


@end
