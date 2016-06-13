//
//  FTNewPostViewController.h
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"

@interface FTNewPostViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIView *contentTextViewContainer;
@property (weak, nonatomic) IBOutlet UIButton *addLabelButton;
@property (weak, nonatomic) IBOutlet UIView *mediaPickerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *meidiaPickerViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *syncView;
@property (weak, nonatomic) IBOutlet UIButton *syncButton;
@property (nonatomic, assign) BOOL isShowSyncView;//默认不显示是否同步选项，从个人主页跳转过来时才显示
@end
