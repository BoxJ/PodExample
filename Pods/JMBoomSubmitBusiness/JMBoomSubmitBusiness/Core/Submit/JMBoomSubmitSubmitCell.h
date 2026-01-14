//
//  JMBoomSubmitSubmitCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitSubmitCellModel : JMTableViewCellModel

@property (nonatomic, assign) BOOL hasLog;
@property (nonatomic, strong) void(^submit)(void);

- (instancetype)initWithHasLog:(BOOL)hasLog
                            submit:(void(^)(void))submit;

@end

@interface JMBoomSubmitSubmitCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
