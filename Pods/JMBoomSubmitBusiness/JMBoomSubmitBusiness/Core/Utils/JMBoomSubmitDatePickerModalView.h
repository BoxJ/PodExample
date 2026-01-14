//
//  JMSubmitDatePickerModalView.h
//  JMRktDialog
//
//  Created by Thief Toki on 2021/3/15.
//

#import <JMUIKit/JMUIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JMSubmitDatePickerModalView : JMModalView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *confirmTitle;
@property (nonatomic, strong) NSString *cancelTitle;

- (instancetype)initWithTitle:(NSString *)title
                 confirmTitle:(NSString *)confirmTitle
                  cancelTitle:(NSString *)cancelTitle;

@end

NS_ASSUME_NONNULL_END
