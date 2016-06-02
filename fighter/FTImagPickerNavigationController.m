//
//  FTImagPickerNavigationController.m
//  fighter
//
//  Created by kang on 16/5/6.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTImagPickerNavigationController.h"

@interface FTImagPickerNavigationController ()

@end

@implementation FTImagPickerNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController successBlock:(AGIPCDidFinish)success
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        
        [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.navigationBarHidden = NO;
        
//        NSMutableArray * _selections = [[NSMutableArray alloc] init];
//        self.selectionArray = _selections;
        self.didFinishBlock = success;
    
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    //    AppDelegate * _app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //    [_app setNavigationBar:self.navigationBar];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    //UIInterfaceOrientationIsPortrait
    return UIDeviceOrientationIsPortrait(toInterfaceOrientation);
}



//- (void)setSelectionArray:(NSMutableArray *)_selectionArray
//{
//    if (self.selectionArray != self.selectionArray) {
//        self.selectionArray = self.selectionArray ;
//        
//    }
//}

@end
