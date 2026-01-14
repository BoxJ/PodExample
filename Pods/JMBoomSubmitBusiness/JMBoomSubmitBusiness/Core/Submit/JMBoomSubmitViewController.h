//
//  JMBoomSubmitViewController.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import <UIKit/UIKit.h>

#import <JMRktCommon/JMRktCommon.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitViewController : UIViewController

- (instancetype)initWithHistoryStatus:(BOOL)hasHistory callback:(JMRktCommonCallback)callback;

@end

NS_ASSUME_NONNULL_END
