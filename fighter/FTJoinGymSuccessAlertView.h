//
//  FTJoinGymSuccessAlertView.h
//  fighter
//
//  Created by 李懿哲 on 16/9/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FTJoinGymSuccessAlertViewDelegate <NSObject>

- (void)enterGymButtonClicked;

@end

@interface FTJoinGymSuccessAlertView : UIView

@property (nonatomic, weak) id<FTJoinGymSuccessAlertViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *gymNameLabel;

@end
