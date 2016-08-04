//
//  FTPhoneCheckCell.h
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPhoneCheckCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *checkCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *sentCheckCodeBtn;

@end
