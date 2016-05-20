//
//  FTArenaTextTableViewCell.h
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTBaseTableViewCell.h"

@interface FTArenaTextTableViewCell : FTBaseTableViewCell
- (void)setWithBean:(FTNewsBean *)bean;
@property (weak, nonatomic) IBOutlet UILabel *sumupLabel;
@property (weak, nonatomic) IBOutlet UILabel *theTitle;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *authorIdentifierImageView;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;

@end
