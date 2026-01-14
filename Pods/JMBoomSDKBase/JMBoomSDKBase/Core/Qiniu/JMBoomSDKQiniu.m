//
//  JMBoomSDKQiniu.m
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/2/22.
//

#import "JMBoomSDKQiniu.h"

#import "JMBoomSDKRequest.h"

@implementation JMBoomSDKQiniu

#pragma mark - shared

+ (JMBoomSDKQiniu *)shared {
    static JMBoomSDKQiniu * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self registerFilePath:@"boom"
                     tokenHook:^(JMRktQiniuItem * _Nonnull item, JMRktCommonCallback  _Nonnull callback) {
            NSString *path = @"/client/qiniu/token";
            NSDictionary *parameters = @{
                @"bucketType": @(item.bucketType),
                @"fileName": item.fileName?:@"",
                @"mimeType": item.mimeType?:@"",
                @"sceneType": @(item.sceneType)
            };
            
            [[JMBoomSDKRequest shared] requestDataWithMethod:JMRequestMethodType_POST
                                                        path:path
                                                  parameters:parameters
                                                    callback:callback];
        }];
    }
    return self;
}

@end
