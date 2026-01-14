//
//  JMModalStack.h
//  JMUIKit
//
//  Created by Thief Toki on 2020/8/18.
//

#import <UIKit/UIKit.h>

#import <JMUtils/JMUtils.h>

NS_ASSUME_NONNULL_BEGIN

@class JMModalView;
@interface JMModalStack : NSObject

@property (nonatomic, weak) JMModalView *rootModaView;
@property (nonatomic, strong) NSMutableArray<JMModalView *> *modaList;

+ (instancetype)stackWithRootModaView:(JMModalView *)rootModaView;

- (void)push:(JMModalView *)modaView;
- (void)push:(JMModalView *)modaView responder:(JMResponder *)responder;
- (nullable JMModalView *)pop;
- (void)dismiss:(void(^)(void))completion;
- (void)dismiss;
- (void)dismissSuccess:(NSDictionary *)info;
- (void)dismissFailed:(NSError *)error;
- (void)dismissCancel;

@end

NS_ASSUME_NONNULL_END
