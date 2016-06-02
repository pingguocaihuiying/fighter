//
//  FTAssetsViewController.m
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTAssetsViewController.h"
#import "FTImagPickerNavigationController.h"
#import "Masonry.h"
#import "FTImageCollectionCell.h"

#define kViewFrameHeight(view)        CGRectGetHeight(view)>500.0f ? 548.0f :460.0f



@interface FTAssetsViewController () <UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIImage *selectImage;
@end

@implementation FTAssetsViewController

@synthesize assetsGroup, assets;


- (id)initWithAssetsGroups:(ALAssetsGroup *)_assetsGroups
{
    self = [super init];
    if (self) {
        self.assetsGroup = _assetsGroups;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0x191919];
    self.navigationItem.title = @"相机胶卷";
    
    //导航栏左侧按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.bounds = CGRectMake(0, 0, 22, 22);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回"] forState:UIControlStateNormal];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"头部48按钮一堆-返回pre"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //导航栏右侧按钮
    UIButton *registBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registBtn setTitle:@"确认" forState:UIControlStateNormal];
    [registBtn setBounds:CGRectMake(0, 0, 50, 35)];
    [registBtn setTitleColor:[UIColor colorWithHex:0xb4b4b4] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(completeChangeImage) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:registBtn];

    
    
    // Do any additional setup after loading the view.
    NSMutableArray * _assets = [[NSMutableArray alloc] init];
    self.assets = _assets;
    
    [self loadAssets];
    
    [self initSubview];
}


- (void) initSubview {
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];
     self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flow];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FTImageCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"imageCell"];
//    [self.collectionView registerClass:[FTImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor colorWithHex:0x191919];
    [self.view addSubview:self.collectionView];
    
    
    CGFloat offset = self.view.frame.size.width/5;
    //picker
    __weak typeof(&*self) weakself= self;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.view.mas_bottom).with.offset(0);
        make.right.equalTo(weakself.view.mas_right).with.offset(-10);
        make.left.equalTo(weakself.view.mas_left).with.offset(10);
        make.top.equalTo(weakself.view.mas_top).with.offset(0);
    }];

}


- (void)loadAssets
{
    [self.assets removeAllObjects];
    
    __block FTAssetsViewController *blockSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        @autoreleasepool {
            [blockSelf.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                
                if (result == nil)
                {
                    return;
                }
                
                [blockSelf.assets addObject:result];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    });
    
}


#pragma mark-

#pragma mark-


#pragma mark-
#pragma mark button actions
- (void)completeChangeImage
{
    
    @autoreleasepool {
        [self performSelector:@selector(dismissAssetsViewController) withObject:nil afterDelay:0.5];
        
    }
}

- (void)dismissAssetsViewController
{
    FTImagPickerNavigationController * _imgPickerVC = (FTImagPickerNavigationController *)self.navigationController;
//    NSMutableArray * reusultArray = [self contextDrawImg];
    _imgPickerVC.didFinishBlock([self contextDrawImage:self.selectImage]);
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
    }];
}

//- (NSMutableArray *)contextDrawImg
//{
//    NSMutableArray * _resultArray  = [[NSMutableArray alloc] init];
//    
//    FTImagPickerNavigationController * _imgPickerVC = (FTImagPickerNavigationController *)self.navigationController;
//    for (id value in _imgPickerVC.selectionArray ) {
//        if ([value isKindOfClass:[ALAsset class]]) {
//            [_resultArray addObject:[self mediaInfoFromAsset:value]];
//        } else{
//            [_resultArray addObject:value];
//        }
//    }
//    return _resultArray ;
//}
//
//- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)grid
//{
//    ALAsset * asset = grid;
//    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
//    
//    [mediaInfo setObject:[asset valueForProperty:ALAssetPropertyType] forKey:kUIImagePickerControllerMediaType];
//    [mediaInfo setObject:[[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]] forKey:kUIImagePickerControllerReferenceURL];
//    
//    ALAssetRepresentation * _representation = [asset defaultRepresentation];
//    UIImage * _img = [[UIImage alloc] initWithCGImage:_representation.fullScreenImage];
//    [mediaInfo setObject:[self contextDrawImage:_img] forKey:kUIImagePickerControllerOriginalImage];
//    
//    return mediaInfo;
//}



#pragma mark -按比例缩放图片
- (UIImage *)contextDrawImage:(UIImage *)_img
{
    
    CGFloat width = 0;
    CGFloat height = 0;
    
    if (_img.size.width>_img.size.height) {
        
        height = 400;
        width = _img.size.width *(height/_img.size.height);
        
    }else{
        
        width = 400;
        height= _img.size.height *(width/_img.size.width);
    }
    
    
    CGSize size=CGSizeMake(width,height);
    
    UIGraphicsBeginImageContext(size);
    
    //    int xPos = ( tempW-_width)/2;
    //    int yPos = (tempH -_height)/2;
    CGRect _rect = CGRectMake(0, 0, width, height);
    
    // 绘制改变大小的图片
    [_img drawInRect:_rect];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    return scaledImage;
}


- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController dismissViewControllerAnimated:YES completion:^{}];
}



#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"self.assetsGroup.numberOfAssets:%ld",self.assetsGroup.numberOfAssets);
    return self.assetsGroup.numberOfAssets;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    FTImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    
    ALAsset *sasset = [self.assets objectAtIndex:indexPath.row];
    self.selectImage = [UIImage imageWithCGImage:sasset.thumbnail];
    cell.image.image = self.selectImage;
    
    return cell;
}

                        
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FTImageCollectionCell *cell = (FTImageCollectionCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [cell.selectedImage setImage:[UIImage imageNamed:@"复选-选中"]];
}

- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FTImageCollectionCell *cell = (FTImageCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selectedImage.image = nil;
}

#pragma mark UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.view.frame.size.width;
    
    CGFloat itemWidth = width /5;
    
    return (CGSize){itemWidth,itemWidth};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = width /5;
    return itemWidth/5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CGFloat width = self.view.frame.size.width;
    CGFloat itemWidth = width /5;
    return itemWidth/5;
}

#pragma mark-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
