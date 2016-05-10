//
//  Regex.h
//  renzhenzhuan
//
//  Created by Liyz on 4/1/16.
//  Copyright © 2016 Mapbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Regex : NSObject
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
- (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)checkPassword:(NSString *) password;
@end
