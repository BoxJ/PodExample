//
//  JMBoomSDKInfo+Agreement.h
//  JMBoomSDK
//
//  Created by ZhengXianda on 11/2/22.
//

#import <JMBoomSDKBase/JMBoomSDKInfo.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSDKInfo (Agreement)

- (void)localAgreementContent:(NSString *)content;
- (NSString *)localAgreementContent;

- (void)localAgreementVersion:(NSString *)version;
- (NSString *)localAgreementVersion;

- (NSArray *)localAgreementLinks;

- (void)updateLocalAgreement:(NSString *)version content:(NSString *)content;

- (void)localAgreementUnFinished;
- (void)localAgreementFinished;
- (BOOL)isLocalAgreementFinished;

- (BOOL)localAgreementThrough:(BOOL)isThrough;
- (BOOL)isLocalAgreementThrough;

@end

NS_ASSUME_NONNULL_END
