//
//  FTShareView.m
//  fighter
//
//  Created by kang on 16/5/31.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShareView.h"
#import "Masonry.h"

#import "UMSocial.h"
#import "WXApi.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/sdkdef.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"


@interface FTShareView ()
{
    NSInteger selectNum;
    
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIImageView *backImgView;
@property (nonatomic ,strong) UIView *btnView;

@end

@implementation FTShareView

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setArray];
        [self setSubviews];
        [self setTouchEvent];
        
        
    }
    
    return self;
}


- (void) setArray {

    _images = @[@"分享96-微信",@"分享96-朋友圈",@"分享96-QQ",@"分享96-QQ空间",@"分享96-新浪"];
    _preImages = @[@"分享96-微信pre",@"分享96-朋友圈pre",@"分享96-QQpre",@"分享96-QQ空间pre",@"分享96-新浪pre"];
}

- (void) setSubviews {
    
    //面板
    _panelView = [[UIView alloc] init];
    _panelView.backgroundColor = [UIColor clearColor];
    _panelView.opaque = NO;
    [self addSubview:_panelView];
    
    
    CGRect frame = self.frame;
//    __weak __typeof(self) weakSelf = self;
//    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-15);
//        make.right.equalTo(weakSelf.mas_right).with.offset(-6);
//        make.left.equalTo(weakSelf.mas_left).with.offset(6);
//        make.height.equalTo(@250);
//        
//    }];
    
    //边框
    _backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width-20, frame.size.height/3)];
    [_backImgView setImage:[UIImage imageNamed:@"金属边框-改进ios"]];
    [_backImgView setBackgroundColor:[UIColor colorWithHex:0x191919]];
    [_panelView addSubview:_backImgView];
    
    __weak UIView *weakPanel= _panelView;
    [_backImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakPanel.mas_bottom).with.offset(0);
        make.right.equalTo(weakPanel.mas_right).with.offset(0);
        make.left.equalTo(weakPanel.mas_left).with.offset(0);
        make.top.equalTo(weakPanel).with.offset(0);;
        
    }];
    
    
    //取消按钮
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取   消" forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios"] forState:UIControlStateNormal];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"主要按钮背景ios-pre"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self  action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_panelView addSubview:_cancelBtn];
    
    __weak UIImageView *weakBackImg= _backImgView;
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBackImg.mas_bottom).with.offset(-21);
        make.right.equalTo(weakBackImg.mas_right).with.offset(-19);
        make.left.equalTo(weakBackImg.mas_left).with.offset(19);
        make.height.equalTo(@45);
    }];
    
    
    
    //设置分享按钮
    [self setButtons];
    
    
    //显示label
    _hintLabel = [[UILabel alloc]init];
    _hintLabel.font=[UIFont systemFontOfSize:16];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.textColor = [UIColor colorWithHex:0x828287];;
    _hintLabel.text = @"分享至";
    [_panelView addSubview:_hintLabel];
    
     __weak UIView *weakBtnView= _btnView;
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBtnView.mas_top).with.offset(-20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@15);
    }];
    
    
    
    //添加_panelView 约束
    __weak __typeof(self) weakSelf = self;
     __weak UILabel *weakLabel = _hintLabel;
    [_panelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mas_bottom).with.offset(-10);
        make.right.equalTo(weakSelf.mas_right).with.offset(-6);
        make.left.equalTo(weakSelf.mas_left).with.offset(6);
        make.top.equalTo(weakLabel.mas_top).with.offset(-20);
        
    }];
}



/**
 *  set share button in a UIView
 */
