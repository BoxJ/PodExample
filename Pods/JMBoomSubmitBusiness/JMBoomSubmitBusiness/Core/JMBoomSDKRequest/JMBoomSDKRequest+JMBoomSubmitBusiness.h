//
//  JMBoomSDKRequest+JMBoomSubmitBusiness.h
//  JMBoomSubmitBusiness
//
//  Created by ZhengXianda on 11/02/2022.
//  Copyright (c) 2022 ZhengXianda. All rights reserved.
//

#import <JMBoomSDKBase/JMBoomSDKBase.h>

#import <JMBoomSubmitBusiness/JMBoomSubmitType.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKRequest (JMBoomSubmitBusiness)

- (void)uploadSubmitWithContact:(NSString *)contact
                          issue:(NSString *)issue
                      issueTime:(NSDate *)issueTime
                      issueType:(JMBoomSubmitType)issueType
                        logFile:(NSString *)logFile
                    screenshots:(NSArray <NSString *>*)screenshots
                       callback:(JMBusinessCallback)callback;

- (void)querySubmitHistoryListWithId:(NSInteger)submitId
                            callback:(JMBusinessCallback)callback;

- (void)querySubmitHistoryDeiatlWithId:(NSInteger)submitId
                              callback:(JMBusinessCallback)callback;

@end

NS_ASSUME_NONNULL_END
