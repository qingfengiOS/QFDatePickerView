//
//  QFHourModel.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QFHourModel : NSObject

/// 实际小时
@property (nonatomic, copy) NSString *hourString;

/// 展示的小时
@property (nonatomic, copy) NSString *showHourString;
@end
