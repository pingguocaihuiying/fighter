//
//  TestViewController.h
//  fighter
//
//  Created by Liyz on 4/15/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTNewsBean.h"

@protocol FTnewsDetailDelegate <NSObject>

- (void)updateCountWithNewsBean:(FTNewsBean *)newsBean indexPath:(NSIndexPath *)indexPath;

@end

@interface FTNewsDetail2ViewController : FTBaseViewController
@property (nonatomic ,copy)NSString *webViewUrlString;
@property (nonatomic ,copy)NSString *newsTitle;
@property (nonatomic, strong) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *thumbsUpButton;
@property (nonatomic, assign)BOOL hasVote;
@property (nonatomic, strong)FTNewsBean *newsBean;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *voteView;

@property (nonatomic, weak)id<FTnewsDetailDelegate> delegate;

@property (nonatomic, strong)NSIndexPath *indexPath;
@end
