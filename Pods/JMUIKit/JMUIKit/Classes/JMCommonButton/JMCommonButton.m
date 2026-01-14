//
//  JMCommonButton.m
//  JMBoomSDK
//
//  Created by Thief Toki on 2020/8/5.
//

#import "JMCommonButton.h"

#import "UIView+JMLayout.h"

@implementation JMCommonButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = JMThemeFetchT(JMCommonButton, backgroundColor);
        self.titleLabel.font = JMThemeFetchT(JMCommonButton, titleFont);
        [self setTitleColor:JMThemeFetchT(JMCommonButton, titleColor)
                   forState:UIControlStateNormal];
        self.layer.masksToBounds = YES;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - setup UI

- (void)setupUI {
    self.layer.cornerRadius = MIN(MIN(self.widthJM, self.heightJM)/2, [JMThemeFetchT(JMCommonButton, corner) floatValue]);
}

#pragma mark - setup UI response

#pragma mark - protocol

#pragma mark - setter

#pragma mark - getter

@end
