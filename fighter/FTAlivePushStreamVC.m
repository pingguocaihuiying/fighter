//
//  FTAlivePushStreamVC.m
//  fighter
//
//  Created by kang on 16/6/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTAlivePushStreamVC.h"
#import <PLCameraStreamingKit/PLCameraStreamingKit.h>
//#import "Reachability.h"

const char *stateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnecting",
    "Disconnected",
    "Error"
};

const char *networkStatus[] = {
    "Not Reachable",
    "Reachable via WiFi",
    "Reachable via CELL"
};

#define kReloadConfigurationEnable  0

// 假设在 videoFPS 低于预期 50% 的情况下就触发降低推流质量的操作，这里的 40% 是一个假定数值，你可以更改数值来尝试不同的策略
#define kMaxVideoFPSPercent 0.5

// 假设当 videoFPS 在 10s 内与设定的 fps 相差都小于 5% 时，就尝试调高编码质量
#define kMinVideoFPSPercent 0.05
#define kHigherQualityTimeInterval  10

#define kBrightnessAdjustRatio  1.03
#define kSaturationAdjustRatio  1.03


@interface FTAlivePushStreamVC ()
<
PLCameraStreamingSessionDelegate,
PLStreamingSendingBufferDelegate
>

@property (nonatomic, strong) PLCameraStreamingSession  *session;
@property (nonatomic, strong) RealReachability *internetReachability;
@property (nonatomic, assign)ReachabilityStatus netStatus;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) NSArray<PLVideoCaptureConfiguration *>   *videoCaptureConfigurations;
@property (nonatomic, strong) NSArray<PLVideoStreamingConfiguration *>   *videoStreamingConfigurations;
@property (nonatomic, strong) NSDate    *keyTime;
@property (nonatomic, strong) NSMutableArray *filterHandlers;

@end

@implementation FTAlivePushStreamVC

#pragma mark - lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
        
    // 预先设定几组编码质量，之后可以切换
    CGSize videoSize = CGSizeMake(480 , 640);
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation <= AVCaptureVideoOrientationLandscapeLeft) {
        if (orientation > AVCaptureVideoOrientationPortraitUpsideDown) {
            videoSize = CGSizeMake(640 , 480);
        }
    }
    self.videoStreamingConfigurations = @[
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize
                                                                      expectedSourceVideoFrameRate:15
                                                                          videoMaxKeyframeInterval:45
                                                                               averageVideoBitRate:800 * 1000
                                                                                 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:CGSizeMake(800 , 480) expectedSourceVideoFrameRate:24 videoMaxKeyframeInterval:72
                                                                               averageVideoBitRate:800 * 1000
                                                                                 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          
                                          [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize
                                                                      expectedSourceVideoFrameRate:30
                                                                          videoMaxKeyframeInterval:90
                                                                               averageVideoBitRate:800 * 1000
                                                                                 videoProfileLevel:AVVideoProfileLevelH264Baseline31],
                                          ];
//    self.videoCaptureConfigurations = @[
//                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:15
//                                                                                      sessionPreset:AVCaptureSessionPresetiFrame960x540
//                                                                horizontallyMirrorFrontFacingCamera:YES
//                                                                 horizontallyMirrorRearFacingCamera:NO],
//                                        
//                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:24
//                                                                                      sessionPreset:AVCaptureSessionPresetiFrame960x540
//                                                                horizontallyMirrorFrontFacingCamera:YES
//                                                                 horizontallyMirrorRearFacingCamera:NO],
//                                        
//                                        [[PLVideoCaptureConfiguration alloc] initWithVideoFrameRate:30
//                                                                                      sessionPreset:AVCaptureSessionPresetiFrame960x540
//                                                                horizontallyMirrorFrontFacingCamera:YES
//                                                                 horizontallyMirrorRearFacingCamera:NO]
//                                        ];
    self.sessionQueue = dispatch_queue_create("pili.queue.streaming", DISPATCH_QUEUE_SERIAL);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
    
    self.netStatus = [GLobalRealReachability currentReachabilityStatus];
    NSLog(@"currentStatus:%@,", @(_netStatus));
    
    
