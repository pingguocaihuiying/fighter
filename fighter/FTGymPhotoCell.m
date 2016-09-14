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
- (IBAction)addPhotoAction:(id)sender {
    FTCameraAndAlbum *cameraView = [[FTCameraAndAlbum alloc]init];
    [cameraView.albumBtn addTarget:self action:@selector(albumBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [cameraView.cameraBtn addTarget:self action:@selector(cameraBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    //    cameraView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:cameraView];
}


- (void) cameraBtnAction :(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.delegate pressentController:_imgPickerController];
    }
}

- (void) albumBtnAction:(id) sender {
    
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
    
    if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear]) {
        
        UIImagePickerController * _imgPickerController = [[UIImagePickerController alloc]init];
        _imgPickerController.delegate = self;
        _imgPickerController.allowsEditing = YES;
        _imgPickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.delegate pressentController:_imgPickerController];
    }
    [[[(UIButton *)sender superview] superview] removeFromSuperview];
}

#pragma mark  - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    NSLog(@"pics:%@",info);
    UIImage *editImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *img = [UIImage editImage:editImage side:200];
    
    [self setImageViewContainer:img];
    [self setAddPhotoBtnFrame];
}


- (void) setImageViewContainer:(UIImage *) image {
    
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
        }
    }
}

- (void) setAddPhotoBtnFrame {
    
//    [self.addPhotoBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.topConstraint.constant = 95 * verticalLines;
    self.leadConstraint.constant = 85 * horizontalLines;
//    self.addPhotoBtn.frame = CGRectMake(85 * horizontalLines, 95 * verticalLines, 80, 80);
    
}



@end
