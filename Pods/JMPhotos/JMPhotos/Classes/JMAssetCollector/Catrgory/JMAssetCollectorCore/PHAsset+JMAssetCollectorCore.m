//
//  PHAsset+JMAssetCollectorCore.m
//  JMImagePickerController
//
//  Created by ZhengXianda on 2022/6/13.
//

#import "PHAsset+JMAssetCollectorCore.h"

#import <objc/runtime.h>

#import "JMAssetCollectorCore.h"

#import "PHAsset+JMExtension.h"

@implementation PHAsset (JMAssetCollectorCore)

- (PHImageRequestID)jmis_posterCompletion:(void (^)(UIImage *image))completion {
    __weak typeof(self) weakSelf = self;
    
    if (self.jmisposter) {
        if (completion) completion(self.jmisposter);
        return 0;
    } else {
        return [self jm_imageDisplaySize:self.jmiscore.assetSize
                             allowICloud:NO
                         progressHandler:^(double progress, BOOL * _Nonnull stop, NSError * _Nonnull error, NSDictionary * _Nonnull info) {
            
        } completion:^(UIImage * _Nonnull poster, NSDictionary * _Nonnull info, BOOL isDegraded) {
            weakSelf.jmisposter = poster;
            if (completion) completion(poster);
        }];
    }
}

#pragma mark - setter

- (void)setJmiscore:(JMAssetCollectorCore *)jmiscore {
    objc_setAssociatedObject(self, @"jmiscore", jmiscore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setJmisposter:(UIImage *)jmisposter {
    objc_setAssociatedObject(self, @"jmisposter", jmisposter, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (JMAssetCollectorCore *)jmiscore {
    return objc_getAssociatedObject(self, @"jmiscore");
}

- (UIImage *)jmisposter {
    return objc_getAssociatedObject(self, @"jmisposter");
}

@end