- (void) setButtons {

    _btnView = [[UIView alloc]init];
    [_panelView addSubview:_btnView];
    
    __weak UIImageView *weakBackImg= _backImgView;
    __weak UIButton *weakButton= _cancelBtn;
    [_btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakButton.mas_top).with.offset(-20);
        make.right.equalTo(weakBackImg.mas_right).with.offset(0);
        make.left.equalTo(weakBackImg.mas_left).with.offset(0);
        make.height.equalTo(@48);
    }];
    
    NSLog(@"images.count:%ld",_images.count);
    CGFloat space = (SCREEN_WIDTH - 12 - _images.count *48)/(_images.count+1);
    for (int i =0; i < _images.count ; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(space + (space +48) *i, 0, 48, 48);
        [button setBackgroundImage:[UIImage imageNamed:[_images objectAtIndex:i]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[_preImages objectAtIndex:i]] forState:UIControlStateHighlighted];
        [button addTarget:self  action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 1000+i;
        
        [_btnView addSubview:button];
    }
}


/**
 *  add tap touch event
 */
- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}


#pragma mark - response methods

- (void) shareAction:(UIButton *) sender {
    //友盟分享事件统计
    [MobClick event:@"newsPage_DetailPage_share"];
    
    NSInteger btnTag = sender.tag;
    if (btnTag == 1000) {
        //微信好友
        [self shareToWXWithType:WXSceneSession];
        
    }else if (btnTag == 1001) {
        //微信朋友圈
        [self shareToWXWithType:WXSceneTimeline];

    }else if (btnTag == 1002) {
        //qq好友
        [self shareToTencentFriends];
    }else if (btnTag == 1003) {
        //qq空间
        [self shareToTencentZone];
    }else if (btnTag == 1004) {
        //新浪微博
        [self shareToSinaMicroBlog];
//        [self test];
    }

    [self removeFromSuperview];
}


- (void) cancelAction:(id) sender {

    [self removeFromSuperview];
}


- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        [self removeFromSuperview];
    }
}

#pragma mark - share method

/**
 *  qq好友分享
 */
- (void) shareToTencentFriends {
    
    
    QQApiNewsObject* imgObj = [self setTencentReq];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
    
}

/**
 *  qq空间分享
 */
- (void) shareToTencentZone {
    
    
    
    QQApiNewsObject* imgObj = [self setTencentReq];
    
    // 设置分享到 QZone 的标志位
    [imgObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];
}


- (QQApiNewsObject *) setTencentReq {
    
//    // 设置预览图片
//    NSURL *previewURL = [NSURL URLWithString:_imageUrl];
//    //设置分享链接
//    NSURL* url = [NSURL URLWithString: _url];
//    
//    QQApiNewsObject* imgObj = [QQApiNewsObject objectWithURL:url
//                                                       title: _title
//                                                 description: _summary
//                                             previewImageURL:previewURL];
    
    //设置分享链接
    NSURL* url = [NSURL URLWithString: _url];
    
    QQApiNewsObject* imgObj = [[QQApiNewsObject alloc]initWithURL:url
                                                            title:_title
                                                      description:_summary
                                                 previewImageData:[self getImageDataForSDWebImageCachedKey]
                                                targetContentType:QQApiURLTargetTypeNews];

    return imgObj;
}



/**
 *  新浪微博分享
 */
- (void) shareToSinaMicroBlog {

    //分享到微博博文
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = _url;
    authRequest.scope = [NSString stringWithFormat:@"%@,%@,%@",_title,_summary,_image];
    
    WBSendMessageToWeiboRequest *request =
    [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare]
                                           authInfo:authRequest
                                       access_token:myDelegate.wbtoken];
    
//    request.userInfo = @{@"ShareMessageFrom": @"--- 发自《格斗家》app",
//                         @"Other_Info_1": [NSNumber numberWithInt:123],
//                         @"Other_Info_2": @[@"obj1", @"obj2"],
//                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}
//                         };
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
    
}


