//
//  FTDrawerTableViewHeader.m
//  fighter
//
//  Created by kang on 16/4/26.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerTableViewHeader.h"
#import "Masonry.h"
#import "UIColor+YBColorCategory.h"

@interface FTDrawerTableViewHeader ()

@property (nonatomic, strong) UIButton *editingButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *heightLabel;
@property (nonatomic, strong) UILabel *weightLabel;

@property (nonatomic, strong) UIImageView *spaceLine;

@end

@implementation FTDrawerTableViewHeader

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
    
    [self setAvatarImageView];
    [self setEditingButton];
    [self setNameLabel];
    [self setAgeLabel];
    [self setAgeLabel];
    [self setHeightLabel];
    [self setSpaceLineImageView];
    [self setHeightLabel];
    [self setWeightLabel];

    
}

//设置头像
- (void) setAvatarImageView {

    _avatarImageView = [[UIImageView alloc]init];
    _avatarImageView.bounds = CGRectMake(0, 0, 80, 80);
    _avatarImageView.image = [UIImage imageNamed:@"头像-空"];
    _avatarImageView.layer.cornerRadius = 40;
    
    __weak __typeof(&*self) weakSelf = self;
    [_avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).with.offset(40);
        make.centerX.mas_equalTo(weakSelf);
    }];
    
    [self addSubview:_avatarImageView];
    
    //设置头像边框
    UIImageView *borderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    borderImageView.image = [UIImage imageNamed:@"圆头像边框"];
    borderImageView.backgroundColor = [UIColor clearColor];
    
    [_avatarImageView addSubview:borderImageView];
}


//设置编辑按钮
- (void) setEditingButton {
    
    _editingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _editingButton.bounds = CGRectMake(0, 0, 24, 24);
    _editingButton.layer.cornerRadius = 12;
    [_editingButton setImage:[UIImage imageNamed:@"用户设置"] forState:UIControlStateNormal];
    [_editingButton setImage:[UIImage imageNamed:@"用户设置pre"] forState:UIControlStateFocused];
    
    [self addSubview:_editingButton];
    
//    __weak __typeof(&*self) weakSelf = self;
    [_editingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_avatarImageView.mas_right).with.offset(24);
        make.centerY.mas_equalTo(_avatarImageView);
    }];
    
    
}

//设置用户名label
- (void) setNameLabel {

    _nameLabel = [[UILabel alloc] init];
    _nameLabel.bounds = CGRectMake(0, 0, self.bounds.size.width-100, 16);
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_nameLabel];
    
    __weak __typeof(&*self) weakSelf = self;
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_avatarImageView.mas_bottom).with.offset(15);
        make.centerY.mas_equalTo(weakSelf);
    }];
    
}


//设置性别Label
- (void) setSexLabel {

    _sexLabel = [[UILabel alloc] init];
    _sexLabel.bounds = CGRectMake(0, 0, 30, 12);
    _sexLabel.textColor = [UIColor whiteColor];
    _sexLabel.backgroundColor = [UIColor clearColor];
    _sexLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:_sexLabel];
    
    __weak __typeof(&*self) weakSelf = self;
    [_sexLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(10);
        make.right.equalTo(weakSelf.mas_centerX).with.offset(-7.5);
    }];

}

//设置年龄Label
- (void) setAgeLabel {

    _ageLabel = [[UILabel alloc] init];
    _ageLabel.bounds = CGRectMake(0, 0, 30, 12);
    _ageLabel.textColor = [UIColor whiteColor];
    _ageLabel.backgroundColor = [UIColor clearColor];
    _ageLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_ageLabel];
    
//    __weak __typeof(&*self) weakSelf = self;
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameLabel.mas_bottom).with.offset(15);
        make.left.equalTo(_sexLabel.mas_right).with.offset(15);
    }];
}

//设置身高和体重间隔斜线
- (void) setSpaceLineImageView {
    
    _spaceLine = [[UIImageView alloc]init];
    _spaceLine.bounds = CGRectMake(0, 0, 7, 12);
    _spaceLine.image = [UIImage imageNamed:@"斜线分割"];
    _spaceLine.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_spaceLine];
    
    __weak __typeof(&*self) weakSelf = self;
    [_spaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sexLabel.mas_bottom).with.offset(10);
        make.centerX.equalTo(weakSelf);
    }];

}


//设置身高Label
- (void) setHeightLabel {

    _heightLabel = [[UILabel alloc] init];
    _heightLabel.bounds = CGRectMake(0, 0, self.bounds.size.width/2-50, 12);
    _heightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    _heightLabel.backgroundColor = [UIColor clearColor];
    _heightLabel.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:_heightLabel];
    
    //    __weak __typeof(&*self) weakSelf = self;
    [_heightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sexLabel.mas_bottom).with.offset(10);
        make.right.equalTo(_spaceLine.mas_left).with.offset(-15);
    }];

}


//设置体重Label
- (void) setWeightLabel {
    
    _weightLabel = [[UILabel alloc] init];
    _weightLabel.bounds = CGRectMake(0, 0, self.bounds.size.width/2-50, 12);
    _weightLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
    _weightLabel.backgroundColor = [UIColor clearColor];
    _weightLabel.textAlignment = NSTextAlignmentLeft;
    
    [self addSubview:_weightLabel];
    
    //    __weak __typeof(&*self) weakSelf = self;
    [_weightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_sexLabel.mas_bottom).with.offset(10);
        make.left.equalTo(_spaceLine.mas_right).with.offset(15);
    }];
}



@end
