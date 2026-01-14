//
//  JMBoomSubmitHistoryOptionCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/11.
//

#import "JMTableViewCell.h"

#import "JMBoomSubmitTypeItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitHistoryOptionCellModel : JMTableViewCellModel

@property (nonatomic, assign) NSInteger submitId;
@property (nonatomic, assign) NSInteger createdOn;
@property (nonatomic, strong) NSString *issueTitle;
@property (nonatomic, strong) JMBoomSubmitTypeItem *item;
@property (nonatomic, assign) BOOL issueStatus;

- (instancetype)initWithId:(NSInteger)submitId
                 createdOn:(NSInteger)createdOn
                issueTitle:(NSString *)issueTitle
                      type:(JMBoomSubmitType)type
               issueStatus:(BOOL)issueStatus;

@end

@interface JMBoomSubmitHistoryOptionCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