- (void) test {

    //分享到微博博文
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = _url;
    authRequest.scope = [NSString stringWithFormat:@"%@,%@,%@",_title,_summary,_image];
    
    
    //设置文本信息
    WBMessageObject *message = [WBMessageObject message];
    if (_summary) {
        message.text = [@"“" stringByAppendingFormat:@"%@”,%@ \n  --- 发自《格斗家》app %@",_title,_summary,_url];
    }else {
        message.text = [@"“" stringByAppendingFormat:@"%@”\n  --- 发自《格斗家》app %@",_title,_url];
    }
    
    NSLog(@"url:%@ length:%ld",_url,_url.length);
    //设置媒体数据
    WBVideoObject *webpage = [WBVideoObject object];
    webpage.objectID = @"identifier1";
    webpage.title = _title;
    webpage.description = _summary;
    webpage.videoUrl = _url;
    webpage.videoStreamUrl = _url;
    webpage.videoLowBandUrl = _url;
    webpage.videoLowBandStreamUrl = _url;
    message.mediaObject = webpage;
    
    WBSendMessageToWeiboRequest *request =
    [WBSendMessageToWeiboRequest requestWithMessage:message
                                           authInfo:authRequest
                                       access_token:myDelegate.wbtoken];
    
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];

}


- (void) shareToSinaFriends {

    //分享给微博好友
    WBMessageObject *message = [WBMessageObject message];
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"";
    webpage.title = _title;
    webpage.description = [NSString stringWithFormat:NSLocalizedString(_summary, nil), [[NSDate date] timeIntervalSince1970]];
    webpage.thumbnailData = [self getImageDataForSDWebImageCachedKey];

    webpage.webpageUrl = _url;
    message.mediaObject = webpage;

    WBShareMessageToContactRequest *request = [WBShareMessageToContactRequest requestWithMessage:message];
    request.userInfo = @{@"ShareMessageFrom": @"格斗家"};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

/**
 *  设置新浪微博分享信息
 *
 *  @return
 */
- (WBMessageObject *)messageToShare
{
    NSData* data = [self getImageDataForSDWebImageCachedKey];

    if (_summary.length > 48) {
        _summary = [[_summary substringToIndex:47] stringByAppendingString:@"..."];
    }
    //设置文本信息
    WBMessageObject *message = [WBMessageObject message];
    if (_summary) {
         message.text = [@"“" stringByAppendingFormat:@"%@”,%@ \n  --- 发自《格斗家》app %@",_title,_summary,_url];
    }else {
         message.text = [@"“" stringByAppendingFormat:@"%@”\n  --- 发自《格斗家》app %@",_title,_url];
    }
    
    //设置图片数据
    WBImageObject *webImage = [WBImageObject object];
    webImage.imageData = data;
    message.imageObject = webImage;
    
//    //设置媒体数据
//    WBWebpageObject *webpage = [WBWebpageObject object];
//    webpage.objectID = @"identifier1";
//    webpage.title = _title;
//    webpage.description = _summary;
//    webpage.thumbnailData =data; //data size can`t be over 32 KB
//    webpage.webpageUrl = _url;
//    message.mediaObject = webpage;

    return message;
}

/**
 *  微信分享
 *
 *  @param scene
 */
- (void)shareToWXWithType:(int) scene{
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = _title;
    message.description = _summary;
    
    NSData *data = [self getImageDataForSDWebImageCachedKey];
    [message setThumbData:data];
    
//    WXImageObject *imageObj = [WXImageObject object];
//    imageObj.imageData = [self getImageDataForSDWebImageCachedKey];
//    message.mediaObject = imageObj;
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _url;
    message.mediaObject = webpageObject;
//
//    WXVideoObject *videoObj = [WXVideoObject object];
//    videoObj.videoUrl = _url;
//    message.mediaObject = videoObj;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


//获取SDWebImage缓存图片
- (NSData *) getImageDataForSDWebImageCachedKey {

    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:_imageUrl]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    NSData *data = UIImageJPEGRepresentation(image, 1);
   
    if (data == nil || data.length == 0) {
        UIImage *iconImg = [UIImage imageNamed:@"微信用@200"];
        data = UIImageJPEGRepresentation(iconImg, 1);
    }
    int i = 1;
    while (data.length > 32*1000) {
//        NSLog(@"NSData.length:%ld",data.length);
        data = UIImageJPEGRepresentation(image, 1-i/10);
        i++;
    }

    return  data;
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}




@end
