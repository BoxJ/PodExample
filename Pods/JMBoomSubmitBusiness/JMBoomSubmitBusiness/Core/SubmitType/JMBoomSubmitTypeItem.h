//
//  JMBoomSubmitTypeItem.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/16.
//

#import <Foundation/Foundation.h>

#import "JMBoomSubmitType.h"

NS_ASSUME_NONNULL_BEGIN

@interface JMBoomSubmitTypeItem : NSObject

@property (nonatomic, assign) JMBoomSubmitType type;

@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, strong) UIColor *backgroundColor;

- (instancetype)initWithType:(JMBoomSubmitType)type;

@end

NS_ASSUME_NONNULL_END
