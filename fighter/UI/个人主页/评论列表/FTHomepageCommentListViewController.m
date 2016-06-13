//
//  FTHomepageCommentListViewController.m
//  fighter
//
//  Created by Liyz on 6/7/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTHomepageCommentListViewController.h"
#import "FTHomepageCommentTableViewCell.h"
#import "NetWorking.h"
#import "FTCommentViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

@interface FTHomepageCommentListViewController ()<UITableViewDelegate, UITableViewDataSource, CommentSuccessDelegate>
@property (nonatomic, strong)NSArray *commentsDataArray;
@end

@implementation FTHomepageCommentListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCommentListData];
    [self setSubviews];
}

- (void)getCommentListData{
    [NetWorking getCommentsWithObjId:_objId andTableName:_tableName andOption:^(NSArray *array) {
            _commentsDataArray = array;
        
        [_commentTableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)setSubviews{
    //设置返回按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(popVC)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //设置默认标题
    self.navigationItem.title = @"评论列表";
    
    //设置下方评论view的点击事件
    [self setTheCommentView];
    //设置评论tableview
    [self initCommentTableView];
    
    //刷新tableview
    [_commentTableView reloadData];
}
//有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_commentsDataArray) {
            return _commentsDataArray.count;
    }else{
        return 0;
    }
    
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FTHomepageCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    NSDictionary *commentDic = _commentsDataArray[indexPath.row];
    [cell setWithDic:commentDic];
    
    return cell;
}
//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /**如果要设置动态行高，应该是其他固定高度+评论内容的高度，此处挖个坑，日后填
     ＊先写死为2行的高度
     */
    return 55 + 29 + 2 + 9;
}

- (void)initCommentTableView{
    //设置tableview的代理
    _commentTableView.delegate = self;
    _commentTableView.dataSource = self;
    //从xib加载cell用于复用
    [_commentTableView registerNib:[UINib nibWithNibName:@"FTHomepageCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"commentCell"];
}

- (void)setTheCommentView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentViewClicke)];
    [_commentView addGestureRecognizer:tap];
}

- (void)commentViewClicke{
    NSLog(@"commentViewClicke");
    
    //要先登录才能操作
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    if (!localUser) {
        [self login];
    }else{
        FTCommentViewController *commentViewController = [FTCommentViewController new];
        commentViewController.objId = _objId;
        commentViewController.tableName = _tableName;
        commentViewController.delegate = self;//设置代理，评论成功后回调，刷新页面
        [self.navigationController pushViewController:commentViewController animated:YES];
    }

}

- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:NO completion:nil];
}

- (void)popVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)commentSuccess{
    [self getCommentListData];
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
