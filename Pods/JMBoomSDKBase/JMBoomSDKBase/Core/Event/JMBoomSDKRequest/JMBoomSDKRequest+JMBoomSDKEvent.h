//
//  JMBoomSDKRequest+JMBoomSDKEvent.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/20.
//

#import <JMBoomSDKBase/JMBoomSDKRequest.h>

NS_ASSUME_NONNULL_BEGIN

@class JMBoomSDKEventItem;
@interface JMBoomSDKRequest (JMBoomSDKEvent)

- (void)uploadEvents:(NSArray <JMBoomSDKEventItem *>*)events
            callback:(JMRequestCallback)callback;

@end

NS_ASSUME_NONNULL_END
