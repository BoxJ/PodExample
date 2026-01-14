//
//  JMBoomSubmitType.h
//  Pods
//
//  Created by Thief Toki on 2021/3/15.
//

#ifndef JMBoomSubmitType_h
#define JMBoomSubmitType_h

typedef NS_ENUM(NSUInteger, JMBoomSubmitType) {
    JMBoomSubmitType_none = 0,
    JMBoomSubmitType_idea = 1,//意见反馈
    JMBoomSubmitType_bug = 2,//产品BUG
    JMBoomSubmitType_nature = 3,//性能问题
    JMBoomSubmitType_login = 4,//登录问题
    JMBoomSubmitType_recharge = 5,//充值问题
    JMBoomSubmitType_others = 6,//其他问题
};

#endif /* JMBoomSubmitType_h */
