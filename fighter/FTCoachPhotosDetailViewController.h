//
//  FTCoachPhotosDetailViewController.h
//  fighter
//
//  Created by 李懿哲 on 20/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewControllerWithCustomBackButton.h"
#import "FTCoachPhotoBean.h"
#import "FTCoachBean.h"

@interface FTCoachPhotosDetailViewController : FTBaseViewControllerWithCustomBackButton

@property (nonatomic, strong) NSArray<FTCoachPhotoBean *> *photoArray;//照片数组
@property (nonatomic, strong) NSArray<FTCoachPhotoBean *> *videoArray;//视频数组

@property (nonatomic, strong) NSArray<FTCoachPhotoBean *> *beanArray;//照片或视频数组
@property (nonatomic, assign) NSInteger index;//当前选中的下标 0、1、2
@property (nonatomic, strong) FTCoachBean *coachBean;
@property (nonatomic, copy) NSString *gymName;//拳馆名字

@end
