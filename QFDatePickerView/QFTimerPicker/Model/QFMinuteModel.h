//
//  QFMinuteModel.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFMinuteModel : NSObject

/// 实际分钟
@property (nonatomic, copy) NSString *minuteString;

/// 展示的分钟
@property (nonatomic, copy) NSString *showMinuteString;
@end
