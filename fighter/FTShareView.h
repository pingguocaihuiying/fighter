//
//  FTShareView.h
//  fighter
//
//  Created by kang on 16/5/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTShareView : UIView

@property (nonatomic ,strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *preImages;

@property (nonatomic, strong) UIButton *albumBtn;
@property (nonatomic, strong) UIButton *cameraBtn;

@end
