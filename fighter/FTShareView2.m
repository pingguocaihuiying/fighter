//
//  FTShareView2.m
//  fighter
//
//  Created by kang on 16/7/18.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTShareView2.h"
#import "Masonry.h"

#import "UMSocial.h"
#import "WXApi.h"

#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/sdkdef.h>

#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "QQShare.h"

@interface FTShareView2 ()
{
    NSInteger selectNum;
}

@property (nonatomic ,strong) UIView *panelView;
@property (nonatomic ,strong) UIImageView *backImgView;
@property (nonatomic ,strong) UIView *btnView;

@end
@implementation FTShareView2

- (id) init {
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithHex:0x191919 alpha:0.5];
        //        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        [self setFrame:[UIScreen mainScreen].bounds];
        
        [self setArray];
        [self setSubviews];
        [self setTouchEvent];
        
    }
    
    return self;
}


- (void) setArray {
    
//    _images = @[@"分享96-微信",@"分享96-朋友圈",@"分享96-QQ",@"分享96-QQ空间"];
//    _preImages = @[@"分享96-微信pre",@"分享96-朋友圈pre",@"分享96-QQpre",@"分享96-QQ空间pre"];

    _images = @[@"分享96-朋友圈",@"分享96-QQ空间"];
    _preImages = @[@"分享96-朋友圈pre",@"分享96-QQ空间pre"];
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
    _hintLabel.font=[UIFont systemFontOfSize:15];
    _hintLabel.textAlignment = NSTextAlignmentCenter;
    _hintLabel.textColor = [UIColor colorWithHex:0x828287];;
    _hintLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _hintLabel.numberOfLines = 0;
    [self setHitLabelText];
    [_panelView addSubview:_hintLabel];
    
    
    __weak UIView *weakBtnView= _btnView;
    [_hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakBtnView.mas_top).with.offset(-20);
        make.right.equalTo(weakPanel.mas_right).with.offset(-40);
        make.left.equalTo(weakPanel.mas_left).with.offset(40);
        make.height.equalTo(@36);
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
    
    //动画
    [self displayPanelViewAnimation];
}



#pragma mark - 显示余额
- (void) setHitLabelText{
    
    //第一段
    NSDictionary *attrDict1 = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor whiteColor] };
    NSAttributedString *attrStr1 = [[NSAttributedString alloc] initWithString: @"转发到 朋友圈/QQ空间，可以获得 " attributes: attrDict1];
    
    //第二段
    NSDictionary *attrDict2 = @{ NSFontAttributeName: [UIFont systemFontOfSize:15.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    
    NSAttributedString *attrStr2 = [[NSAttributedString alloc] initWithString: @"1" attributes: attrDict2];
    //第三段
    NSDictionary *attrDict3 = @{ NSFontAttributeName: [UIFont systemFontOfSize:12.0],
                                 NSForegroundColorAttributeName: [UIColor redColor] };
    
    NSAttributedString *attrStr3 = [[NSAttributedString alloc] initWithString: @"P" attributes: attrDict3];
    //第四段
    
    NSAttributedString *attrStr4 = [[NSAttributedString alloc] initWithString: @"/天" attributes: attrDict2];
    
    //合并
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: attrStr1];
    [text appendAttributedString: attrStr2];
    [text appendAttributedString: attrStr3];
    [text appendAttributedString: attrStr4];
    
    [_hintLabel setAttributedText:text];
    
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
    
    //    NSLog(@"images.count:%ld",_images.count);
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


/**
 *  显示分享视图动画
 */
- (void) displayPanelViewAnimation {
    
    [self layoutIfNeeded];
    
    CGRect pframe = _panelView.frame;
    CGPoint pCenter = _panelView.center;
    _panelView.center = CGPointMake(pCenter.x, pCenter.y+pframe.size.height);
    
    [UIView animateWithDuration:0.2
                          delay:0.0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         
                         _panelView.center = CGPointMake(pCenter.x, pCenter.y);
                     }
                     completion:nil];
    
}

/**
 *  隐藏分享视图动画
 */
