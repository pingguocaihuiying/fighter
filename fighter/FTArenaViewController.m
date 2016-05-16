//
//  FTArenaViewController.m
//  fighter
//
//  Created by Liyz on 5/16/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTArenaViewController.h"
#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface FTArenaViewController ()<NIDropDownDelegate>

{
    NIDropDown *_dropDown;
}

@property (nonatomic, copy)NSString *currentIndexString;

@end

@implementation FTArenaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseConfig];
    [self initSubviews];
}
/**
 *  初始化一些默认数据
 */
- (void)initBaseConfig{
    _currentIndexString = @"all";
}

- (void)initSubviews{
    
}
/**
 *  “全部视频”按钮被点击
 *
 *  @param sender “全部视频”按钮
 */
- (IBAction)allButtonClicked:(id)sender {
    if (![_currentIndexString isEqualToString:@"all"]) {
        [self changeCurrentIndex];//改变currentIndex的值
        [self refreshIndexView];//刷新红色下标的显示
    }
    //设置下拉框
    [self setDropDown:sender];
}
/**
 *  “本周最热”按钮被点击
 *
 *  @param sender “本周最热”按钮
 */
- (IBAction)hotThisWeekButtonClicked:(id)sender {
    if (![_currentIndexString isEqualToString:@"hot"]) {
        [self changeCurrentIndex];//改变currentIndex的值
        [self refreshIndexView];//刷新红色下标的显示
    }

}

- (void)setDropDown:(id)sender{
    NSArray * arr = [[NSArray alloc] init];
    arr = [NSArray arrayWithObjects:@"Hello 0", @"Hello 1", @"Hello 2", @"Hello 3", @"Hello 4", @"Hello 5", @"Hello 6", @"Hello 7", @"Hello 8", @"Hello 9",nil];
    NSArray * arrImage = [[NSArray alloc] init];
    arrImage = [NSArray arrayWithObjects:[UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], [UIImage imageNamed:@"apple.png"], [UIImage imageNamed:@"apple2.png"], nil];
    if(_dropDown == nil) {
        CGFloat f = 200;
        _dropDown = [[NIDropDown alloc]showDropDown:sender :&f :arr :arrImage :@"down"];
        _dropDown.delegate = self;
    }
    else {
        [_dropDown hideDropDown:sender];
        [self rel];
    }
}

- (void) niDropDownDelegateMethod: (NIDropDown *) sender {
    [self rel];
    NSLog(@"%@", _btnSelect.titleLabel.text);
}
- (void)rel{
    _dropDown = nil;
}
- (IBAction)newBlogButtonClicked:(id)sender {
    NSLog(@"发新帖");
}
 /**
  *  循环改变currentIndex的值
  */
- (void)changeCurrentIndex{
    if ([_currentIndexString isEqualToString:@"all"]) {
        _currentIndexString = @"hot";
    }else{
        _currentIndexString = @"all";
    }
}
- (void)refreshIndexView{
    if ([_currentIndexString isEqualToString:@"all"]) {
        _indexViewOfAllVideo.hidden = NO;
        _indexViewOfHot.hidden = YES;
    }else{
        _indexViewOfAllVideo.hidden = YES;
        _indexViewOfHot.hidden = NO;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
