//
//  FTCommentViewController.h
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTNewsBean.h"

@protocol CommentSuccessDelegate <NSObject>
- (void)commentSuccess;
@end

@interface FTCommentViewController : FTBaseViewController
@property (nonatomic, strong)FTNewsBean *newsBean;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak)id<CommentSuccessDelegate> delegate;

@end
