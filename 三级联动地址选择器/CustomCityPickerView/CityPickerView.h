//
//  CityPickerView.h
//  SugeText
//
//  Created by suge on 16/8/17.
//  Copyright © 2016年 素格. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol  CityPickerViewDelegate;
@interface CityPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic ,strong) UIPickerView *cityPicker;
@property (nonatomic ,strong) UILabel *cityLabel;

@property (nonatomic,weak) id<CityPickerViewDelegate>Delegate;
/** 1.数据源数组 */
@property (nonatomic, strong)NSArray *arrayRoot;
/** 2.当前省数组 */
@property (nonatomic, strong)NSMutableArray *arrayProvince;
/** 3.当前城市数组 */
@property (nonatomic, strong)NSMutableArray *arrayCity;
/** 4.当前地区数组 */
@property (nonatomic, strong)NSMutableArray *arrayArea;
/** 当前地区IDNumber数组 */
@property (nonatomic, strong)NSMutableArray *arrayIdNumber;
/** 5.当前选中数组 */
@property (nonatomic, strong)NSMutableArray *arraySelected;

/** 6.省份 */
@property (nonatomic, strong)NSString *province;
/** 7.城市 */
@property (nonatomic, strong)NSString *city;
/** 8.地区 */
@property (nonatomic, strong)NSString *area;
/**地区ID*/
@property (nonatomic, strong)NSString *idNumber;
@property (nonatomic,strong)UIButton *cancelButton;//取消
@property (nonatomic,strong)UIButton *sureButton;//确定
@end


@protocol CityPickerViewDelegate <NSObject>
/**返回省市区*/
- (void)selectedProvinceAndCityAndArea:(NSString *)string;


@end
