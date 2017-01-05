//
//  FTWebViewDetailBottomView.h
//  fighter
//
//  Created by 李懿哲 on 05/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

@protocol FTWebViewDetailBottomViewDelegate <NSObject>
- (void)commentButtonClicked;//评论按钮被点击
- (void)likeButtonClicked;//点赞按钮被点击
- (void)shareButtonClicked;//分享按钮被点击
@end

#import <UIKit/UIKit.h>

@interface FTWebViewDetailBottomView : UIView
@property (nonatomic, weak)id<FTWebViewDetailBottomViewDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;

- (void)isLike:(BOOL)like;//更新点赞
- (void)updateCommentCountWith:(NSInteger)commentCount;//更新评论数
@end
