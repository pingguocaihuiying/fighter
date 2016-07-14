//
//  FTSetTicketPriceViewTableViewCell.h
//  fighter
//
//  Created by Liyz on 7/5/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setTicketViewDelegate <NSObject>

- (void)confirtButtonClickedWithBasicPrice:(NSString *)basicPriceString andExtraPrice:(NSString *)expraPriceString andTotalPrice:(NSString *)totalPrice;
- (void)cancelButtonClicked;

@end
@interface FTSetTicketPriceViewTableViewCell : UITableViewCell
@property (nonatomic, weak)id<setTicketViewDelegate> delegate;

@property (nonatomic, copy) NSString *basicPrice;
@property (nonatomic, copy) NSString *extraPrice;
@property (nonatomic, copy) NSString *extraPriceNew;
@property (nonatomic, copy) NSString *totalPrice;
@property (nonatomic, copy) NSString *theNewExtraPrice;

@property (weak, nonatomic) IBOutlet UIView *extraPriceView;
@property (weak, nonatomic) IBOutlet UILabel *basicPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UITextField *extraPriceTextField;

//设置基础价、额外价
- (void)setPirceLabelWithBasicPrice:(NSString *)basicPriceString andExtraPrice:(NSString *)extraPriceString;
@end
