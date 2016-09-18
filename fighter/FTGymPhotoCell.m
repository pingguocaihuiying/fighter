//
//  FTGymPhotoCell.m
//  fighter
//
//  Created by kang on 16/9/12.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTGymPhotoCell.h"
#import "UIRemoveImageView.h"
#import "FTCameraAndAlbum.h"
#import "UIImage+LabelImage.h"
#import "FTGymCommentViewController.h"

@interface FTGymPhotoCell() <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    NSInteger imageCount;
    NSInteger horizontalLines;//横向
    NSInteger verticalLines;// 纵向
    
}

@end

@implementation FTGymPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
//    self.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void) addPhotoToContainer:(UIImage *) image {
    
    if (image != nil) {
        
        
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80)];
//        imageView.frame = CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80);
        [imageView setImage:image];
        [self.photoContainer addSubview:imageView];
        [imageView setNeedsDisplay];
        
        
        horizontalLines++;
        if (horizontalLines >= 4) {
            verticalLines ++;
            horizontalLines = 0;
            
            if (self.cellDelegate ) {
                [self.cellDelegate endEditCell];
            }
        }
    }
    
     [self setAddPhotoBtnFrame];
}


- (void) setPhotoContainerWithArray:(NSMutableArray *)photos {
    
    verticalLines = 0;
    horizontalLines = 0;
    for (UIImage *image in photos) {
        
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80)];
        [imageView setImage:image];
        [self.photoContainer addSubview:imageView];
        [imageView setNeedsDisplay];
        
        horizontalLines++;
        if (horizontalLines >= 4) {
            verticalLines ++;
            horizontalLines = 0;
            
        }
        
    }
    
    [self setAddPhotoBtnFrame];
    
}

- (void) setAddPhotoBtnFrame {
    
//    [self.addPhotoBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topConstraint.constant = 95 * verticalLines;
    self.leadConstraint.constant = 85 * horizontalLines;
//    self.addPhotoBtn.frame = CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80);
    
}



@end
