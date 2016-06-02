//
//  FTImagPickerNavigationController.h
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseNavigationViewController.h"

typedef void (^AGIPCDidFinish)(UIImage *image);
@interface FTImagPickerNavigationController : FTBaseNavigationViewController

//@property (nonatomic, strong) NSMutableArray * selectionArray;
@property (nonatomic, strong) UIImage * selectImage;
@property (copy,nonatomic) AGIPCDidFinish didFinishBlock;

- (id)initWithRootViewController:(UIViewController *)rootViewController successBlock:(AGIPCDidFinish)success;

@end