//    // 网络状态监控
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
//    self.internetReachability = [Reachability reachabilityForInternetConnection];
//    [self.internetReachability startNotifier];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleInterruption:)
                                                 name:AVAudioSessionInterruptionNotification
                                               object:[AVAudioSession sharedInstance]];
    
    // PLCameraStreamingKit 使用开始
    // streamJSON 是从服务端拿回的
    //
    // 从服务端拿回的 streamJSON 结构如下：
    //        @{@"id": @"stream_id",
    //          @"title": @"stream_title",
    //          @"hub": @"hub_name",
    //          @"publishKey": @"publish_key",
    //          @"publishSecurity": @"dynamic", // or static
    //          @"disabled": @(NO),
    //          @"profiles": @[@"480p", @"720p"],// or empty Array []
    //          @"hosts": @{
    //                  ...
    //          }
//# warning 如果要运行 demo 这里应该填写服务端返回的某个流的 json 信息
    
//    1.你们的七牛账户
//    2.hub（自定义的直播应用名，是直播流的集合，4到100字符，英文数字以及-_组成）
//    3.你们用于直播的已经ICP备案的域名
    NSDictionary *streamJSON =  @{@"id": @"stream_id",
                                  @"title": @"stream_title",
                                  @"hub": @"hub_name",
                                  @"publishKey": @"publish_key",
                                  @"publishSecurity": @"dynamic", // or static
                                  @"disabled": @(NO),
                                  @"profiles": @[@"480p", @"720p"],    // or empty Array []
                                  @"hosts": @[@"http://www.gogogofight.com/",@"http://www.gogogofight.com/"]
                                  };
    
    PLStream *stream = [PLStream streamWithJSON:streamJSON];
    
    void (^permissionBlock)(void) = ^{
        dispatch_async(self.sessionQueue, ^{
            PLVideoCaptureConfiguration *videoCaptureConfiguration = [self.videoCaptureConfigurations lastObject];
            PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
            // 视频编码配置
            PLVideoStreamingConfiguration *videoStreamingConfiguration = [self.videoStreamingConfigurations lastObject];
            // 音频编码配置
            PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
            AVCaptureVideoOrientation orientation = (AVCaptureVideoOrientation)(([[UIDevice currentDevice] orientation] <= UIDeviceOrientationLandscapeRight && [[UIDevice currentDevice] orientation] != UIDeviceOrientationUnknown) ? [[UIDevice currentDevice] orientation]: UIDeviceOrientationPortrait);
            
            // 推流 session
            self.session = [[PLCameraStreamingSession alloc]
                            initWithVideoCaptureConfiguration:videoCaptureConfiguration
                            audioCaptureConfiguration:audioCaptureConfiguration
                            videoStreamingConfiguration:videoStreamingConfiguration
                            audioStreamingConfiguration:audioStreamingConfiguration
                            stream:stream
                            videoOrientation:orientation];
            
            
            self.session.delegate = self;
            self.session.bufferDelegate = self;
            UIImage *waterMark = [UIImage imageNamed:@"qiniu.png"];
            PLFilterHandler handler = [self.session addWaterMark:waterMark origin:CGPointMake(100, 300)];
            self.filterHandlers = [@[handler] mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIView *previewView = self.session.previewView;
                previewView.autoresizingMask = UIViewAutoresizingFlexibleHeight| UIViewAutoresizingFlexibleWidth;
                [self.view insertSubview:previewView atIndex:0];
                self.zoomSlider.minimumValue = 1;
                self.zoomSlider.maximumValue = MIN(5, self.session.videoActiveFormat.videoMaxZoomFactor);
                
                NSString *log = [NSString stringWithFormat:@"Zoom Range: [1..%.0f]", self.session.videoActiveFormat.videoMaxZoomFactor];
                NSLog(@"%@", log);
                self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
            });
        });
    };
    
    void (^noAccessBlock)(void) = ^{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"No Access", nil)
                                                            message:NSLocalizedString(@"!", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
    };
    
    switch ([PLCameraStreamingSession cameraAuthorizationStatus]) {
        case PLAuthorizationStatusAuthorized:
            permissionBlock();
            break;
        case PLAuthorizationStatusNotDetermined: {
            [PLCameraStreamingSession requestCameraAccessWithCompletionHandler:^(BOOL granted) {
                granted ? permissionBlock() : noAccessBlock();
            }];
        }
            break;
        default:
            noAccessBlock();
            break;
    }
        
}

