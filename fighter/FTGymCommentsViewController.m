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

@interface FTGymCommentsViewController ()<UITableViewDelegate,UITableViewDataSource,CellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
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

#pragma mark - init data
- (void) initData {
    self.dataArray = [[NSMutableArray alloc]init];
    [self getDataArrayFromWeb];
}


// 获取tableView data
- (void) getDataArrayFromWeb {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorking getGymComments:self.objId option:^(NSDictionary *dict) {
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
            if (self.dataArray.count == 0) {
                [self.view showMessage:@"还没有人评论哦，赶紧去抢沙发吧"];
            }else {
                [self.tableView reloadData];
            }
        }
    }];
}


#pragma mark - response

- (void) backBtnAction:(id) sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
   
    @try {
        
    FTGymCommentTableViewCell *cell = (FTGymCommentTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    cell.cellDelegate = self;
    FTGymCommentBean *bean = [self.dataArray objectAtIndex:indexPath.section];
    [cell setCellContentWithBean:bean];
        
//    // 头像
//    if (bean.headUrl.length > 0) {
//        [cell.avatarMask setHidden:NO];
//        [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:bean.headUrl] placeholderImage:[UIImage imageNamed:@"头像-空"]];
//    }else {
//        [cell.avatarMask setHidden:YES];
//        [cell.avatarImageView setImage:[UIImage imageNamed:@"头像-空"]];
//    }
//    
//    // 用户名
//    cell.nameLabel.text = bean.createName;
//    
//    //
//    cell.detailLabel.text = bean.comment;
    
    return cell;
    } @catch (NSException *exception) {
        NSLog(@"comment exception:%@",exception);
    } @finally {
        
    }
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


- (void) pushViewController:(UIViewController *)viewController {

     [self.navigationController presentViewController:viewController animated:YES completion:nil];
}
#pragma mark - private



@end
