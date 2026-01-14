//
//  JMBoomSubmitImageSelectorCell.h
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/12.
//

#import "JMTableViewCell.h"

#import <JMPhotos/JMPhotos.h>

NS_ASSUME_NONNULL_BEGIN

@class JMBoomSubmitImageSelectorCellModel;

@interface JMBoomSubmitImageSelectorCellModel : JMTableViewCellModel

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, assign) NSInteger imagesLimit;
@property (nonatomic, strong) NSString *tips;
@property (nonatomic, assign) BOOL hasMark;

@property (nonatomic, strong) JMAssetPickerCore *apcore;
@property (nonatomic, strong) JMAssetPickerModel *apmodel;
@property (nonatomic, strong) JMAssetCollectorCore *accore;
@property (nonatomic, strong) JMAssetCollectorModel *acmodel;

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  imagesLimit:(NSInteger)imagesLimit
                         tips:(NSString *)tips
                      hasMark:(BOOL)hasMark;

@end

@interface JMBoomSubmitImageSelectorCell : JMTableViewCell

@end

NS_ASSUME_NONNULL_END