- (void)dealloc {
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kRealReachabilityChangedNotification
                                                  object:nil];
    
    dispatch_sync(self.sessionQueue, ^{
        [self.session destroy];
    });
    self.session = nil;
    self.sessionQueue = nil;
}


#pragma mark - response 

#pragma mark - Notification Handler
/*!
 * Called by Reachability whenever status changes.
 */
- (void)networkChanged:(NSNotification *)notification
{
    RealReachability *reachability = (RealReachability *)notification.object;
    self.netStatus = [reachability currentReachabilityStatus];
    
    if (self.netStatus == RealStatusNotReachable)
    {
        // 对断网情况做处理
        [self stopSession];
    }
    
    if (self.netStatus == RealStatusViaWiFi)
    {
        NSLog(@"Network wifi! Free!");
    }
    
    if (self.netStatus == RealStatusViaWWAN)
    {
        NSLog(@"Network WWAN! In charge!");
        WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
        if (accessType == WWANType2G)
        {
            NSLog(@"RealReachabilityStatus2G");
        }
        else if (accessType == WWANType3G)
        {
            NSLog(@"RealReachabilityStatus3G");
        }
        else if (accessType == WWANType4G)
        {
            NSLog(@"RealReachabilityStatus4G");
        }
        else
        {
            NSLog(@"Unknown RealReachability WWAN Status, might be iOS6");
        }
    }
    
    NSString *log = [NSString stringWithFormat:@"Networkt Status: %s", networkStatus[_netStatus]];
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}



- (void)handleInterruption:(NSNotification *)notification {
    if ([notification.name isEqualToString:AVAudioSessionInterruptionNotification]) {
        NSLog(@"Interruption notification");
        
        if ([[notification.userInfo valueForKey:AVAudioSessionInterruptionTypeKey] isEqualToNumber:[NSNumber numberWithInt:AVAudioSessionInterruptionTypeBegan]]) {
            NSLog(@"InterruptionTypeBegan");
        } else {
            // the facetime iOS 9 has a bug: 1 does not send interrupt end 2 you can use application become active, and repeat set audio session acitve until success.  ref http://blog.corywiles.com/broken-facetime-audio-interruptions-in-ios-9
            NSLog(@"InterruptionTypeEnded");
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
        }
    }
}





#pragma mark - button action
- (IBAction)segmentedControlValueDidChange:(id)sender {
    PLVideoCaptureConfiguration *videoCaptureConfiguration = self.videoCaptureConfigurations[self.segementedControl.selectedSegmentIndex];
    
    [self.session reloadVideoStreamingConfiguration:self.session.videoStreamingConfiguration videoCaptureConfiguration:videoCaptureConfiguration];
}

- (IBAction)zoomSliderValueDidChange:(id)sender {
    self.session.videoZoomFactor = self.zoomSlider.value;
}

- (IBAction)actionButtonPressed:(id)sender {
    if (PLStreamStateConnected == self.session.streamState) {
        [self stopSession];
    } else {
        [self startSession];
    }
}

- (IBAction)toggleCameraButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        [self.session toggleCamera];
    });
}

- (IBAction)torchButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        self.session.torchOn = !self.session.isTorchOn;
    });
}

- (IBAction)muteButtonPressed:(id)sender {
    dispatch_async(self.sessionQueue, ^{
        self.session.muted = !self.session.isMuted;
    });
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - private method 

#pragma mark  Operation
- (void)stopSession {
    dispatch_async(self.sessionQueue, ^{
        self.keyTime = nil;
        [self.session stop];
    });
}

- (void)startSession {
    self.keyTime = nil;
    self.actionButton.enabled = NO;
    dispatch_async(self.sessionQueue, ^{
        [self.session startWithCompleted:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.actionButton.enabled = YES;
            });
        }];
    });
}


