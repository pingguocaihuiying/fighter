//
//  FTWebViewDetailBottomView.m
//  fighter
//
//  Created by 李懿哲 on 05/01/2017.
//  Copyright © 2017 Mapbar. All rights reserved.
//

#import "FTWebViewDetailBottomView.h"

@interface FTWebViewDetailBottomView()
@property (strong, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@end

@implementation FTWebViewDetailBottomView

//分享
- (IBAction)shareButtonClicked:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(shareButtonClicked)]) {
        [_delegate shareButtonClicked];
    }
}
//点赞、取消点赞
- (IBAction)likeButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(likeButtonClicked)]) {
        [_delegate likeButtonClicked];
    }
    
}
//左边的评论按钮被点击
- (IBAction)leftCommentButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(commentButtonClicked)]) {
        [_delegate commentButtonClicked];
    }
}

//右边的评论按钮被点击
- (IBAction)rightCommentButtonClicked:(id)sender {
    if ([_delegate respondsToSelector:@selector(commentButtonClicked)]) {
        [_delegate commentButtonClicked];
    }
}
//更新点赞状态
- (void)isLike:(BOOL)like{
    if (like) {
        //更新点赞按钮为红色
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"列表页-赞二态"] forState:UIControlStateNormal];
    } else {
        //置为白色
        [_likeButton setBackgroundImage:[UIImage imageNamed:@"文章详情页-底部-赞"] forState:UIControlStateNormal];
    }
}
//更新评论数
- (void)updateCommentCountWith:(NSInteger)commentCount{
    //更新评论数角标的显示
    NSString *commentCountSting;
    if (commentCount > 999) {
        commentCountSting = @"999+";
    }else{
        commentCountSting = [NSString stringWithFormat:@"%ld", commentCount];
    }
    _commentCountLabel.text = commentCountSting;
}
@end
