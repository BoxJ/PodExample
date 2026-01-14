//
//  JMBroadcast.h
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBroadcast : NSObject

@property (nonatomic, assign) NSInteger channel;
@property (nonatomic, strong) NSDictionary *content;

+ (instancetype)broadcastWithChannel:(NSInteger)channel content:(NSDictionary *)content;

@end

NS_ASSUME_NONNULL_END