#pragma mark 设置video质量

- (void)higherQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (idx >= self.videoStreamingConfigurations.count - 1) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx + 1];
    PLVideoCaptureConfiguration *newCaptureConfiguration = self.videoCaptureConfigurations[idx + 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:newCaptureConfiguration];
}

- (void)lowerQuality {
    NSUInteger idx = [self.videoStreamingConfigurations indexOfObject:self.session.videoStreamingConfiguration];
    NSAssert(idx != NSNotFound, @"Oops");
    
    if (0 == idx) {
        return;
    }
    PLVideoStreamingConfiguration *newStreamingConfiguration = self.videoStreamingConfigurations[idx - 1];
    PLVideoCaptureConfiguration *newCaptureConfiguration = self.videoCaptureConfigurations[idx - 1];
    [self.session reloadVideoStreamingConfiguration:newStreamingConfiguration videoCaptureConfiguration:newCaptureConfiguration];
}


#pragma mark  - delegate
#pragma mark  <PLStreamingSendingBufferDelegate>

- (void)streamingSessionSendingBufferDidFull:(id)session {
    NSString *log = @"Buffer is full";
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}

- (void)streamingSession:(id)session sendingBufferDidDropItems:(NSArray *)items {
    NSString *log = @"Frame dropped";
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
}

#pragma mark  <PLCameraStreamingSessionDelegate>
/**
 *  当流状态变更为非 Error 时，会回调到这里
 *
 *  @param session <#session description#>
 *  @param state   <#state description#>
 */
- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSString *log = [NSString stringWithFormat:@"Stream State: %s", stateNames[state]];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    
    // 除 PLStreamStateError 外的其余状态会回调在这个方法
    // 这个回调会确保在主线程，所以可以直接对 UI 做操作
    if (PLStreamStateConnected == state) {
        [self.actionButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    } else if (PLStreamStateDisconnected == state) {
        [self.actionButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    }
}

/**
 *  当流状态变为 Error, 会携带 NSError 对象回调这个方法
 *
 *  @param session <#session description#>
 *  @param error   <#error description#>
 */
- (void)cameraStreamingSession:(PLCameraStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSString *log = [NSString stringWithFormat:@"Stream State: Error. %@", error];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    // PLStreamStateError 都会回调在这个方法
    // 尝试重连，注意这里需要你自己来处理重连尝试的次数以及重连的时间间隔
    [self.actionButton setTitle:NSLocalizedString(@"Reconnecting", nil) forState:UIControlStateNormal];
    [self startSession];
}

/**
 *  当开始推流时，会每间隔 3s 调用该回调方法来反馈该 3s 内的流状态，包括视频帧率、音频帧率、音视频总码率
 *
 *  @param session <#session description#>
 *  @param status  <#status description#>
 */
- (void)cameraStreamingSession:(PLCameraStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status {
    NSString *log = [NSString stringWithFormat:@"%@", status];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@\%@", self.textView.text, log];
    
#if kReloadConfigurationEnable
    NSDate *now = [NSDate date];
    if (!self.keyTime) {
        self.keyTime = now;
    }
    
    double expectedVideoFPS = (double)self.session.videoConfiguration.videoFrameRate;
    double realtimeVideoFPS = status.videoFPS;
    if (realtimeVideoFPS < expectedVideoFPS * (1 - kMaxVideoFPSPercent)) {
        // 当得到的 status 中 video fps 比设定的 fps 的 50% 还小时，触发降低推流质量的操作
        self.keyTime = now;
        
        [self lowerQuality];
    } else if (realtimeVideoFPS >= expectedVideoFPS * (1 - kMinVideoFPSPercent)) {
        if (-[self.keyTime timeIntervalSinceNow] > kHigherQualityTimeInterval) {
            self.keyTime = now;
            
            [self higherQuality];
        }
    }
#endif  // #if kReloadConfigurationEnable
}


@end
