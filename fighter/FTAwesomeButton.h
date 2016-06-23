//
//  FTAwesomeButton.h
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "NSString+FontAwesome.h"
#import "UIButton+PPiAwesome.h"

typedef void (^block)();

@interface FTAwesomeButton : UIControl
@property (nonatomic) IconPosition iconPosition;
@property (nonatomic, strong) NSDictionary *textAttributes;
@property (copy) void (^actionBlock)(FTAwesomeButton *button);

// Initializers
+ (FTAwesomeButton*)buttonWithType:(UIButtonType)type
                              text:(NSString *)text
                              icon:(NSString *)icon
                        attributes:(NSDictionary *)attributes
                   andIconPosition:(IconPosition)position;

+ (FTAwesomeButton*)buttonWithType:(UIButtonType)type
                              text:(NSString *)text
                         iconImage:(UIImage *)icon
                        attributes:(NSDictionary *)attributes
                   andIconPosition:(IconPosition)position;

- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
               icon:(NSString *)icon
         attributes:(NSDictionary *)attributes
    andIconPosition:(IconPosition)position;

- (id)initWithFrame:(CGRect)frame
               text:(NSString *)text
          iconImage:(UIImage *)icon
         attributes:(NSDictionary *)attributes
    andIconPosition:(IconPosition)position;

// Setters
- (void)setButtonText:(NSString *)buttonText;

- (void)setIcon:(NSString *)icon;

- (void)setIconImage:(UIImage *)icon;

- (void)setAttributes:(NSDictionary*)attributes
    forUIControlState:(UIControlState)state;

- (void)setBackgroundColor:(UIColor*)color
         forUIControlState:(UIControlState)state;

- (void)setRadius:(CGFloat)radius;

- (void)setBorderWidth:(CGFloat)width
           borderColor:(UIColor *)color;

- (void)setControlState:(UIControlState)controlState;

- (void)setSeparation:(CGFloat)separation;

- (void)setTextAlignment:(NSTextAlignment)alignment;

- (void)setHorizontalMargin:(CGFloat)margin;

- (void)setIconImageView:(UIImageView *)iconImageView;

//Getters
-(NSString*)getButtonText;
-(NSString*)getIcon;
-(UIImage*)getIconImage;
-(CGFloat)getRadius;
-(CGFloat)getSeparation;
-(NSTextAlignment)getTextAlignment;
-(CGFloat)getHorizontalMargin;
-(UIImageView*)getIconImageView;

@end
