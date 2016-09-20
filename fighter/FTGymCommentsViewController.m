//
//  FTGymCommentsViewController.m
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentsViewController.h"
#import "FTGymCommentsCell.h"

@interface FTGymCommentsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTGymCommentsViewController

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 初始化

- (void) initSubViews {

    [self setTableView];
}

- (void) setTableView {

    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentsCell" bundle:nil] forCellReuseIdentifier:@"CommentsCell"];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 310; // 设置为一个接近于行高“平均值”的数值
}

#pragma mark - response
#pragma mark - delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 4;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [UIView new];
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FTGymCommentsCell *cell = (FTGymCommentsCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentsCell"];
    
    return cell;
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

#pragma mark - private



@end
