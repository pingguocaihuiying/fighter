//
//  FTTaskShareCell.m
//  fighter
//
//  Created by kang on 16/8/19.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTTaskShareCell.h"
#import "UIView+UIViewController.h"
#import "FTPayViewController.h"
#import "FTBaseNavigationViewController.h"
#import "WXApi.h"

@implementation FTTaskShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//    self.contentView.alpha = 0.5;
//    self.contentView.opaque = NO;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - button response
// 每日任务分享按钮，当前每日分享任务只分享到微信朋友圈，而且地址和图标都是写死的
- (IBAction)shareBtnAction:(id)sender {
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"我在“格斗东西”学习拳击，Fighting！";
    message.description = @"格斗技术为强身健体自卫防身，格斗东西团队不支持不赞成任何暴力行为。";
    
    NSData *data = [self getImageDataForSDWebImageCachedKey];
    [message setThumbData:data];
    
    
    NSString *str = @"objId=309&tableName=c-videos";
    NSString *webUrlString = [@"http://www.gogogofight.com/page/v2/video_paid_wechat_page.html?" stringByAppendingString:str];
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = webUrlString;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
    
    
}

- (IBAction)rechargeBtnAction:(id)sender {
    
    
    FTPayViewController *payVC = [[FTPayViewController alloc]init];
    FTBaseNavigationViewController *baseNav = [[FTBaseNavigationViewController alloc]initWithRootViewController:payVC];
    baseNav.navigationBarHidden = NO;
    [self.viewController presentViewController:baseNav animated:YES completion:nil];
    
}


#pragma mark - private
//获取SDWebImage缓存图片
- (NSData *) getImageDataForSDWebImageCachedKey {
    
    UIImage *image = [UIImage imageNamed:@"share-Boxing"];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    
    if (data == nil || data.length == 0) {
        UIImage *iconImg = [UIImage imageNamed:@"微信用@200"];
        data = UIImageJPEGRepresentation(iconImg, 1);
        
        int i = 1;
        while (data.length > 32*1000) {
            data = UIImageJPEGRepresentation(iconImg, 1-i/10);
            i++;
        }
        return data;
    }
    
    int i = 9;
    
    // 第一次压缩
    while (data.length > 32*1000 && i > 0) {
        data = UIImageJPEGRepresentation(image, 0.1*i);
        i--;
    }
    
    // 第一次压缩
    int j = 9;
    while (data.length > 32*1000 && j > 0) {
        data = UIImageJPEGRepresentation(image, 0.01*j);
        j--;
    }
    
    // 如果压缩之后还是太大，裁剪图片
    int k = 0;
    while (data.length > 32*1000 ) {
        
        CGSize size = CGSizeMake(400/(k+1) , 400/(k+1));
        image = [UIImage imageWithData:data];
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        data = UIImageJPEGRepresentation(image, 0.5);
        
        k++;
    }
    
    
    return  data;
}






@end
