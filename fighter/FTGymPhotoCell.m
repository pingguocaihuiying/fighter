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


- (void) addPhotoToContainer:(UIImage *) image  type:(FTMediaType) mediaType{
    
    if (!imageViews) {
        imageViews = [[NSMutableArray alloc]init];
    }
    
    if (image != nil) {
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 *SCALE * horizontalLines, 95 *SCALE * verticalLines, 80 *SCALE, 80 *SCALE)];
        [imageView setImage:image];
        imageView.delegate = self;
        [self.photoContainer addSubview:imageView];
        
        if (mediaType == FTMediaTypeVedio) {
            [imageView setVedioImage];
        }
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

// 重新加载照片和视频
- (void) setPhotoContainerWithArray:(NSMutableArray *)photos {
    
    if (!imageViews) {
        imageViews = [[NSMutableArray alloc]init];
    }
    
    // 重新加载cell时，先删除之前添加的Imageview
    [self clearContainer];
    
    // 横纵行号归零
    verticalLines = 0;
    horizontalLines = 0;
    
    for (NSDictionary *dic in photos) {
        
        UIImage *image = dic[@"image"];
        UIRemoveImageView *imageView = [[UIRemoveImageView alloc]initWithFrame:CGRectMake(85 *SCALE * horizontalLines, 95 *SCALE * verticalLines, 80 *SCALE, 80 *SCALE)];
        [imageView setImage:image];
        imageView.delegate = self;
        
        // 判断是否是视频
        NSString *typeString = dic[@"type"];
        if ([typeString isEqualToString:@"video"]) {
            [imageView setVedioImage];
        }
        
        
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


// 清除所有照片视频
- (void) clearContainer {

    for (UIImageView *imageView in imageViews) {
        
        [imageView removeFromSuperview];
        
    }

}


- (void) setAddPhotoBtnFrame {
    
//    [self.addPhotoBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topConstraint.constant = 95 * verticalLines *SCALE;
    self.leadConstraint.constant = 85 * horizontalLines *SCALE;
    self.buttonWidthConstraint.constant = 80 *SCALE;
    self.buttonHeightConstraint.constant = 80 *SCALE;
    
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
