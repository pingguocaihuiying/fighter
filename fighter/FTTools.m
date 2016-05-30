//
//  FTTools.m
//  fighter
//
//  Created by Liyz on 5/19/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTTools.h"
#import "FTNWGetCategory.h"
#import "MBProgressHUD.h"

@implementation FTTools
+ (NSString *)getChLabelNameWithEnLabelName:(NSString *)labelNameEn{
    NSString *labelNameCh = @"";
    if ([labelNameEn isEqualToString:@"Boxing"]) {
        labelNameCh = @"格斗标签-拳击";
    }else if ([labelNameEn isEqualToString:@"MMA"]) {
        labelNameCh = @"格斗标签-综合格斗";
    }else if ([labelNameEn isEqualToString:@"ThaiBoxing"]) {
        labelNameCh = @"格斗标签-泰拳";
    }else if ([labelNameEn isEqualToString:@"Taekwondo"]) {
        labelNameCh = @"格斗标签-跆拳道";
    }else if ([labelNameEn isEqualToString:@"Judo"]) {
        labelNameCh = @"格斗标签-柔道";
    }else if ([labelNameEn isEqualToString:@"Wrestling"]) {
        labelNameCh = @"格斗标签-摔跤";
    }else if ([labelNameEn isEqualToString:@"Sumo"]) {
        labelNameCh = @"格斗标签-相扑";
    }else if ([labelNameEn isEqualToString:@"FemaleWrestling"]) {
        labelNameCh = @"格斗标签-女子格斗";
    }else if([labelNameEn isEqualToString:@"StreetFight"]){
        labelNameCh = @"格斗标签-街斗";
    }else if([labelNameEn isEqualToString:@"Others"]){
        labelNameCh = @"格斗标签-其他";
    }
    
    return labelNameCh;
}

+ (void)showHUDWithMessage:(NSString *)message andView:(UIView *)view{
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:HUD];
    HUD.label.text = message;
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    [HUD showAnimated:YES];
    sleep(1.5);
        [HUD removeFromSuperview];
    
}
@end