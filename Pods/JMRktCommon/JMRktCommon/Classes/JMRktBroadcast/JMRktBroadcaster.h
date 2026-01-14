//
//  JMRktBroadcaster.h
//  JMRktCommon
//
//  Created by Thief Toki on 2020/9/11.
//

#import <JMUtils/JMBroadcaster.h>

NS_ASSUME_NONNULL_BEGIN

/// 回调
/// @param responseObject 接口成功的回调数据
/// @param error 接口失败的报错
typedef void(^JMRktBroadcasterCallback)(NSDictionary * _Nullable responseObject, NSError * _Nullable error);

@interface JMRktBroadcaster : JMBroadcaster

- (void)subscribeWithCallback:(JMRktBroadcasterCallback)callback;

@end

NS_ASSUME_NONNULL_END
