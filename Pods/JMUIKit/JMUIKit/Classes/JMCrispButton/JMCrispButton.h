//
//  JMCrispButton.h
//  JMUIKit
//
//  Created by Thief Toki on 2021/2/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMCrispButton : UIButton

/// 相邻有效点击间隔，默认为 0.5s
@property (nonatomic, assign) NSTimeInterval repairTimeInterval;

@end

NS_ASSUME_NONNULL_END
