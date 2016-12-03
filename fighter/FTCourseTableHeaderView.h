//
//  FTCourseTableHeaderView.h
//  fighter
//
//  Created by 李懿哲 on 22/10/2016.
//  Copyright © 2016 Mapbar. All rights reserved.
//

@protocol FTCourseTableHeaderViewDelegate <NSObject>

- (void)buttonClickedWith:(NSInteger)index;

@end

#import <UIKit/UIKit.h>

@interface FTCourseTableHeaderView : UIView

@property (nonatomic, weak) id<FTCourseTableHeaderViewDelegate> delegate;
- (void)initSubViewsWithIndex:(NSInteger)i;
- (void)setSelected;
- (void)setDisSelected;
@end
