//
//  FTCameraAndAlbum.h
//  fighter
//
//  Created by kang on 16/9/13.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTPickerViewDelegate.h"

@interface FTCameraAndAlbum : UIView

@property (nonatomic, weak) id<FTPickerViewDelegate> delegate;

@property (nonatomic, strong) UIButton *albumBtn;
@property (nonatomic, strong) UIButton *cameraBtn;

@end
