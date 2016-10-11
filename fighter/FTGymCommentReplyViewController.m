//
//  FTGymCommentReplyViewController.m
//  fighter
//
//  Created by kang on 2016/9/23.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentReplyViewController.h"
#import "FTGymCommentReplyCell.h"
#import "FTGymCommentDetailCell.h"
#import "FTLoginViewController.h"
#import "FTBaseNavigationViewController.h"

@interface FTGymCommentReplyViewController () <UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;
@property (weak, nonatomic) IBOutlet UIView *leftView;

@property (weak, nonatomic) IBOutlet UIButton *thumbsButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewBottomContraint;

@property (nonatomic, strong) NSMutableArray<FTGymCommentBean *> *dataArray;
@end

@implementation FTGymCommentReplyViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setNotification];
    
    [self initData];
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化

- (void) initSubViews {
    
    [self setNavigationBar];
    [self setTableView];
    [self setBottomView];
}


- (void) setNotification {

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyBoardFrameWillChanged:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentReplyCell" bundle:nil] forCellReuseIdentifier:@"CommentReplyCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentDetailCell" bundle:nil] forCellReuseIdentifier:@"CommentDetail"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100; // 设置为一个接近于行高“平均值”的数值
}

- (void) setBottomView {
    
    //将多余的部分切掉
    self.commentTextField.layer.masksToBounds = YES;
    self.commentTextField.layer.cornerRadius = 16;
    
//    self.commentTextField.delegate = self;
    
//    self.commentButton.frame = CGRectMake(30, 12, 24, 24);
    self.commentTextField.leftView = self.leftView;
    self.commentTextField.leftViewMode = UITextFieldViewModeAlways;
}

#pragma mark - init data
- (void) initData {
    self.dataArray = [[NSMutableArray alloc]init];
    [self getDataArrayFromWeb];
}


// 获取tableView data
- (void) getDataArrayFromWeb {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getGymReplyComments:self.objId option:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"dic:%@",dict);
        NSLog(@"message:%@",dict[@"message"]);
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            NSArray *tempArray = dict[@"data"];
            for (NSDictionary *dic in tempArray) {
                NSLog(@"dic:%@",dic);
                FTGymCommentBean *bean = [[FTGymCommentBean alloc]init];
                [bean setValuesWithDic:dic];
                [self.dataArray addObject:bean];
            }
            if (self.dataArray.count > 0) {
                [self.tableView reloadData];
//                [self.view showMessage:@"还没有人评论哦，赶紧去抢沙发吧"];
            }
        }
    }];
}


#pragma mark - response

- (void) backBtnAction:(id) sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    if (_refreshBlock) {
        _refreshBlock();
    }
}

- (IBAction)thumbsButtonAction:(id)sender {
    
    if (![self isLogined]) {
        return;
    }

    [self.commentTextField resignFirstResponder];
    
    [NetWorking addVoteWithObjid:[NSString stringWithFormat:@"%d",self.bean.id] isAdd:self.thumbState? NO:YES andTableName:@"v-cgym" andOption:^(BOOL result) {
        if (result) {
            
            self.thumbState = self.thumbState?NO:YES;
            FTGymCommentDetailCell *cell = (FTGymCommentDetailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setThumbState:self.thumbState];
        }
    }];
}

- (IBAction)commentButtonAcrtion:(id)sender {
    
    if (![self isLogined]) {
        return;
    }
    
    [self.commentTextField resignFirstResponder];
    
    if (self.commentTextField.text == 0) {
        [self.view showMessage:@"评论文字不能为空"];
        return;
    }
    
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    [prams setObject:self.commentTextField.text forKey:@"comment"];
    [prams setObject:self.objId forKey:@"objId"];
    
    // 提交评论
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.commentButton setEnabled:NO];
    [NetWorking addCommentForGymComment:prams option:^(NSDictionary *dict) {
        [self.commentButton setEnabled:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"dic:%@",dict);
        NSLog(@"message:%@",dict[@"message"]);
        
        if (dict == nil) {
            [self.view showMessage:@"网络不稳定，请稍后再试~"];
        }
        
        BOOL status = [dict[@"status"] isEqualToString:@"success"];
        if (status) {
            
            FTGymCommentDetailCell *cell = (FTGymCommentDetailCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell setCommentState:YES];
            
            [self.commentTextField setText:@""];
            [self.commentTextField resignFirstResponder];
            
            [self getDataArrayFromWeb];
        }else {
            
            [self.view showMessage:[dict[@"message"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
    }];
}

#pragma mark - notification Action

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [aNotification userInfo];
    
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    
    //最后获取高度 宽度也是同理可以获取
    CGFloat height = keyboardRect.size.height;
    if (height <= 0) {
        height = 282;
    }
    NSLog(@"height:%f",height);
    
    CGRect currentFrame = [self.view convertRect:self.bottomView.frame toView:self.view];
    NSLog(@"y position before animation :(%f)",currentFrame.origin.y);
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.view.frame;
        weakSelf.view.frame = CGRectMake(frame.origin.x, frame.origin.y - height, frame.size.width, frame.size.height);
    }];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification{

    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [aNotification userInfo];
    
    //创建value来获取 userinfo里的键盘frame大小
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    //创建cgrect 来获取键盘的值
    CGRect keyboardRect = [aValue CGRectValue];
    
    //最后获取高度 宽度也是同理可以获取
    CGFloat height = keyboardRect.size.height;
    
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = weakSelf.view.frame;
        weakSelf.view.frame = CGRectMake(frame.origin.x, frame.origin.y + height, frame.size.width, frame.size.height);
    }];
}


- (void)keyBoardFrameWillChanged:(NSNotification *)note
{
    
    //获取键盘的动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
//    //创建自带来获取穿过来的对象的info配置信息
    NSDictionary *userInfo = [note userInfo];
    NSLog(@"userInfo:%@",userInfo);
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:duration animations:^{
        
        //改变底部工具条的底部约束
        weakSelf.bottomViewBottomContraint.constant =  endFrame.origin.y - SCREEN_HEIGHT;
        [weakSelf.view layoutIfNeeded];//刷新布局，使得工具条随键盘frame改变有动画
    }];
}


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 0) {
        return 10;
    }
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    UIView *downSpace = [[UIView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 0.5)];
    downSpace.backgroundColor = Cell_Space_Color;
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    @try {
        
        if (indexPath.section == 0) {
            
            FTGymCommentDetailCell *cell = (FTGymCommentDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentDetail"];
            FTGymCommentBean *bean = self.bean;
            [cell setCellContentWithBean:bean];
            
            return cell;
        }else {
            
            FTGymCommentReplyCell *cell = (FTGymCommentReplyCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentReplyCell"];
            FTGymCommentBean *bean = [self.dataArray objectAtIndex:indexPath.row];
            [cell setCellContentWithBean:bean];

            return cell;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"comment exception:%@",exception);
    } @finally {
        
    }
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.commentTextField resignFirstResponder];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    if (touch.view == self.tableView) {
        [self.commentTextField resignFirstResponder];
    }
    
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
