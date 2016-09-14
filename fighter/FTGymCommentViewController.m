//
//  FTGymCommentViewController.m
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymCommentViewController.h"
#import "FTGymLevelCell.h"
#import "FTGymCommentCell.h"
#import "FTGymPhotoCell.h"
#import "FTCameraAndAlbum.h"
#import "UIImage+LabelImage.h"

@interface FTGymCommentViewController () 

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FTGymCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBar];
    [self setTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 初始化

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
    
    //导航栏右侧按钮
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setTitle:@"发表" forState:UIControlStateNormal];
    [submitBtn setBounds:CGRectMake(0, 0, 50, 14)];
    [submitBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    
}


- (void) setTableView {

    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymLevelCell" bundle:nil] forCellReuseIdentifier:@"LevelCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymCommentCell" bundle:nil] forCellReuseIdentifier:@"CommentCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FTGymPhotoCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    
}

#pragma mark - response 

- (void) backBtnAction:(id) sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void) submitBtnAction:(id) sender {

    
}

//- (void) addPhotoBtnAction:(id) sender {
//    FTCameraAndAlbum *cameraView = [[FTCameraAndAlbum alloc]init];
//    [cameraView.albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [cameraView.cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
////    cameraView.delegate = self;
//    [self.view addSubview:cameraView];
//}

//
//- (void) cameraBtnAction :(id) sender {
//    
//    [[[(UIButton *)sender superview] superview] removeFromSuperview];
//    
//    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
//        
//        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
//        _imgPickerController.delegate = self;
//        _imgPickerController.allowsEditing = YES;
//        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        
//        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
//    }
//    
//}
//
//- (void) albumBtnAction:(id) sender {
//    
//    [[[(UIButton *)sender superview] superview] removeFromSuperview];
//    
//    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
//        
//        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
//        _imgPickerController.delegate = self;
//        _imgPickerController.allowsEditing = YES;
//        _imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        
//        [self.navigationController presentViewController:_imgPickerController animated:YES completion:nil];
//    }
//    [[[(UIButton *)sender superview] superview] removeFromSuperview];
//}
//
#pragma mark - delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 4;
    }else {
        return 1;
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        if (indexPath.row < 3) {
            return 50;
        }else {
            return 100;
        }
    }else {
        return 170;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    if (section == 1) {
        return 10;
    }
    
    return 0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *header = [UIView new];
    return header;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        if (indexPath.row <3) {
            
            FTGymLevelCell *cell = (FTGymLevelCell *)[tableView dequeueReusableCellWithIdentifier:@"LevelCell"];
            
            return cell;
        }else {
            
            FTGymCommentCell *cell = (FTGymCommentCell *)[tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
            
            return cell;
        }
    }else {
        
        FTGymPhotoCell *cell = (FTGymPhotoCell *)[tableView dequeueReusableCellWithIdentifier:@"PhotoCell"];

        cell.delegate = self;
        return cell;
    }
    
    return nil;
}

#pragma mark - Pressent
- (void) pressentController:(UIViewController *) viewController {
    
    [self.navigationController presentViewController:viewController animated:YES completion:nil];
}





@end
