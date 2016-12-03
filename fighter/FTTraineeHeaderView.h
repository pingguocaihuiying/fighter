//
//  FTTraineeHeaderView.h
//  fighter
//
//  Created by kang on 2016/11/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 学员collection view section headerView
 */
@interface FTTraineeHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberLabel;
@end
