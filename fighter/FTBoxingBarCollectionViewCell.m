//
//  FTBoxingBarCollectionViewCell.m
//  fighter
//
//  Created by 李懿哲 on 25/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBoxingBarCollectionViewCell.h"
#import "UILabel+FTLYZLabel.h"

@interface FTBoxingBarCollectionViewCell()

//上下左右的边框
@property (strong, nonatomic) IBOutlet UIView *topDividingLine;
@property (strong, nonatomic) IBOutlet UIView *leftDividingLine;
@property (strong, nonatomic) IBOutlet UIView *bottomDividingLine;
@property (strong, nonatomic) IBOutlet UIView *rightDividingLine;

//标题
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTitleLabel;
    //正标题约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleTrailing;

    //副标题约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subTitleTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subTitleLeading;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *subTitleTrailing;


//图片
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageWidth;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;



@end

@implementation FTBoxingBarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setDividingLineColor];//设置边框颜色
    
    [UILabel setRowGapOfLabel:_subTitleLabel withValue:5];//设置副标题行间距
    _subTitleLabel.textColor = Sub_Title_Color;//副标题颜色
    
//    if(SCREEN_WIDTH == 320) [self adapte320];//适配320宽的设备
    [self adapte320];
}

- (void)setDividingLineColor{
    _topDividingLine.backgroundColor = Cell_Space_Color;
    _leftDividingLine.backgroundColor = Cell_Space_Color;
    _bottomDividingLine.backgroundColor = Cell_Space_Color;
    _rightDividingLine.backgroundColor = Cell_Space_Color;
}

- (void)adapte320{
    //图片宽高
    _imageWidth.constant *= SCALE;
    _imageHeight.constant *= SCALE;
    
    //标题字体大小
    _titleLabel.font = [UIFont systemFontOfSize:15 * SCALE];
    _subTitleLabel.font = [UIFont systemFontOfSize:11 * SCALE];
    
    //正副标题的上、左、右约束
    _subTitleTop.constant *= SCALE;
    _subTitleLeading.constant *= SCALE;
    _subTitleTrailing.constant *= SCALE;
    _titleTop.constant *= SCALE;
    _titleLeading.constant *= SCALE;
    _titleTrailing.constant *= SCALE;
}

- (void)setWithBean:(FTModuleBean *)bean{
    _titleLabel.text = bean.name;
    _subTitleLabel.text = bean.desc;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:bean.pict]placeholderImage:[UIImage imageNamed:@"小占位图"]];
}

@end
