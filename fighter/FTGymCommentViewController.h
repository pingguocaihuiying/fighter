//
//  FTGymCommentViewController.h
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTPracticeViewController.h"
#import "CellDelegate.h"
typedef void(^SpecialFreshBlock) ();
@interface FTGymCommentViewController : FTBaseViewController <TeachDelegate,CellDelegate>
@property (nonatomic,copy) NSString *objId;
@property (nonatomic, strong) SpecialFreshBlock freshBlock;
@end
