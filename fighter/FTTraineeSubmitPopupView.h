//
//  FTTraineeSubmitPopupView.h
//  fighter
//
//  Created by kang on 2016/11/8.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 学员评分提交弹出框view
 */
@interface FTTraineeSubmitPopupView : UIView
@property (nonatomic, copy) NSMutableDictionary *skillGradeDic;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *bookId;
@property (nonatomic, strong) NSMutableDictionary *notificationDic;

@end
