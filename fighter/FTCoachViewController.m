//
//  FTCoachViewController.m
//  fighter
//
//  Created by Liyz on 4/8/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTCoachViewController.h"
#import "UIButton+WebCache.h"

@interface FTCoachViewController ()

@end

@implementation FTCoachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void) initSubviews {
    //设置左上角按钮
    NSData *localUserData = [[NSUserDefaults standardUserDefaults]objectForKey:LoginUser];
    FTUserBean *localUser = [NSKeyedUnarchiver unarchiveObjectWithData:localUserData];
    [self.leftNavButton.layer setMasksToBounds:YES];
    self.leftNavButton.layer.cornerRadius = 17.0;
    [self.leftNavButton sd_setImageWithURL:[NSURL URLWithString:localUser.headpic]
                                  forState:UIControlStateNormal
                          placeholderImage:[UIImage imageNamed:@"头像-空"]];
    
    if ([self.drawerDelegate respondsToSelector:@selector(addButtonToArray:)]) {
        
        [self.drawerDelegate addButtonToArray:self.leftNavButton];
    }


}


#pragma mark 按钮事件
- (IBAction)leftButtonItemClick:(id)sender {
    
    
    
    NSLog(@"information left click did");
    if ([self.drawerDelegate respondsToSelector:@selector(leftButtonClicked:)]) {
        
        [self.drawerDelegate leftButtonClicked:sender];
    }
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
