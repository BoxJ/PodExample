//
//  JMBoomSubmitTypeItem.m
//  JMBoomSubmitBusiness
//
//  Created by Thief Toki on 2021/3/16.
//

#import "JMBoomSubmitTypeItem.h"

#import <JMBoomSDKBase/JMBoomSDKBase.h>

@implementation JMBoomSubmitTypeItem

- (instancetype)initWithType:(JMBoomSubmitType)type {
    self = [super init];
    if (self) {
        self.type = type;
        
        switch (type) {
            case JMBoomSubmitType_none:
                break;
            case JMBoomSubmitType_idea: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_idea"];
                self.title = @"意见建议";
                self.content = @"玩的不爽，我有话说";
                self.titleColor = [UIColor colorWithRed:98/255.0
                                                  green:142/255.0
                                                   blue:255/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:226/255.0
                                                       green:234/255.0
                                                        blue:255/255.0
                                                       alpha:1.0];
            }
                break;
            case JMBoomSubmitType_bug: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_bug"];
                self.title = @"产品BUG";
                self.content = @"功能故障或不能使用";
                self.titleColor = [UIColor colorWithRed:241/255.0
                                                  green:122/255.0
                                                   blue:83/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:255/255.0
                                                       green:237/255.0
                                                        blue:226/255.0
                                                       alpha:1.0];
            }
                break;
            case JMBoomSubmitType_nature: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_function"];
                self.title = @"性能问题";
                self.content = @"卡顿/闪退、发热/耗电";
                self.titleColor = [UIColor colorWithRed:122/255.0
                                                  green:96/255.0
                                                   blue:245/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:231/255.0
                                                       green:226/255.0
                                                        blue:255/255.0
                                                       alpha:1.0];
            }
                break;
            case JMBoomSubmitType_login: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_load"];
                self.title = @"登录问题";
                self.content = @"验证码收不到、网络问题";
                self.titleColor = [UIColor colorWithRed:79/255.0
                                                  green:157/255.0
                                                   blue:219/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:226/255.0
                                                       green:242/255.0
                                                        blue:255/255.0
                                                       alpha:1.0];
            }
                break;
            case JMBoomSubmitType_recharge: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_pay"];
                self.title = @"充值问题";
                self.content = @"充值不到账";
                self.titleColor = [UIColor colorWithRed:240/255.0
                                                  green:148/255.0
                                                   blue:52/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:255/255.0
                                                       green:243/255.0
                                                        blue:226/255.0
                                                       alpha:1.0];
            }
                break;
            case JMBoomSubmitType_others: {
                self.icon = [JMBoomSDKResource imageNamed:@"sug_ic_others"];
                self.title = @"其他问题";
                self.content = @"您说什么我们都听";
                self.titleColor = [UIColor colorWithRed:79/255.0
                                                  green:157/255.0
                                                   blue:219/255.0
                                                  alpha:1.0];
                self.backgroundColor = [UIColor colorWithRed:226/255.0
                                                       green:242/255.0
                                                        blue:255/255.0
                                                       alpha:1.0];
            }
                break;
                
                
                
                
                
                
                
        }
    }
    return self;
}

@end
