//
//  FTGymCommentCell.h
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIPlaceHolderTextView.h"

@interface FTGymCommentCell : UITableViewCell <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIPlaceHolderTextView *textView;

@end
