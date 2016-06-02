//
//  UIImage+FTLYZImage.h
//  fighter
//
//  Created by Liyz on 5/31/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FTLYZImage)
+(UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
+ (void)blurImage:(UIImageView *)imageView;
@end
