//
//  FTCoachPhotoBean.h
//  fighter
//
//  Created by 李懿哲 on 20/12/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseBean.h"

@interface FTCoachPhotoBean : FTBaseBean

@property (nonatomic, copy) NSString *url;//照片地址，或视频地址
@property (nonatomic, copy) NSString *videoImageURL;//视频的缩略图地址
@property (nonatomic, assign) int type;//类型，0-图片，1-视频
@property (nonatomic, copy) NSString *title;//标题

@end
