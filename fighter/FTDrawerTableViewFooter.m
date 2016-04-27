//
//  FTDrawerTableViewFooter.m
//  fighter
//
//  Created by kang on 16/4/26.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerTableViewFooter.h"
#import "Masonry.h"

@implementation FTDrawerTableViewFooter

- (id) init {
    
    self = [super init];
    if (self) {
        
        [self setSubviews];
    }
    
    return self;
}


- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setSubviews];
    }
    
    return self;
    
}


- (void) setSubviews {

    //设置按钮
    _settingButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    _settingButton.bounds = CGRectMake(0, 0, 40, 40);
    _settingButton.layer.cornerRadius = 20;
    [_settingButton setImage:[UIImage imageNamed:@"账号设置"] forState:UIControlStateNormal];
    [_settingButton setImage:[UIImage imageNamed:@"账号设置pre"] forState:UIControlStateFocused];
    
    [self addSubview:_settingButton];
    
    __weak __typeof(&*self) weakSelf = self;
    [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-30);
        make.centerX.mas_equalTo(weakSelf);
    }];

}
@end
