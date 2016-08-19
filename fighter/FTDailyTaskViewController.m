//
//  FTDailyTaskViewController.m
//  fighter
//
//  Created by kang on 16/8/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDailyTaskViewController.h"
#import "FTTaskShareCell.h"
#import "FTTaskRemindCell.h"


@interface FTDailyTaskViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTDailyTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"东西任务";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - delegate
#pragma mark UITableView Datasource

#pragma mark UITableVIew Delegate


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
