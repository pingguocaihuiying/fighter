//
//  FTFilterTableViewController.m
//  fighter
//
//  Created by Liyz on 4/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTFilterTableViewController.h"

@interface FTFilterTableViewController ()

@end

@implementation FTFilterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setSubViews];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initData{
//    self.arr1 = [[NSMutableArray alloc]initWithArray:@[@"综合格斗", @"拳击", @"自由搏击", @"散打", @"泰拳"]];
//    self.arr2 = [[NSMutableArray alloc]initWithArray:@[@"摔跤", @"相扑"]];
//    self.arr = @[self.arr1, self.arr2];
}

- (void)setSubViews{
    //设置文本标题颜色
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHex:0x828287];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(popBack)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    //隐藏左边按钮
    self.navigationItem.hidesBackButton = YES;
    
    //设置tableView的类型
    [self.tableView setEditing:YES animated:YES];
    
    //设置背景
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"底纹"]];
    
    //
}


- (void)popBack{
    [self.delegate updateTypeArray:self.arr];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //return the number of sections
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return the number of rows
    NSArray *array = self.arr[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

       UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    cell.textLabel.text = self.arr[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//实现移动的方法
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{

    //    从数组中读取需要移动行的数据
    id object = self.arr[sourceIndexPath.section][sourceIndexPath.row];
    
    //    在数组中移动需要移动的行的数据
    [self.arr[sourceIndexPath.section]removeObjectAtIndex:sourceIndexPath.row];
    //    把需要移动的单元格数据在数组中，移动到想要移动的数据前面
    [self.arr[destinationIndexPath.section]insertObject:object atIndex:destinationIndexPath.row];
    [self.tableView reloadData];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        //        删除单元格的某一行时，在用动画效果实现删除过程
        id removeItem = self.arr[indexPath.section][indexPath.row];


        

        //从第一个列表中删除元素
        [self.arr[0] removeObject:removeItem];
            //用动画刷新tableView
//        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        //把删除的元素加入第二个列表
        [self.arr[1] addObject:removeItem];
            //计算新插入的元素的indexPath
        NSArray *tempArray = self.arr[1];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:tempArray.count - 1 inSection:1];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath2] withRowAnimation:UITableViewRowAnimationNone];

    }else if(editingStyle==UITableViewCellEditingStyleInsert){
        id insertItem = self.arr[indexPath.section][indexPath.row];
        //从原列表中删除元素
        [self.arr[1] removeObject:insertItem];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
        //把删除的元素加入第二个列表
        [self.arr[0] addObject:insertItem];
        //计算新插入的元素的indexPath
        NSArray *tempArray = self.arr[0];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:tempArray.count - 1 inSection:0];
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath2] withRowAnimation:UITableViewRowAnimationNone];
    }
}

//单元格返回的编辑风格，包括删除 添加 和 默认  和不可编辑三种风格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
            return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleInsert;
    }
}



@end
