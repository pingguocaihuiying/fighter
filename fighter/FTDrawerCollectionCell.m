//
//  FTDrawerCollectionCell.m
//  fighter
//
//  Created by kang on 16/4/27.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTDrawerCollectionCell.h"
#import "NSString+Size.h"
#import "Masonry.h"

@implementation FTDrawerCollectionCell




- (UIImageView *) backImgView {
   
    if (_backImgView) {
        _backImgView = [[UIImageView alloc]init];
    }
    
    return _backImgView;
}


- (UILabel *) titleLabel {

    if (_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
    }
    
    return _titleLabel;
}

- (void) layoutLabel {
    //
    if (_title) {
        CGSize size = [_title sizeWithFont:_titleLabel.font maxSize:CGSizeMake(MAXFLOAT, 15)];
        _titleLabel.bounds = CGRectMake(0, 0, size.width, size.height);
    }
}


- (void) layoutSubviews {

    
}

- (void) drawRect:(CGRect)rect {
    
    
}
@end
