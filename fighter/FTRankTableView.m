//
//  FTRankTableView.m
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankTableView.h"
#import "FTTableViewCell6.h"
#import "FTButton.h"

@interface FTRankTableView () <UIGestureRecognizerDelegate>

@property (nonatomic ,weak) FTButton *button;
@property (nonatomic ,strong) UIImageView *imageView;

@end


@implementation FTRankTableView

- (instancetype)initWithButton:(FTButton*)button
                          style:(FTRankTableViewStyle) style
                        option:(void(^)(FTRankTableView* searchTableView))option{
    
    self = [super init];
    if (self) {
        
        if (option) {
            __weak __typeof(&*self)weakSelf = self;
            option(weakSelf);
        }
        [self setFrame:[UIScreen mainScreen].bounds];
        [self setStyle:style];
        self.button = button;
        
        [self setDirection:FTAnimationDirectionToToBottom];
        [self initSubviews];
        [self setTouchEvent];
        
    }
    
    return self;

}



- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
}

- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    NSLog(@"tap");
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:self.imageView.frame toView:self];
   
    
    if (!CGRectContainsPoint(frame, point)) {

         CGRect tableFram = self.tableView.frame;
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
            self.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
//    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}


- (void) setAnimation {

//    NSLog(@"animation");
    
    CGRect frame = self.imageView.frame;
    CGRect tableFram = self.tableView.frame;
    
    __weak typeof (&*self) sself = self;
    switch (self.direction) {
        case FTAnimationDirectionToTop:
        {
            
            [UIView animateWithDuration:0.4 animations:^{
                sself.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
//                sself.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 0);
            } completion:^(BOOL finished) {
                if (sself.direction == FTAnimationDirectionToTop) {
                    [sself removeFromSuperview];
                }
            }];
        }
            break;
        case FTAnimationDirectionToLeft:
        {
            
        }
            break;
        case FTAnimationDirectionToToBottom:
        {

            [UIView animateWithDuration:0.2 animations:^{
                sself.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, sself.tableH);
                sself.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, sself.tableH);

            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case FTAnimationDirectionToRight:
        {
            
        }
            break;
        default:
            break;
    }
    
}


- (void) initSubviews {

    CGFloat tableWidth = [self caculateTableWidth];
    
    //由于ios上面button左边转换不正常原因，现在用frame直接传值
    CGRect frame = self.Btnframe;
//    NSLog(@"frame(%f,%f,%f,%f)",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);

    switch (_style) {
        case FTRankTableViewStyleLeft:
        {
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];
            [_imageView setFrame:CGRectMake(frame.origin.x+_offsetX, frame.origin.y+ _offsetY, tableWidth, 0)];

            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];
                [self.tableView setFrame:CGRectMake(0, 0, tableWidth, 0)];
            }

        }
            break;
        case FTRankTableViewStyleCenter:
        {
        
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];

           [_imageView setFrame:CGRectMake(frame.origin.x+_offsetX-(tableWidth-_tableW)/2, frame.origin.y+ _offsetY, tableWidth, 0)];
            
            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = YES;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];
                
                [self.tableView setFrame:CGRectMake(0, 0, tableWidth, 0)];
            }

        }
            break;
            
        case FTRankTableViewStyleRight:
        {
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];
           [_imageView setFrame:CGRectMake(SCREEN_WIDTH - tableWidth+_offsetX, frame.origin.y+ _offsetY, tableWidth, 0)];
            
            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];
                
                [self.tableView setFrame:CGRectMake(0, 0, tableWidth, 0)];
                
                
            }

        }
            break;
        case FTRankTableViewStyleNone:
        {
        
        }
            break;
        default:
            break;
    }
    
    [self addSubview:_imageView];
    
    [_imageView addSubview:self.tableView];
}

#pragma mark - tableView datasouce and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (self.dataArray == nil || self.dataArray.count <1) {
        return 1;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_cellH > 0) {
        return _cellH;
    }
    return 40 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FTTableViewCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.contentLabel.text = [self cellTextAtIndex:[indexPath row]];
    
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    switch (_dataType) {
        case FTDataTypeDicArray:
        {
            [self.button setTitle:[_dataArray objectAtIndex:[indexPath row]][@"itemValue"] forState:UIControlStateNormal];
            
            if ([self.selectDelegate respondsToSelector:@selector(selectedValue:)]) {
                
                [self.selectDelegate selectedValue:[self.dataArray objectAtIndex:indexPath.row]];
            }

            
        }
            break;
        case FTDataTypeStringArray:
        {
            if (self.dataArray.count >0) {
                NSString *text = [[_dataArray objectAtIndex:[indexPath row]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [self.button setTitle:text forState:UIControlStateNormal];
                
                if ([self.selectDelegate respondsToSelector:@selector(selectedValue:style:)]) {
                    
                    [self.selectDelegate selectedValue:[self.dataArray objectAtIndex:indexPath.row]
                                                 style:self.style];
                }
            }
           
        }
            
        default:
            break;
    }
    
    
    CGRect frame = [self convertRect:self.imageView.frame toView:self];
    
    CGRect tableFram = self.tableView.frame;
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
        self.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


#pragma mark - private method

- (NSString *) cellTextAtIndex:(NSInteger )index {
    
    NSString *cellText;
    switch (_dataType) {
        case FTDataTypeDicArray:
        {
            cellText = [_dataArray objectAtIndex:index][@"itemValue"];
        }
            break;
        case FTDataTypeStringArray:
        {
            if (self.dataArray == nil || self.dataArray.count <1) {
                cellText = @"全部";
            }else {
            
                cellText = [[_dataArray objectAtIndex:index] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            
        }
            
        default:
            break;
    }
    
    return cellText;
    
}


- (CGFloat) caculateTableWidth {
    
    
    CGFloat width = 0.0;
    //    NSLog(@"_dataArray.count:%lu",(unsigned long)self.dataArray.count);
    for (int i=0 ;i< _dataArray.count;i++)
    {
        
        NSString *str = [self cellTextAtIndex:i];
        //计算文本长度
        CGFloat tempW =  [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        if (tempW > width) {
            width = tempW;
        }
        //         NSLog(@"tempW width:%f",tempW);
    }
    
    if (width <= self.tableW -30) {
        width = self.tableW;
    }else {
        
        width = width + 30;
    }
    
    //    NSLog(@"table width:%f",width);
    return width;
}

- (void) caculateTableHeight {

    if (_cellH >0) {
        if (self.dataArray.count>0 && self.dataArray.count < 8) {
            _tableH = _cellH *self.dataArray.count;
        }else if (self.dataArray == nil || self.dataArray.count <=0){
            _tableH = _cellH;
        }
    }
    
}

@end
