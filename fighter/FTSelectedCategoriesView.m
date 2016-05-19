//
//  FTSelectedCategories.m
//  fighter
//
//  Created by Liyz on 5/18/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTSelectedCategoriesView.h"

@implementation FTSelectedCategoriesView

- (instancetype)init{
    if (self = [super init]) {
        [self initSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSubViews];
    }
    return self;
}
/**
 *  初始化subViews
 */
- (void)initSubViews{
//    UILabel *leftLabel = [UILabel new];
    UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 75, 15)];
    leftLabel.left = 15;
    leftLabel.top = 17;
    leftLabel.textColor = [UIColor whiteColor];
    leftLabel.font = [UIFont systemFontOfSize:15];
    leftLabel.text = @"项目分类：";
    [self addSubview:leftLabel];
    
}

@end
