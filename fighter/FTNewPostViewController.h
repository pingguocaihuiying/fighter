//
//  FTNewPostViewController.h
//  fighter
//
//  Created by Liyz on 5/17/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

//发帖成功后的回调（供刷新帖子列表界面等使用）
@protocol FTNewPostSuccessDelegate <NSObject>

- (void)postSuccess;

@end

#import "FTBaseViewController.h"
#import "FTModuleBean.h"

@interface FTNewPostViewController : FTBaseViewController

@property (nonatomic, weak) id<FTNewPostSuccessDelegate> delegate;

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
@property (nonatomic, strong) FTModuleBean *moduleBean;//如果存在，说明是从版块列表过来的，直接用版块名称作为类型，否则，出现弹出框让用户自己选
@end
