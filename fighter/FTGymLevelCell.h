//
//  FTGymLevelCell.h
//  fighter
//
//  Created by kang on 16/9/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTGymLevelCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelImage1;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage2;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage3;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage4;
@property (weak, nonatomic) IBOutlet UIImageView *levelImage5;

@property (nonatomic, strong) NSArray *imagesViews;

@end
