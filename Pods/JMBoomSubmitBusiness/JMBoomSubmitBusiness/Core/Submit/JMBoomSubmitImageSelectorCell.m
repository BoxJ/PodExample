//
//  JMBoomSubmitImageSelectorCell.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/12.
//

#import "JMBoomSubmitImageSelectorCell.h"

#import <JMPhotos/JMPhotos.h>
#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitImageSelectorCellModel

- (instancetype)initWithTitle:(NSString *)title
                     subtitle:(NSString *)subtitle
                  imagesLimit:(NSInteger)imagesLimit
                         tips:(NSString *)tips
                      hasMark:(BOOL)hasMark {
    self = [super init];
    if (self) {
        self.cls = [JMBoomSubmitImageSelectorCell class];
        
        self.title = title;
        self.subtitle = subtitle;
        self.imagesLimit = imagesLimit;
        self.tips = tips;
        self.hasMark = hasMark;
    }
    return self;
}

- (JMAssetPickerCore *)apcore {
    if (!_apcore) {
        _apcore = [[JMAssetPickerCore alloc] init];
        
        _apcore.allowDownloadFromICloud = YES;
        _apcore.allowPickingImage = YES;
        
        _apcore.navigatorBackgroundColor = [UIColor colorWithHexString:@"#B0000000"];
        _apcore.navigatorBackgroundColorTranslucent = [UIColor colorWithHexString:@"#B0000000"];
        _apcore.navigatorBackImage = [JMBoomSDKResource imageNamed:@"navi_back"];
        _apcore.navigatorTitleFont = [UIFont systemFontOfSize:20 weight:UIFontWeightBold];
        _apcore.navigatorTitleColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
        _apcore.navigatorSelectedCountActiveImage = [JMBoomSDKResource imageNamed:@"photo_number_icon"];
        
        _apcore.toolBackgroundColor = [UIColor colorWithHexString:@"#B0000000"];
        _apcore.toolBackgroundColorTranslucent = [UIColor colorWithHexString:@"#B0000000"];
        _apcore.toolPreviewContentColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
        _apcore.toolOriginalContentColor = [UIColor colorWithHexString:@"#FFFFFFFF"];
        _apcore.toolOriginalSelectedImage = [JMBoomSDKResource imageNamed:@"photo_original_sel"];
        _apcore.toolOriginalUnselectedImage = [JMBoomSDKResource imageNamed:@"photo_original_def"];
        _apcore.toolFinishContentColor = [UIColor colorWithHexString:@"#FF6074FF"];
        _apcore.toolSelectedCountActiveImage = [JMBoomSDKResource imageNamed:@"photo_number_icon"];
        
        _apcore.cameraImage = [JMBoomSDKResource imageNamed:@"takePicture80"];
        _apcore.pickerSelectedImage = [JMBoomSDKResource imageNamed:@"photo_number_icon"];
        _apcore.pickerUnselectedImage = [JMBoomSDKResource imageNamed:@"photo_original_def"];
        _apcore.pickerVideoImage = [JMBoomSDKResource imageNamed:@"VideoSendIcon"];
        
        _apcore.videoPlayImage = [JMBoomSDKResource imageNamed:@"MMVideoPreviewPlay"];
    }
    return _apcore;
}

- (JMAssetPickerModel *)apmodel {
    if (!_apmodel) {
        _apmodel = [[JMAssetPickerModel alloc] initWithImagePickerCore:self.apcore];
    }
    return _apmodel;
}

- (JMAssetCollectorCore *)accore {
    if (!_accore) {
        _accore = [[JMAssetCollectorCore alloc] init];
        _accore.addImage = [JMBoomSDKResource imageNamed:@"sug_ic_picture"];
        _accore.deleteImage = [JMBoomSDKResource imageNamed:@"sug_ic_delete"];
        _accore.videoPlayImage = [JMBoomSDKResource imageNamed:@"MMVideoPreviewPlay"];
        
        _accore.displayInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _accore.displayWidth = kScreenWidth;
        _accore.selectedCountLimit = 6;
        _accore.assetInsets = UIEdgeInsetsMake(9, 0, 0, 9);
    }
    return _accore;
}

- (JMAssetCollectorModel *)acmodel {
    if (!_acmodel) {
        _acmodel = [[JMAssetCollectorModel alloc] initWithImageSelectorCore:self.accore];
    }
    return _acmodel;
}

@end

@interface JMBoomSubmitImageSelectorCell () <JMAssetPickerModelDelegate, JMAssetCollectorModelDelegate>

@property (nonatomic, strong) JMBoomSubmitImageSelectorCellModel *model;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) JMAssetCollector *assetCollector;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation JMBoomSubmitImageSelectorCell

- (void)showImagePicker {
    self.model.apcore.selectedCountLimit = self.model.accore.selectedCountLimit - self.model.acmodel.selectingAssetList.count;
    [JMPhotos requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            [JMPhotos showImagePickerModel:self.model.apmodel on:kMainWindow.rootViewController.currentViewController];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                           message:@"请前往本应用设置页面，允许访问相册"
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认"
                                                      style:UIAlertActionStyleCancel
                                                    handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            }]];
            [kMainWindow.rootViewController.currentViewController presentViewController:alert animated:YES completion:nil];
        }
    }];
}

