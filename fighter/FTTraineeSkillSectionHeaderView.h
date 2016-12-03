//
//  FTTraineeSkillSectionHeaderView.h
//  fighter
//
//  Created by kang on 2016/11/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 学员技能点table view section headerView 
 */
@interface FTTraineeSkillSectionHeaderView : UIView

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *detail;
@property (copy, nonatomic) NSAttributedString *detailAttributeString;;

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *detailColor;

@property (strong, nonatomic) UIFont *titleFont;
@property (strong, nonatomic) UIFont *detailFont;

@end
