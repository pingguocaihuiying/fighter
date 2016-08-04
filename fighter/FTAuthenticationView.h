//
//  FTAuthenticationView.h
//  fighter
//
//  Created by kang on 16/8/1.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushDelegate.h"

@interface FTAuthenticationView : UIView

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *birthTextField;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIImageView *idImageView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) id <PushDelegate> pushDelegate;
@end