#pragma mark - setup UI

- (void)setupUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.subtitleLabel];
    [self.contentView addSubview:self.assetCollector];
    [self.contentView addSubview:self.tipsLabel];
    
    self.sizeJM = CGSizeMake(kScreenWidth, self.model.acmodel.selectingHeight + 70);
    self.contentView.frame = CGRectMake(0, 0,
                                        self.widthJM - ((kIsSpecialScreen && kIsLandscape) ? 44*2 : 0),
                                        self.heightJM);
    
    [self.titleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 16;
        make.topJM = 16;
    }];
    [self.markLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.titleLabel.rightJM + 8;
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.subtitleLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = self.model.hasMark ?
        (self.markLabel.rightJM  + 10) :
        (self.titleLabel.rightJM  + 10);
        make.centerYJM = self.titleLabel.centerYJM;
    }];
    [self.assetCollector jm_layout:^(UIView * _Nonnull make) {
        make.widthJM = self.model.accore.displayWidth;
        make.heightJM = self.model.acmodel.selectingHeight;
        make.leftJM = 0;
        make.topJM = self.titleLabel.bottomJM + 9;
    }];
    [self.tipsLabel jm_layout:^(UIView * _Nonnull make) {
        [make sizeToFit];
        make.leftJM = 16;
        make.topJM = self.assetCollector.bottomJM + 12;
    }];
}

#pragma mark - setup UI response

- (void)setupUIResponse {
    
}

#pragma mark - bind model

- (void)bindModel {
    self.titleLabel.text = self.model.title;
    self.markLabel.text = self.model.hasMark ? @"*" : @"";
    self.subtitleLabel.text = self.model.subtitle;
    self.tipsLabel.text = self.model.tips;
    
    self.model.apmodel.delegate = self;
    self.model.acmodel.delegate = self;
    [self.assetCollector configModel:self.model.acmodel];
    
    [self setupUI];
}

#pragma mark - protocol

- (void)assetPickerSelectingDidFinish:(JMAssetPickerModel *)model {
    NSArray *assetList = [self.model.acmodel.selectingAssetList arrayByAddingObjectsFromArray:self.model.apmodel.selectingAssetList];
    [self.model.acmodel update:assetList];
    [self.assetCollector reload];
    
    [self setupUI];
    [self update];
    
    [self.model.apmodel removeAllSelectedAsset];
}

- (void)assetCollectorExecute:(JMAssetCollectorModel *)model {
    [self showImagePicker];
//    UIAlertController *sheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//    __weak typeof(self) weakSelf = self;
//    [sheet addAction:[UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [JMAssetTaker showAssetTakerOn:kMainWindow.rootViewController.currentViewController mediaTypes:@[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie] saveCompletion:^(PHAsset * _Nonnull asset, NSError * _Nonnull error) {
//            [weakSelf.model.apmodel fetchAlbums];
//
//            [weakSelf.model.acmodel select:asset];
//            [weakSelf.assetCollector reload];
//
//            [self setupUI];
//            [self update];
//        }];
//    }]];
//    [sheet addAction:[UIAlertAction actionWithTitle:@"打开相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
//        [weakSelf showImagePicker];
//    }]];
//    [sheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [sheet dismissViewControllerAnimated:YES completion:^{
//
//        }];
//    }]];
//    [kMainWindow.rootViewController.currentViewController presentViewController:sheet animated:YES completion:^{
//
//    }];
}

- (void)assetCollectorDidChange:(JMAssetCollectorModel *)model {
    [self setupUI];
    [self update];
}

#pragma mark - setter

#pragma mark - getter

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:51/255.0
                                                green:51/255.0
                                                 blue:51/255.0
                                                alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    }
    return _titleLabel;
}

- (UILabel *)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.textColor = [UIColor colorWithRed:255/255.0
                                               green:124/255.0
                                                blue:101/255.0
                                                alpha:1.0];
        _markLabel.font = [UIFont systemFontOfSize:16];
    }
    return _markLabel;
}

- (UILabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.textColor = [UIColor colorWithRed:102/255.0
                                                   green:102/255.0
                                                    blue:102/255.0
                                                   alpha:1.0];
        _subtitleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _subtitleLabel;
}

- (JMAssetCollector *)assetCollector {
    if (!_assetCollector) {
        _assetCollector = [[JMAssetCollector alloc] init];
    }
    return _assetCollector;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.userInteractionEnabled = NO;
        _tipsLabel.numberOfLines = 0;
        _tipsLabel.textColor = [UIColor colorWithRed:187/255.0
                                                      green:187/255.0
                                                       blue:187/255.0
                                                      alpha:1.0];
        _tipsLabel.font = [UIFont systemFontOfSize:12];
    }
    return _tipsLabel;
}

@end
