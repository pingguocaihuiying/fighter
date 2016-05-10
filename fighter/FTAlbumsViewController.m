//
//  FTAlbumsViewController.m
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTAlbumsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "FTAssetsViewController.h"
#import "Masonry.h"

@interface FTAlbumsViewController () <UITableViewDataSource, UITableViewDelegate>
{

}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

static ALAssetsLibrary * assetsLibrary;

@implementation FTAlbumsViewController
@synthesize  assetsGroups;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"所有相册";
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 35, 35);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-取消pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    [self settableView];
    [self initData];
}


- (void) settableView {
    
    self.tableView = [[UITableView alloc]init];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    //picker
    __weak typeof(&*self) weakself= self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.view.mas_bottom).with.offset(0);
        make.right.equalTo(weakself.view.mas_right).with.offset(0);
        make.left.equalTo(weakself.view.mas_left).with.offset(0);
        make.top.equalTo(weakself.view.mas_top).with.offset(0);
    }];

}

//准备数据
- (void) initData {

//     [self loadAssetsLibrary];
    
    [self initObject];
    [self getAlbums];
}


- (void) viewDidAppear:(BOOL)animated {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}
#pragma mark- private
- (void)initObject
{
    if (!assetsGroups) {
        NSMutableArray * _assetsGroups = [[NSMutableArray alloc]init];
        self.assetsGroups = _assetsGroups;
    }
    [self.assetsGroups removeAllObjects];
    
    
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;//防止ALAssetsLibrary的生命周期提前结束，无法传递
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
        assetsLibrary=library;
    });
}


- (void) getAlbums {

    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock =
    
    ^(ALAssetsGroup *group, BOOL *stop) {
        
        if (group!=nil) {
            
            [self.assetsGroups addObject:group];
            
            
        } else {
            
            [self.tableView  performSelectorOnMainThread:@selector(reloadData)
             
                                             withObject:nil waitUntilDone:YES];
            
        }
        
    };
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error)
    {
        
        NSString *errorMessage = nil;
        
        switch ([error code]) {
                
            case ALAssetsLibraryAccessUserDeniedError:
                
            case ALAssetsLibraryAccessGloballyDeniedError:
                
                errorMessage = @"The user has declined access to it.";
                
                break;
                
            default:
                
                errorMessage = @"Reason unknown.";
                
                break;
                
        }
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Opps"
                                  
                                                           message:errorMessage delegate:self cancelButtonTitle:@"Cancel"
                                  
                                                 otherButtonTitles:nil, nil];
        
        [alertView show];
        
        
    };
    
    NSUInteger groupTypes = ALAssetsGroupAlbum | ALAssetsGroupEvent |
    
    ALAssetsGroupFaces;
    
    
    [assetsLibrary enumerateGroupsWithTypes:groupTypes
     
                                 usingBlock:listGroupBlock failureBlock:failureBlock];
    
}


#pragma mark-
#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"assetsGroups.count%lu",assetsGroups.count);
    return self.assetsGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * idf = @"albumCell";
    UITableViewCell * _cell = [tableView dequeueReusableCellWithIdentifier:idf];
    if (!_cell) {
        _cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idf];
        [_cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        _cell.contentView.backgroundColor = [UIColor clearColor];
    }
    ALAssetsGroup *group = [self.assetsGroups objectAtIndex:indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSUInteger numberOfAssets = group.numberOfAssets;
    
    [_cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetsGroups objectAtIndex:indexPath.row] posterImage]]];
    
    NSString * name = [[NSString alloc] initWithFormat:@"%@",[group valueForProperty:ALAssetsGroupPropertyName]];
    _cell.textLabel.text = name;
    
    NSString * _num = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)numberOfAssets];
    _cell.detailTextLabel.text = _num;
    _cell.detailTextLabel.textColor = [UIColor grayColor];
    
    return _cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.contentTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    //
    FTAssetsViewController *controller = [[FTAssetsViewController alloc] initWithAssetsGroups:[self.assetsGroups objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark button actions
- (void)backAction
{
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
