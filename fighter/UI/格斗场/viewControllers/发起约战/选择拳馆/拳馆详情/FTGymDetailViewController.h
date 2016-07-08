//
//  FTGymDetailViewController.h
//  fighter
//
//  Created by Liyz on 7/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import "FTBaseViewController.h"
#import "FTTimeSectionTableView.h"

@interface FTGymDetailViewController : FTBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *adjustTicketButton;
@property (nonatomic, copy) NSString *basicPrice;
@property (nonatomic, copy) NSString *extraPrice;

@property (weak, nonatomic) IBOutlet FTTimeSectionTableView *t0;


@end
