//
//  JMBoomSubmitDetailPlayerCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitDetailPlayerCellModel : JMTableViewCellModel

@property (nonatomic, strong) NSString *issue;
@property (nonatomic, assign) NSInteger issueTime;
@property (nonatomic, assign) NSInteger submitTime;
@property (nonatomic, strong) JMBoomSubmitTypeItem *item;
@property (nonatomic, strong) NSArray <NSString *>*screenshots;

- (instancetype)initWithIssue:(NSString *)issue
                    issueTime:(NSInteger)issueTime
                   submitTime:(NSInteger)submitTime
                    issueType:(JMBoomSubmitType)issueType
                  screenshots:(NSArray <NSString *>*)screenshots;

@end

@interface JMBoomSubmitDetailPlayerCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
