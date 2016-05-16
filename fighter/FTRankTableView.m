//
//  FTRankTableView.m
//  fighter
//
//  Created by kang on 16/5/16.
//  Copyright © 2016年 Mapbar. All rights reserved.
//

#import "FTRankTableView.h"
#import "FTTableViewCell6.h"

@interface FTRankTableView ()

@property (nonatomic ,weak) UIButton *button;
@property (nonatomic ,strong) UIImageView *imageView;

@end


@implementation FTRankTableView

- (instancetype)initWithButton:(UIButton*)button
                          type:(FTRankTableViewType) type
                        option:(void(^)(FTRankTableView* searchTableView))option{
    
    self = [super init];
    if (self) {
        
        if (option) {
            __weak __typeof(&*self)weakSelf = self;
            option(self);
        }
        [self setFrame:[UIScreen mainScreen].bounds];
        [self setType:type];
        self.button = button;
        
        [self setDirection:FTAnimationDirectionToToBottom];
        [self initSubviews];
        [self setTouchEvent];
        
      
    }
    
    return self;

}



- (void) setTouchEvent {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    
    [self addGestureRecognizer:tap];
    
}

- (void) tapAction:(UITapGestureRecognizer *)gesture {
    
    CGPoint point = [gesture locationInView:self];
    CGRect frame = [self convertRect:self.imageView.frame toView:self];
   
    
    if (!CGRectContainsPoint(frame, point)) {

         CGRect tableFram = self.tableView.frame;
        [UIView animateWithDuration:0.4 animations:^{
            self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
            self.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 0);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
    
    
}


- (void) setAnimation {

    NSLog(@"animation");
    
    CGRect frame = self.imageView.frame;
    CGRect tableFram = self.tableView.frame;
    
    switch (self.direction) {
        case FTAnimationDirectionToTop:
        {
            
            [UIView animateWithDuration:0.4 animations:^{
                self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0);
                self.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 0);
            } completion:^(BOOL finished) {
                if (self.direction == FTAnimationDirectionToTop) {
                    [self removeFromSuperview];
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

            [UIView animateWithDuration:0.4 animations:^{
                self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 45*5);
                self.tableView.frame = CGRectMake(tableFram.origin.x, tableFram.origin.y, tableFram.size.width, 45*5);

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

- (CGFloat) caculateTableWidth {

  
    CGFloat width = 0.0;
    NSLog(@"_dataArray.count:%d",self.dataArray.count);
    for (int i=0 ;i< _dataArray.count;i++)
    {
        NSString *str = [_dataArray objectAtIndex:i];
        //计算文本长度
        CGFloat tempW =  [str sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}].width;
        if (tempW > width) {
            width = tempW;
        }
         NSLog(@"tempW width:%f",tempW);
    }
    
    CGRect frame = [self convertRect:self.button.frame fromView:self.button];
    if (width <= frame.size.width -40) {
        width = frame.size.width -40;
    }else {
    
        width = width + 40;
    }
    
    NSLog(@"table width:%f",width);
    return width;
    
}

- (void) initSubviews {

    CGFloat tableW = [self caculateTableWidth];
    
    CGRect frame = [self convertRect:self.button.frame fromView:self.button];
    
    switch (_type) {
        case FTRankTableViewTypeKind:
        {
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];
//                        [_imageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+40, frame.size.width, 0)];
            [_imageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+40, tableW, 0)];

            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = YES;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];

//                [self.tableView setFrame:CGRectMake(frame.origin.x+5, 0, frame.size.width-10, 0)];
                [self.tableView setFrame:CGRectMake(frame.origin.x+5, 0, tableW-10, 0)];
            }

        }
            break;
        case FTRankTableViewTypeMatch:
        {
        
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];
            [_imageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+40, frame.size.width, 0)];
            
            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = YES;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];
                
                [self.tableView setFrame:CGRectMake(frame.origin.x+5, 0, frame.size.width-10, 0)];
            }

        }
            break;
            
        case FTRankTableViewTypeLevel:
        {
            _imageView = [[UIImageView alloc]init];
            [_imageView setImage:[[UIImage imageNamed:@"下拉框bg新"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            [_imageView setUserInteractionEnabled:YES];
            [_imageView setFrame:CGRectMake(frame.origin.x, frame.origin.y+40, frame.size.width, 0)];
            
            if (!self.tableView) {
                self.tableView = [[UITableView alloc]init];
                self.tableView.dataSource = self;
                self.tableView.delegate = self;
                self.tableView.scrollEnabled = YES;
                [self.tableView setBackgroundColor:[UIColor clearColor]];
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                [self.tableView registerNib:[UINib nibWithNibName:@"FTTableViewCell6" bundle:nil] forCellReuseIdentifier:@"cellId"];
                
                [self.tableView setFrame:CGRectMake(frame.origin.x+5, 0, frame.size.width-10, 0)];
            }

        }
            break;
        case FTRankTableViewTypeNone:
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
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"cell for row");
    FTTableViewCell6 *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
    cell.backgroundColor = [UIColor clearColor];
//    cell.contentLabel.text = @"拳击";
    cell.contentLabel.text = [_dataArray objectAtIndex:[indexPath row]];
    return cell;
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}



@end
