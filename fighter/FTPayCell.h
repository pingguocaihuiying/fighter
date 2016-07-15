//
//  FTPayCell.h
//  fighter
//
//  Created by kang on 16/7/11.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPayCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void) setPriceLabelPrice:(NSString *) price  Power:(NSString *) power;

@end
