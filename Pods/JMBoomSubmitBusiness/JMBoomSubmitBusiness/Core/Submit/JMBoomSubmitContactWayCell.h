//
//  JMBoomSubmitContactWayCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitContactWayCellModel : JMTableViewCellModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL hasMark;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  placeholder:(NSString *)placeholder
                      content:(NSString *)content
                      hasMark:(BOOL)hasMark;

@end

@interface JMBoomSubmitContactWayCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
