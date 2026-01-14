//
//  JMBroadcaster.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/9/11.
//

#import <Foundation/Foundation.h>

#import <JMUtils/JMBroadcast.h>

typedef void(^JMBroadcasterCallback)(JMBroadcast * _Nullable broadcast,
                                     NSError * _Nullable error);

NS_ASSUME_NONNULL_BEGIN

@interface JMBroadcaster : NSObject

@property (nonatomic, strong) JMBroadcasterCallback callback;

#pragma mark - shared

+ (instancetype)shared;

#pragma mark -

- (void)subscribeWithCallback:(JMBroadcasterCallback)callback;

- (void)sendbroadcast:(JMBroadcast *)broadcast;
- (void)sendError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
