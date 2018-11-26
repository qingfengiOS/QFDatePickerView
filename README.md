## 前言
在日常开发过程中，时间选择器的使用场景应该是比较高的，而且各个场景的具体需求也各式各样，比如一些场景中，只需要选择年月，有的需要包含“至今”，有的选择时间，有的需要选择年月日和时分，然而这些都需要自定义数据源，这里把自己遇到过的类型做了一个总结和记录。  

## 年份选择
数据源1970至今，最后根据具体需求判断是否需要添加"至今"数据源，效果如下： 

![year](https://upload-images.jianshu.io/upload_images/2598795-e3ecd95c3700ab82.png)
  
## 年和月份选择  
年份数据源1970至今，月份为当年的最大月份，当切换到其他年份时，月份数据源变更为1~12月，当选择到“至今”时，月份数据为空，效果如下：  
  
![year&month](https://upload-images.jianshu.io/upload_images/2598795-496f71b93cbd8ad2.png)  

## 时和分选择 
这里的起止时间节点根据初始化时传入的数据进行配置，分钟的间隔数也由调用者动态配置   
![hour&min](https://upload-images.jianshu.io/upload_images/2598795-207f1ba8fdd35d41.png)

## 仿滴滴时间选择  
这个picker是这几种类型中相对最复杂的一种，牵涉到数据源的完全计算，NSdate和NSString的相互转换，pickView样式的高度自定义。之前已经写过一篇，这里就不做copy了，详情请看：[iOS仿滴滴预约用车时间选择器](https://juejin.im/post/5bf7a4ce51882550d05ca29a)  

## 使用方式  
各个picker的数据源，基本没有难点，有兴趣的可自行查看[源码](https://github.com/qingfengiOS/QFDatePickerView.git)。  

稍微说说使用方式，下载源码，拖入工程，或者直接使用cocoapods：pod 'QFDatePicker'

调用对应的初始化方法（init...）和show方法，以年份为例：  

```
QFDatePickerView *datePickerView = [[QFDatePickerView alloc]initYearPickerWithView:self.view response:^(NSString *str) {
        NSString *string = str;
        NSLog(@"str = %@",string);
    }];
    
[datePickerView show];
```
选中的时间在block中处理，其他调用类似，相信睿智的您一眼就能看明白。  
这篇主要是对一年前的文章做一次整理（之前的确实有点辣眼睛），希望看到的朋友轻喷。   

最后，希望各位大神指点，如果对您有用的话请顺手给个star
[演示Demo](https://github.com/qingfengiOS/QFDatePickerView)  
[cocoaPods安装](https://github.com/qingfengiOS/QFDatePicker)
 

