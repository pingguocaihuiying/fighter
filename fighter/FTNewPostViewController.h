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

@end
