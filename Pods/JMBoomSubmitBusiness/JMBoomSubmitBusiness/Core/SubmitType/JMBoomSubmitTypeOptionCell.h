//
//  JMBoomSubmitTypeOptionCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitTypeOptionCellModel : JMTableViewCellModel

@property (nonatomic, strong) JMBoomSubmitTypeItem *item;

- (instancetype)initWithType:(JMBoomSubmitType)type;

@end

@interface JMBoomSubmitTypeOptionCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
