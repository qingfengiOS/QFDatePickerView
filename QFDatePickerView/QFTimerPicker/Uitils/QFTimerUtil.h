//
//  QFUtil.h
//  QFTimerPicker
//
//  Created by 情风 on 2018/11/19.
//  Copyright © 2018年 qingfengiOS. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QFTimerDataSourceModel;

@interface QFTimerUtil : NSObject

/**
 获取pickerView数据源

 @return pickerView数据源
 */
+ (QFTimerDataSourceModel *)configDataSource;

@end
