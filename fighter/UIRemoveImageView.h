//
//  UIRemoveImageView.h
//  fighter
//
//  Created by kang on 16/9/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIImageViewDelegate <NSObject>

@optional
- (void) removeImage:(UIImage*)image;
- (void) showRemoveButton;
- (void) hideRemoveButton;
@end

@interface UIRemoveImageView : UIImageView

@property(nonatomic, assign) NSInteger removeBtnWidth;
@property(nonatomic, assign) NSInteger removeBtnHeight;
@property(nonatomic, strong) id<UIImageViewDelegate> delegate;


- (void) showButton;
- (void) hideButton;
- (void) setVedioImage;

@end
