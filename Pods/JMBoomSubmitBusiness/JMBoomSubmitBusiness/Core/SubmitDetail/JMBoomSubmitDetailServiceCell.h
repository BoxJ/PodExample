//
//  JMBoomSubmitDetailServiceCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitDetailServiceCellModel : JMTableViewCellModel

@property (nonatomic, strong) NSString *describe;///<客服描述
@property (nonatomic, strong) NSString *name;///<客服名
@property (nonatomic, strong) NSString *reply;///<回复内容
@property (nonatomic, assign) NSInteger replyTime;///<回复时间

- (instancetype)initWithDescribe:(NSString *)describe
                            name:(NSString *)name
                           reply:(NSString *)reply
                       replyTime:(NSInteger)replyTime;

@end

@interface JMBoomSubmitDetailServiceCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
