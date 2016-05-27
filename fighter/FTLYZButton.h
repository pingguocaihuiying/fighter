//
//  FTLYZButton.h
//  fighter
//
//  Created by Liyz on 5/27/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTLYZButton : UIButton
@property (nonatomic ,copy)NSString *itemValue;//标签中文名，用于显示
@property (nonatomic ,copy)NSString *itemValueEn;//标签英文名，用于和服务器交互数据
@property (nonatomic, strong)UIView *indexView;//button下标线
@end
