//
//  MainViewController.h
//  fighter
//
//  Created by kang on 16/5/4.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDynamicsDrawerViewController.h"

@interface MainViewController : FTDynamicsDrawerViewController

//@property (nonatomic,assign)BOOL isPush;
//@property (nonatomic,strong)NSDictionary *pushDic;

- (void) pushMessage:(NSDictionary *)dic;

@end
