//
//  FTChooseGymListViewController.m
//  fighter
//
//  Created by Liyz on 6/30/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTChooseGymListViewController.h"
#import "FTGymCell.h"

@interface FTChooseGymListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *gymsTableview;

@end

@implementation FTChooseGymListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

//初始化subviews
- (void)initSubViews{
    self.bottomGradualChangeView.hidden = YES;//隐藏底部的遮罩
    
    [self setNavigationBar];//设置导航栏
    [self setTableView];
}

- (void)setNavigationBar{
    self.navigationItem.title = @"选择拳馆";//设置默认标题
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    //把左边的返回按钮左移
    //    [leftButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *confirmButton = [[UIBarButtonItem alloc]initWithTitle:@"按项目" style:UIBarButtonItemStylePlain target:self action:@selector(confirmButtonClicked)];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont systemFontOfSize:14],NSFontAttributeName,
                                    nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    //    [shareButton setImageInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    self.navigationItem.rightBarButtonItem = confirmButton;
    
}
- (void)setTableView{
    _gymsTableview.delegate = self;
    _gymsTableview.dataSource = self;
    [_gymsTableview registerNib:[UINib nibWithNibName:@"FTGymCell" bundle:nil] forCellReuseIdentifier:@"gymCell"];
    [_gymsTableview reloadData];
}
#pragma -mark -设置tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTGymCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gymCell"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"index.path.row : %ld", indexPath.row);
}
/**
 *  返回上一个viewController
 */
- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
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
