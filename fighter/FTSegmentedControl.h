//
//  FTSegmentedControl.h
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAwesomeButton.h"
#import "FTSegmentItem.h"

typedef void(^selectionBlock)(NSUInteger segmentIndex);

@interface FTSegmentedControl : UIControl

@property (nonatomic,strong) UIColor *selectedColor;
@property (nonatomic,strong) UIColor *color;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,strong) UIColor *borderColor;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic,strong) NSDictionary *textAttributes;
@property (nonatomic,strong) NSDictionary *selectedTextAttributes;
@property (nonatomic)  IconPosition iconPosition;
@property (nonatomic,readonly) NSUInteger numberOfSegments;

- (id)initWithFrame:(CGRect)frame
              items:(NSArray*)items
       iconPosition:(IconPosition)position
  andSelectionBlock:(selectionBlock)block
     iconSeparation:(CGFloat)separation;
- (void)setItems:(NSArray*)items;
- (void)setSelected:(BOOL)selected segmentAtIndex:(NSUInteger)segment;
- (BOOL)isSelectedSegmentAtIndex:(NSUInteger)index;
- (void)setTitle:(id)title forSegmentAtIndex:(NSUInteger)index;
- (void)setSelectedTextAttributes:(NSDictionary*)attributes;
- (void)setSegmentAtIndex:(NSUInteger)index enabled:(BOOL)enabled;

@end
