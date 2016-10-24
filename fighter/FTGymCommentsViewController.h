//
//  FTGymCommentsViewController.h
//  fighter
//
//  Created by kang on 16/9/20.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController2.h"

typedef void(^FreshCommentCountBlock) ();

@interface FTGymCommentsViewController : FTBaseViewController2
@property(nonatomic, strong) NSString *objId;
@property (nonatomic, strong) FreshCommentCountBlock freshBlock;
@end
