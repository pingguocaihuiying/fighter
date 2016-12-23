//
//  RatingBar.m
//  fighter
//
//  Created by kang on 2016/11/10.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRatingBar.h"


@interface FTRatingBar (){
   
    float height;
    float width;
    float space;
    
    
}

@property (nonatomic,strong) UIImageView *s1;
@property (nonatomic,strong) UIImageView *s2;
@property (nonatomic,strong) UIImageView *s3;
@property (nonatomic,strong) UIImageView *s4;
@property (nonatomic,strong) UIImageView *s5;

@end

@implementation FTRatingBar

- (void) awakeFromNib {
    [super awakeFromNib];
    [self setSubViews];
    
    
//    [self addRightAndBottomConstriant];
}


- (id) init {

    self = [super init];
    if (self) {
        [self setSubViews];
        [self sizeToFitImageViewFrame];
    }
    
    return self;
}

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setSubViews];
        [self sizeToFitImageViewFrame];
    }
    
    return self;
}

- (instancetype)initWithSpacing:(float)spacing{
    
    self = [super init];
    if (self) {
        [self setSubViews];
        [self setSpaceW:spacing];
        [self sizeToFitImageViewFrame];
    }
    
    return self;
}


- (void) layoutSubviews {

    [self addImageConstraints];
}

- (void) setSubViews {
    
    height = 28;
    width = 21;
    space = 10;
    
    _s1 = [[UIImageView alloc] initWithImage:_unSelectedImage];
    _s2 = [[UIImageView alloc] initWithImage:_unSelectedImage];
    _s3 = [[UIImageView alloc] initWithImage:_unSelectedImage];
    _s4 = [[UIImageView alloc] initWithImage:_unSelectedImage];
    _s5 = [[UIImageView alloc] initWithImage:_unSelectedImage];
    
    [self addSubview:_s1];
    [self addSubview:_s2];
    [self addSubview:_s3];
    [self addSubview:_s4];
    [self addSubview:_s5];
    
//    [self addImageConstraints];
}



#pragma mark - setter

- (void) setSpaceW:(CGFloat)spaceW{
   
    _spaceW = spaceW;
//    [self addImageConstraints];
}

- (void) setImageH:(CGFloat)imageH {
    if (_imageH != imageH) {
        _imageH = imageH;
        [self setImageViewsHeight:imageH];
    }
}

- (void) setImageW:(CGFloat)imageW {

    if (_imageW != imageW) {
        _imageW = imageW;
        [self setImageViewsWidth:imageW];
    }
}


- (void) setImageViewsHeight:(CGFloat) imageViewH {

    [self setImageViewH:imageViewH imageView:_s1];
    [self setImageViewH:imageViewH imageView:_s2];
    [self setImageViewH:imageViewH imageView:_s3];
    [self setImageViewH:imageViewH imageView:_s4];
    [self setImageViewH:imageViewH imageView:_s5];
}

- (void) setImageViewsWidth:(CGFloat) imageViewW {

    [self setImageViewW:imageViewW imageView:_s1];
    [self setImageViewW:imageViewW imageView:_s2];
    [self setImageViewW:imageViewW imageView:_s3];
    [self setImageViewW:imageViewW imageView:_s4];
    [self setImageViewW:imageViewW imageView:_s5];
}

- (void) setImageViewH:(CGFloat) imageH  imageView:(UIImageView *) imageView {
    CGRect frame = imageView.frame;
    frame.size.height = imageH;
    imageView.frame = frame;
}

- (void) setImageViewW:(CGFloat) imageW  imageView:(UIImageView *) imageView {
    CGRect frame = imageView.frame;
    frame.size.width = imageW;
    imageView.frame = frame;
}




#pragma mark - constraint

