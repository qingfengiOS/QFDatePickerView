//
//  QFDateModel.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFDateModel : NSObject

/// 实际日期
@property (nonatomic, copy) NSString *dateString;

/// 展示的日期
@property (nonatomic, copy) NSString *showDateString;

@end

