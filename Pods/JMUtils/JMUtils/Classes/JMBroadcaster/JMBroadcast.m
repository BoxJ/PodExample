//
//  JMBroadcast.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2021/1/21.
//

#import "JMBroadcast.h"

@implementation JMBroadcast

+ (instancetype)broadcastWithChannel:(NSInteger)channel content:(NSDictionary *)content {
    JMBroadcast *broadcaster = [[JMBroadcast alloc] init];
    broadcaster.channel = channel;
    broadcaster.content = content;
    return broadcaster;
}

@end
