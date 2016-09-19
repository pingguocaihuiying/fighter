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
#import "UIRemoveImageView.h"

@interface FTGymPhotoCell() <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIImageViewDelegate>
{

    NSInteger imageCount;
    NSInteger horizontalLines;//横向
    NSInteger verticalLines;// 纵向
    NSMutableArray *imageViews;
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
    
    if (!imageViews) {
        imageViews = [[NSMutableArray alloc]init];
    }
    
    if (image != nil) {
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80)];
        [imageView setImage:image];
        imageView.delegate = self;
        [self.photoContainer addSubview:imageView];
        [imageViews addObject:imageView];
        
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
    
    
    if (!imageViews) {
        imageViews = [[NSMutableArray alloc]init];
    }
    
    // 重新加载cell时，先删除之前添加的Imageview
    [self clearContainer];
    
    // 横纵行号归零
    verticalLines = 0;
    horizontalLines = 0;
    
    for (UIImage *image in photos) {
        
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80)];
        [imageView setImage:image];
        imageView.delegate = self;
        [self.photoContainer addSubview:imageView];
        [imageViews addObject:imageView];
        
        horizontalLines++;
        if (horizontalLines >= 4) {
            verticalLines ++;
            horizontalLines = 0;
        }
    }
    
    // 约束添加按钮
    [self setAddPhotoBtnFrame];
    
}

- (void) clearContainer {

    for (UIImageView *imageView in imageViews) {
        
        [imageView removeFromSuperview];
        
    }

}

- (void) setAddPhotoBtnFrame {
    
//    [self.addPhotoBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topConstraint.constant = 95 * verticalLines;
    self.leadConstraint.constant = 85 * horizontalLines;
//    self.addPhotoBtn.frame = CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80);
    
}



#pragma mark - UIImageViewDelegate

- (void) removeImage:(UIImage *)image{
    
    if (self.cellDelegate ) {
        [self.cellDelegate removeSubView:image];
        [self.cellDelegate endEditCell];
    }
    
}


- (void) showRemoveButton {
    
    for (UIRemoveImageView *imageView in imageViews) {
        
        [imageView showButton];
        
    }
}

- (void) hideRemoveButton {
    
    for (UIRemoveImageView *imageView in imageViews) {
        
        [imageView hideButton];
        
    }
    
}


@end