- (void) hiddenPanelViewAnimation {
    
    //设定剧本
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
    scaleAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    scaleAnimation.removedOnCompletion = NO;
    //    scaleAnimation.autoreverses = YES;
    //    scaleAnimation.repeatCount = MAXFLOAT;
    scaleAnimation.duration = 0.2;
    
    //设定剧本
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.fromValue = [NSValue valueWithCGPoint:_panelView.layer.position];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(_panelView.layer.position.x, _panelView.layer.position.y + _panelView.layer.frame.size.height)];
    positionAnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    positionAnimation.removedOnCompletion = NO;
    //    scaleAnimation.autoreverses = YES;
    //    scaleAnimation.repeatCount = MAXFLOAT;
    positionAnimation.duration = 0.2;
    
    
    CAAnimationGroup *groupAnnimation = [CAAnimationGroup animation];
    groupAnnimation.duration =  0.2;
    //    groupAnnimation.autoreverses = YES;
    groupAnnimation.fillMode=kCAFillModeForwards ;//保持动画玩后的状态
    groupAnnimation.removedOnCompletion = NO;
    //    groupAnnimation.animations = @[scaleAnimation];
    groupAnnimation.animations = @[scaleAnimation,positionAnimation];
    //    groupAnnimation.repeatCount = MAXFLOAT;
    //开演
    [_panelView.layer addAnimation:groupAnnimation forKey:@"groupAnnimation"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}


#pragma mark - response methods
- (void) shareAction:(UIButton *) sender {
    //友盟分享事件统计
    [MobClick event:@"newsPage_DetailPage_share"];
    
    NSInteger btnTag = sender.tag;
    if (btnTag == 1000) {
        //微信朋友圈
        [self shareToWXWithType:WXSceneTimeline];
    }else if (btnTag == 1001) {
        //qq空间
        [self shareToTencentZone];
    }else if (btnTag == 1002) {
        //微信好友
        [self shareToWXWithType:WXSceneSession];
    }else if (btnTag == 1003) {
        //qq好友
        [self shareToTencentFriends];
    }else if (btnTag == 1004) {
        //新浪微博
        [self shareToSinaMicroBlog];
        //        [self test];
    }
    
    [self hiddenPanelViewAnimation];
}


- (void) cancelAction:(id) sender {
    
    [self hiddenPanelViewAnimation];
}


- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    
    //    [self layoutIfNeeded];
    
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:_panelView.frame toView:self];
    if (!CGRectContainsPoint(frame, point)) {
        
        [self hiddenPanelViewAnimation];
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
    
    
    QQApiNewsObject* newsObj = [self setTencentReq];
    
    // 设置分享到 QZone 的标志位
    [newsObj setCflag: kQQAPICtrlFlagQZoneShareOnStart ];
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    [self handleSendResult:sent];

//    QQShare *zoneShare = [QQShare new];
//    [zoneShare prepareToShare];
//    [zoneShare doOAuthLogin];
//    [zoneShare doMyShare];
    
}


- (QQApiNewsObject *) setTencentReq {
    
    
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
    request.userInfo = @{@"ShareMessageFrom": @"格斗东西"};
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
        message.text = [@"“" stringByAppendingFormat:@"%@”,%@ \n  --- 发自《格斗东西》app %@",_title,_summary,_url];
    }else {
        message.text = [@"“" stringByAppendingFormat:@"%@”\n  --- 发自《格斗东西》app %@",_title,_url];
    }
    
    //设置图片数据
    WBImageObject *webImage = [WBImageObject object];
    webImage.imageData = data;
    message.imageObject = webImage;
    
    
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
    
    WXWebpageObject *webpageObject = [WXWebpageObject object];
    webpageObject.webpageUrl = _url;
    message.mediaObject = webpageObject;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    [WXApi sendReq:req];
}


//获取SDWebImage缓存图片
- (NSData *) getImageDataForSDWebImageCachedKey {
    
    UIImage *image = [UIImage imageNamed:self.image];
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
    CGSize size = CGSizeMake(400, 400);
    if (data.length > 32*1000) {
        
        image = [UIImage imageWithData:data];
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0,0,size.width,size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    data = UIImageJPEGRepresentation(image, 0.5);
    return  data;
}


#pragma mark - QQ请求结果
// qq 分享回调
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
        case EQQAPISENDSUCESS:
        {
            
            NSLog(@"qq分享回调成功");
            //发送通知，告诉评论页面微信登录成功
            [[NSNotificationCenter defaultCenter] postNotificationName:QQShareResultNoti object:@"SUCESS"];
        }
            break;
        default:
        {
            break;
        }
    }
}

@end
