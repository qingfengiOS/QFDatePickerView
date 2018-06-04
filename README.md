# QFDatePickerView
两句代码集成只有年、月的时间选择器 系统自带的DatePicker并不支持此种方式的选择，但是需求很可能只需要年和月，此Demo可两句代码实现此需求

步骤：   
step1：拖入QFDatePickerView至自己的工程文件   
step2: 在需要的控制器里面导入头文件#import "QFDatePickerView.h"   
step3：在需要的地方调用初始化方法 initDatePackerWithResponse 和 show方法   
step4：最后可以在Block中处理返回的时间

上面我们已经完成了对日期的选择，接下来就是对时间的选择，苹果原生的DatePicker支持以每一分钟为单位的时间选择，但是在实际项目中常常需求并非如此，并不需要选到每一分钟，可能需要以5分钟、10分钟等为单位选择，实现方法类似；调用方法和日期选择一样，直接调用对应的初始化方法，传入开始时间，结束时间，时间间隔三个参数，返回结果在block里处理。详见Demo。

支持了cocoapods安装，[参见:](https://github.com/qingfengiOS/QFDatePicker.git)   
最后，希望各位大神指点，如果对您有用的话请顺手给个star
