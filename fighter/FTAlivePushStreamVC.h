//
//  FTAlivePushStreamVC.h
//  fighter
//
//  Created by kang on 16/6/7.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTAlivePushStreamVC : UIViewController


@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIButton *toggleCameraButton;
@property (weak, nonatomic) IBOutlet UIButton *torchButton;
@property (weak, nonatomic) IBOutlet UIButton *muteButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segementedControl;
@property (weak, nonatomic) IBOutlet UISlider *zoomSlider;

- (IBAction)segmentedControlValueDidChange:(id)sender;
- (IBAction)zoomSliderValueDidChange:(id)sender;

@end
