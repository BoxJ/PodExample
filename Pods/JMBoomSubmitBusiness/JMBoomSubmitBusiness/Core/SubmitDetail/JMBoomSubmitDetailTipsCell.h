//
//  JMBoomSubmitDetailTipsCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitDetailTipsCellModel : JMTableViewCellModel

@property (nonatomic, strong) NSString *title;

- (instancetype)initWithTitle:(NSString *)title;

@end

@interface JMBoomSubmitDetailTipsCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
