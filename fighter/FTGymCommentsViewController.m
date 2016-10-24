//
//  FTGymCommentsViewController.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentsViewController.h"
#import "FTGymCommentTableViewCell.h"
#import "FTGymCommentBean.h"
#import "CellDelegate.h"
#import "FTGymCommentReplyViewController.h"
#import "FTGymCommentViewController.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"


@interface FTGymCommentsViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate,UITextFieldDelegate>
{
    BOOL thumbState;
    BOOL hasGetThumbState;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UITextField *commenTextField;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@property (nonatomic, strong) NSMutableArray<FTGymCommentBean *> *dataArray;
@end

@implementation FTGymCommentsViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 初始化

- (void) initSubViews {

    [self setNavigationBar];
    [self setTableView];
    [self setBottomView];
    
}

- (void) setNavigationBar {
    
    //设置左侧按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithImage:[[UIImage imageNamed:@"头部48按钮一堆-返回"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                   style:UIBarButtonItemStyleDone
                                   target:self
                                   action:@selector(backBtnAction:)];
    //把左边的返回按钮左移
    [leftButton setImageInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    self.navigationItem.leftBarButtonItem = leftButton;

}

- (void) setTableView {

    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 310; // 设置为一个接近于行高“平均值”的数值
}

- (void) setBottomView {
    
    //将多余的部分切掉
    self.commenTextField.layer.masksToBounds = YES;
    self.commenTextField.layer.cornerRadius = 16;
    //    self.commentTextField.delegate = self;
    
    //    self.commentButton.frame = CGRectMake(30, 12, 24, 24);
    self.commenTextField.leftView = self.leftView;
    self.commenTextField.leftViewMode = UITextFieldViewModeAlways;
}


- (void) setThumbState:(BOOL) state {
    
    if (state) {
        [self.thumbButton setImage:[UIImage imageNamed:@"点赞pre"] forState:UIControlStateNormal];
    }else {
        [self.thumbButton setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
    }
}

#pragma mark - init data
- (void) initData {
    self.dataArray = [[NSMutableArray alloc]init];
    [self getDataArrayFromWeb];
    [self getThumbState];
}

// 获取tableView data
- (void) getDataArrayFromWeb {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getGymComments:self.objId option:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
//        NSLog(@"dic:%@",dict);
//        NSLog(@"message:%@",dict[@"message"]);
        if (dict == nil) {
            return [self.view showMessage:@"网络繁忙~"];
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            NSArray *tempArray = dict[@"data"];
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in tempArray) {
                NSLog(@"dic:%@",dic);
                FTGymCommentBean *bean = [[FTGymCommentBean alloc]init];
                [bean setValuesWithDic:dic];
                [self.dataArray addObject:bean];
            }
            if (self.dataArray.count == 0) {
                [self.view showMessage:@"还没有人评论哦，赶紧去抢沙发吧"];
            }else {
                [self.tableView reloadData];
            }
        }else {
            [self.view showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}

- (void) getThumbState {
    
    FTUserBean *userbean = [FTUserBean loginUser];
    if (!userbean) {
        return;
    }

    [NetWorking getVoteStatusWithObjid:self.objId andTableName:@"v-gym" andOption:^(BOOL result) {
        hasGetThumbState = YES;
        thumbState = result;
//        NSLog(@"%@",thumbState?@"点赞成功":@"取消点赞");
        [self setThumbState:thumbState];
    }];
}

#pragma mark - response
//- (void) backBtnAction:(id) sender {
//    
//    [self.navigationController popViewControllerAnimated:YES];
//}


/**
 点赞/取消点赞

 @param sender 点赞按钮
 */
- (IBAction)thumbButtonAction:(id)sender {
    
    if (![self isLogined]) {
        return;
    }
    
    if (!hasGetThumbState) {
        [self getThumbState];
    }
    
    FTUserBean *user = [FTUserBean loginUser];
    
    //获取网络请求地址url
    NSString *urlString = [FTNetConfig host:Domain path:thumbState?DeleteVoteURL:AddVoteURL];
    NSString *userId = user.olduserid;
    NSString *objId = self.objId;
    NSString *loginToken = user.token;
    NSString *ts = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *tableName = @"v-gym";
    NSString *checkSign = [MD5 md5:[NSString stringWithFormat:@"%@%@%@%@%@%@", loginToken, objId, tableName, ts, userId, thumbState ?DeleteVoteCheckKey: AddVoteCheckKey]];
    
    urlString = [NSString stringWithFormat:@"%@?userId=%@&objId=%@&loginToken=%@&ts=%@&checkSign=%@&tableName=%@", urlString, userId, objId, loginToken, ts, checkSign, tableName];
    
    [NetWorking getRequestWithUrl:urlString parameters:nil option:^(NSDictionary *dict) {
        
        if (dict) {
//            NSLog(@"点赞状态 status : %@, message : %@", dict[@"status"], dict[@"message"]);
            if ([dict[@"status"] isEqualToString:@"success"]) {//如果点赞信息更新成功后，处理本地的赞数，并更新webview
                
                thumbState = thumbState? NO:YES;
                [self setThumbState:thumbState];
                
            }
        }
    }];

}

/**
 跳转评论拳馆页面

 @param sender 评论按钮
 */
- (IBAction)commentButtonAction:(id)sender {
    
    if (![self isLogined]) {
        return;
    }

    FTGymCommentViewController *commentVC = [ FTGymCommentViewController new];
    commentVC.objId = self.objId;
    commentVC.title = self.title;
    __weak typeof(self) weakself = self;
    commentVC.freshBlock = ^(){
        [weakself getDataArrayFromWeb];
        if (weakself.freshBlock) {
            weakself.freshBlock();
        }
    };
    
    [self.navigationController pushViewController:commentVC animated:YES];
    
}

#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 10;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    return header;
}
                                                                                                                                                                                                                                                                                                                                                                                                                         

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTGymCommentTableViewCell *cell = (FTGymCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    cell.cellDelegate = self;
    FTGymCommentBean *bean = [self.dataArray objectAtIndex:indexPath.section];
    [cell setCellContentWithBean:bean];
    
    return cell;
}

-  (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    
    FTGymCommentBean *bean = [self.dataArray objectAtIndex:indexPath.section];
    
    FTGymCommentReplyViewController *replyCommentVC = [[FTGymCommentReplyViewController alloc]init];
    replyCommentVC.bean = bean;
    replyCommentVC.objId = [NSString stringWithFormat:@"%d",bean.id];
    replyCommentVC.refreshBlock = [self getRefreshBlock];
    [self.navigationController  pushViewController:replyCommentVC animated:YES];
    
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 10; //sectionHeaderHeight
        if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y >= 0) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            
        } else if (scrollView.contentOffset.y >= sectionHeaderHeight) {
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

#pragma mark - CellDelegate
- (void) pressentViewController:(UIViewController *)viewController {

     [self.navigationController presentViewController:viewController animated:YES completion:nil];
}

- (void) pushViewController:(UIViewController *)viewController {
    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (RefreshBlock) getRefreshBlock {

    __weak typeof(self) weakSelf = self;
    RefreshBlock refreshBlock = ^(){
        [weakSelf.tableView reloadData];
    };
    
    return refreshBlock;
}


#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField {

    FTUserBean *user = [FTUserBean loginUser];
    if (!user) {
        [self login];
        return NO;
    }

    FTGymCommentViewController *commentVC = [ FTGymCommentViewController new];
    commentVC.objId = self.objId;
    commentVC.title = self.title;
    __weak typeof(self) weakself = self;
    commentVC.freshBlock = ^(){
        [weakself getDataArrayFromWeb];
        if (weakself.freshBlock) {
            weakself.freshBlock();
        }
    };
    [self.navigationController pushViewController:commentVC animated:YES];
    
    return NO;
}

#pragma mark - private
// 跳转登录界面方法
- (void)login{
    FTLoginViewController *loginVC = [[FTLoginViewController alloc]init];
    loginVC.title = @"登录";
    FTBaseNavigationViewController *nav = [[FTBaseNavigationViewController alloc]initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

@end
