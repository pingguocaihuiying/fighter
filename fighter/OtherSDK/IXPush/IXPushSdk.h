//
//  sdk.h
//  sdk
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol IXTagOpDelegate<NSObject>
-(void)onResult:(BOOL)result tags:(NSArray *)tags;
@end

@protocol IXAliasOpDelegate<NSObject>
-(void)onResult:(BOOL)result alias:(NSString *)alias;
@end

@interface IXPushSdkApi : NSObject

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
+(void)register: (NSDictionary *)launchOptions settings:(UIUserNotificationSettings *) settings NS_AVAILABLE_IOS(8_0);

+(void)registerNotificationSettings:(UIUserNotificationSettings *) settings NS_AVAILABLE_IOS(8_0);
#endif

+(void)register:(NSDictionary *)launchOptions types:(UIRemoteNotificationType) types NS_DEPRECATED_IOS(3_0, 8_0, "Please use registerNotificationSettings: instead");

+(void)registerNotificationTypes:(UIRemoteNotificationType) types NS_DEPRECATED_IOS(3_0, 8_0, "Please use registerNotificationSettings: instead");

+(void)unregisterPush;

+(BOOL)isRegistered;

+(void)registerDeviceToken:(NSData *)token channel:(NSString *)channel version:(NSString *)version
                     appId:(uint32_t)appId;

+(void)handleNotification:(NSDictionary *)userInfo;

+(void)addTags:(NSArray *)tags delegate:(id)tagOpDelegate;

+(void)deleteTags:(NSArray *)tags delegate:(id)tagOpDelegate;

+(NSArray *)listTags;

+(BOOL)bindAlias:(NSString *)alias delegate:(id)aliasOpDelegate;

+(BOOL)unbindAlias:(NSString *)alias delegate:(id)aliasOpDelegate;

+ (BOOL)setBadge:(int)value;
@end
