//
//  FTPropertyCell.h
//  fighter
//
//  Created by kang on 16/8/2.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTPropertyCell : UITableViewCell

//content views
@property (weak, nonatomic) IBOutlet UIView *nameView;

@property (weak, nonatomic) IBOutlet UIView *sexView;

@property (weak, nonatomic) IBOutlet UIView *heightView;

@property (weak, nonatomic) IBOutlet UIView *weightView;

@property (weak, nonatomic) IBOutlet UIView *locationView;


// property labels
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightLabel;

@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@end