- (void) addImageConstraints {
    
    if (_imageH > 0) {
        height = _imageH;
    }
    
    if (_imageW > 0) {
        width = _imageW;
    }
    
    if (_spaceW > 0) {
        space = _spaceW;
    }
    
    [self addImageViewConstraint:_s1 index:0];
    [self addImageViewConstraint:_s2 index:1];
    [self addImageViewConstraint:_s3 index:2];
    [self addImageViewConstraint:_s4 index:3];
    [self addImageViewConstraint:_s5 index:4];
    
}

- (void) sizeToFitImageViewFrame {
    CGRect frame = [self frame];
    frame.size.width = (width+space) * 5;
    frame.size.height = height;
    [self setFrame:frame];
}


- (void) addImageViewConstraint:(UIImageView *)imageview index:(NSInteger) index{

    [imageview setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:imageview
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1.0
                                                                      constant:0];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:imageview
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1.0
                                                                       constant:(width+space)*index];
    
    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:imageview
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:height];
    
    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:imageview
                                                                        attribute:NSLayoutAttributeWidth
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                                       multiplier:1.0
                                                                         constant:width];
    
   
    
    [self addConstraint:topConstraint];
    [self addConstraint:leftConstraint];
    [self addConstraint:heightConstraint];
    [self addConstraint:widthConstraint];
    
}

- (void) addRightAndBottomConstriant {

    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                     attribute:NSLayoutAttributeRight
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.s5
                                                                     attribute:NSLayoutAttributeRight
                                                                    multiplier:1.0
                                                                      constant:space];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:NSLayoutAttributeBottom
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.s5
                                                                      attribute:NSLayoutAttributeBottom
                                                                     multiplier:1.0
                                                                       constant:0];
    
    [self addConstraint:rightConstraint];
    [self addConstraint:bottomConstraint];
    
}



#pragma mark - rating


/**
 *  设置评分值
 *
 *  @param rating 评分值
 */
-(void)displayRating:(float)rating{
    
    [self.delegate ratingChanged:rating];
    
    [_s1 setImage:_unSelectedImage];
    [_s2 setImage:_unSelectedImage];
    [_s3 setImage:_unSelectedImage];
    [_s4 setImage:_unSelectedImage];
    [_s5 setImage:_unSelectedImage];
    
    
    _halfSelectedImage = _halfSelectedImage == nil ? _unSelectedImage : _halfSelectedImage;
    
    if (rating >= 0.5) {
        [_s1 setImage:_halfSelectedImage];
    }
    if (rating >= 1) {
        [_s1 setImage:_fullSelectedImage];
    }
    if (rating >= 1.5) {
        [_s2 setImage:_halfSelectedImage];
    }
    if (rating >= 2) {
        [_s2 setImage:_fullSelectedImage];
    }
    if (rating >= 2.5) {
        [_s3 setImage:_halfSelectedImage];
    }
    if (rating >= 3) {
        [_s3 setImage:_fullSelectedImage];
    }
    if (rating >= 3.5) {
        [_s4 setImage:_halfSelectedImage];
    }
    if (rating >= 4) {
        [_s4 setImage:_fullSelectedImage];
    }
    if (rating >= 4.5) {
        [_s5 setImage:_halfSelectedImage];
    }
    if (rating >= 5) {
        [_s5 setImage:_fullSelectedImage];
    }
    
    [self setNeedsDisplay];
    
    _rating = rating;
}

/**
 *  获取当前的评分值
 *
 *  @return 评分值
 */
-(CGFloat) rating{
    return _rating;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    int newRating = (int) (point.x / (width+space)) + 1;
    if (newRating > 5)
        return;
    
    if (point.x < 0) {
        newRating = 0;
    }
    
    if (newRating != _rating){
        [self displayRating:newRating];
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (self.isIndicator) {
        return;
    }
    
    CGPoint point = [[touches anyObject] locationInView:self];
    int newRating = (int) (point.x / (width+space)) + 1;
    if (newRating > 5)
        return;
    
    if (point.x < 0) {
        newRating = 0;
    }
    
    if (newRating != _rating){
        [self displayRating:newRating];
    }
}

@end
