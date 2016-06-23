//
//  FTPracticeViewController.m
//  fighter
//
//  Created by kang on 16/6/22.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTPracticeViewController.h"
#import "FTSegmentedControl.h"

@interface FTPracticeViewController ()

@property (weak, nonatomic) IBOutlet UIView *contentView;


@end

@implementation FTPracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSubviews];
}


- (void) initSubviews {

//    _pageControl.layer.borderWidth = 0.0;
    
    
    
    
//    NSArray *items = @[[[FTSegmentItem alloc] initWithTitle:@"教学" selectImg:@"三标签-左-选中" normalImg:@"三标签-左-空"],
//                        [[FTSegmentItem alloc] initWithTitle:@"教练" selectImg:@"三标签-中-选中"  normalImg:@"三标签-中-空"],
//                        [[FTSegmentItem alloc] initWithTitle:@"拳馆" selectImg:@"三标签-中-选中" normalImg:@"三标签-右-空"]];
//    FTSegmentedControl *segmented=[[FTSegmentedControl alloc] initWithFrame:CGRectMake(6, 64, SCREEN_WIDTH-12, 35)
//                                                                                 items:items
//                                                                          iconPosition:IconPositionRight
//                                                                     andSelectionBlock:^(NSUInteger segmentIndex) { }
//                                                                        iconSeparation:5];
//    segmented.color=[UIColor clearColor];
//    segmented.borderWidth=0.0;
////    segmented.selectedColor=[UIColor colorWithRed:244.0f/255.0 green:67.0f/255.0 blue:60.0f/255.0 alpha:1];
//    segmented.textAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                NSForegroundColorAttributeName:[UIColor whiteColor]};
//    segmented.selectedTextAttributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],
//                                        NSForegroundColorAttributeName:[UIColor redColor]};
//    [self.view addSubview:segmented];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
