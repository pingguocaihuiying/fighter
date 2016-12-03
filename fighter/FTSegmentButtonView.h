//
//  FTSegmentButtonView.h
//  fighter
//
//  Created by 李懿哲 on 24/11/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

@protocol FTSegmentButtonViewDelegate <NSObject>

- (void)leftButtonClicked;//左边按钮被点击
- (void)rightButtonClicked;//右边按钮被点击

@end

#import <UIKit/UIKit.h>

@interface FTSegmentButtonView : UIView

@property (nonatomic, weak) id<FTSegmentButtonViewDelegate> delegate;

@property (strong, nonatomic) IBOutlet UIButton *buttonLeft;
@property (strong, nonatomic) IBOutlet UIButton *buttonRight;

@end
