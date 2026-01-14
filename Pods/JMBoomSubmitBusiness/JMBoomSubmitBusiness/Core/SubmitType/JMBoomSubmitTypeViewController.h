//
//  JMBoomSubmitTypeViewController.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/15.
//

#import <UIKit/UIKit.h>

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitTypeViewController : UIViewController

- (instancetype)initWithSelectedCallback:(void(^)(JMBoomSubmitTypeItem *item))selectedCallback;

@end

NS_ASSUME_NONNULL_END
