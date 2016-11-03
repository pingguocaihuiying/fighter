//
//  FTTraineeSkillSectionHeaderView.m
//  fighter
//
//  Created by kang on 2016/11/3.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTraineeSkillSectionHeaderView.h"

@interface FTTraineeSkillSectionHeaderView ()

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;

@end

@implementation FTTraineeSkillSectionHeaderView

- (id) init {

    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}


#pragma mark - setter
- (void) setTitle:(NSString *)title {

    if (![_title isEqualToString: title]) {
        _title = [title copy];
        
        self.titleLabel.text = _title;
    }
}

- (void) setDetail:(NSString *)detail {
    
    if (![_detail isEqualToString: detail]) {
        _detail = [detail copy];
        
        self.detailLabel.text = _detail;
    }
}

- (void) setTitleColor:(UIColor *)titleColor {

    if (_titleColor != titleColor) {
        _titleColor = titleColor;
        _titleLabel.textColor = self.titleColor;
    }
}



#pragma mark - getter
- (UILabel *) titleLabel {

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:18];
        
    }
    
    return _titleLabel;
}

- (UILabel *) detailLabel {

    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc]init];
        _detailLabel.textColor = [UIColor colorWithHex:0xb4b4b4];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.font = [UIFont systemFontOfSize:12];
        
    }
    
    return _detailLabel;
}


//- (UIColor *) titleColor {
//    
//    if (_titleColor) {
//        return _titleColor;
//    }
//    
//    return [UIColor whiteColor];
//}

- (UIColor *) detailColor {

    if (_detailColor) {
        return _detailColor;
    }
    
    return [UIColor colorWithHex:0xb4b4b4];
}


@end
