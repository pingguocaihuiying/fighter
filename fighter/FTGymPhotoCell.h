//
//  FTGymPhotoCell.h
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTPracticeViewController.h"
#import "CellDelegate.h"

@interface FTGymPhotoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *photoContainer;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoBtn;
@property (nonatomic, weak) id<TeachDelegate> delegate;
@property (nonatomic, weak) id<CellDelegate> cellDelegate;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

- (void) addPhotoToContainer:(UIImage *) image  type:(FTMediaType) mediaType;
//- (void) addPhotoToContainer:(UIImage *) image;
- (void) setPhotoContainerWithArray:(NSMutableArray *)photos;
- (void) setAddPhotoBtnFrame;
- (void) clearContainer;

@end
