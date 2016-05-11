//
//  FTInputCheckCodeViewController.h
//  fighter
//
//  Created by kang on 16/5/9.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTInputCheckCodeViewController : FTBaseViewController

@property (weak, nonatomic) IBOutlet UIView *speraterView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;

@property (nonatomic,copy) NSString *phoneNum;


@end
