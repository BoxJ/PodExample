//
//  JMNetworkConsuming.m
//  JMNetworking
//
//  Created by ZhengXianda on 4/1/25.
//

#import "JMNetworkConsuming.h"

#import <sys/socket.h>
#import <arpa/inet.h>

@implementation JMNetworkConsuming

+ (NSTimeInterval)check4:(NSString *)ip {
    int sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_ICMP);
    if (sock < 0) {
        return 0;
    }
    
    struct sockaddr_in addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_port = htons(80);
    if (inet_pton(AF_INET, ip.UTF8String, &addr.sin_addr) != 1) {
        close(sock);
        return 0;
    }
    
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));
    
    NSDate *bgn = [NSDate date];
    if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) != 0) {
        close(sock);
        return 0;
    }
    NSDate *end = [NSDate date];

    close(sock);
    return [end timeIntervalSinceDate:bgn];
}

+ (NSTimeInterval)check6:(NSString *)ip {
    int sock = socket(AF_INET6, SOCK_DGRAM, IPPROTO_ICMPV6);
    if (sock < 0) {
        return 0;
    }
    
    struct sockaddr_in6 addr;
    memset(&addr, 0, sizeof(addr));
    addr.sin6_family = AF_INET6;
    addr.sin6_port = htons(80);
    if (inet_pton(AF_INET6, ip.UTF8String, &addr.sin6_addr) != 1) {
        close(sock);
        return 0;
    }
    
    struct timeval tv;
    tv.tv_sec = 1;
    tv.tv_usec = 0;
    setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof(tv));
    setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &tv, sizeof(tv));
    
    
    NSDate *bgn = [NSDate date];
    if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) != 0) {
        close(sock);
        return 0;
    }
    NSDate *end = [NSDate date];

    close(sock);
    return [end timeIntervalSinceDate:bgn];
}

@end
