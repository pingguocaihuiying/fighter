//
//  FTShareView2.h
//  fighter
//
//  Created by kang on 16/7/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTShareView2 : UIView

@property (nonatomic ,strong) UILabel *hintLabel;
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *preImages;

@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *imageUrl;

@end
