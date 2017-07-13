//
//  CityPickerView.m
//  SugeText
//
//  Created by suge on 16/8/17.
//  Copyright © 2016年 素格. All rights reserved.
//
#define cityPickHeight 300

#import "CityPickerView.h"

@implementation CityPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //从plist文件中获取数据源
        [self getDataSourceFromPlist];
        //初始化pickerView
        [self initPickerViewWithRect:frame];
        //初始化取消和确定按钮
        [self createCancelAndSureButton];
        
    }
    return self;
}
#pragma mark - 初始化取消和确定按钮
- (void)createCancelAndSureButton
{
    //取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cancelButton.frame = CGRectMake(10,10, 40, 25);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    //    _cancelButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    //    _cancelButton.layer.borderWidth = 1.0;
    [self addSubview:_cancelButton];
    
    //确定按钮
    _sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _sureButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 40 - 10,10, 40, 25);
    [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
    //        _sureButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [_sureButton addTarget:self action:@selector(sendCityData) forControlEvents:UIControlEventTouchUpInside];
    //    _sureButton.layer.borderWidth = 1.0;
    [self addSubview:_sureButton];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_sureButton.frame) + 9, [UIScreen mainScreen].bounds.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];

    [self addSubview:line];
}
#pragma mark - 从plist文件中获取数据
- (void)getDataSourceFromPlist
{
    
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"address" ofType:@"plist"];
    
    //总数据文件
    _arrayRoot = [[NSArray alloc]initWithContentsOfFile:plistPath];
    
    
    //存放省份的数组
    _arrayProvince = [[NSMutableArray alloc] initWithCapacity:0];
    [self.arrayRoot enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //        [self.arrayProvince addObject:obj[@"province"]];
        [self.arrayProvince addObject:obj[@"_name"]];
    }];
    
    //    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"citys"]];
    NSMutableArray *citys = [NSMutableArray arrayWithArray:[self.arrayRoot firstObject][@"city"]];
    
    //存放城市的数组
    _arrayCity = [[NSMutableArray alloc] initWithCapacity:0];
    [citys enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.arrayCity addObject:obj[@"_name"]];
    }];
    //存放地区的数组
    _arrayArea = [[NSMutableArray alloc] initWithCapacity:0];
    //存放地区id的数组
    _arrayIdNumber = [[NSMutableArray alloc] initWithCapacity:0];
    //    _arrayArea = [citys firstObject][@"area"];
    NSArray *districtArray = [citys firstObject][@"district"];
    for (NSDictionary *dic in districtArray) {
        
        NSString *tempString = dic[@"_name"];
        if (![tempString isEqualToString:@"其他区"]) {
            [_arrayArea addObject:dic[@"_name"]];
            [_arrayIdNumber addObject:dic[@"_zipcode"]];
        }
        
        
        //        [_arrayArea addObject:dic[@"_name"]];
        //        [_arrayIdNumber addObject:dic[@"_zipcode"]];
    }
    //    _arrayArea = [citys firstObject][@"district"];
}
#pragma mark - 初始化pickerView
- (void)initPickerViewWithRect:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    _cityPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 35 + 10 + 1,[UIScreen mainScreen].bounds.size.width, frame.size.height - 40)];
//    _cityPicker.backgroundColor = [UIColor greenColor];
    _cityPicker.delegate = self;
    _cityPicker.dataSource = self;
    _cityPicker.showsSelectionIndicator = YES;
    
    [self addSubview:_cityPicker];
    
//    _cityPicker.backgroundColor = [UIColor whiteColor];
    //    //显示默认城市
    //    [self reloadData];
}
#pragma mark - 确定按钮的点击事件
- (void)sendCityData
{
    if (![self anySubViewScrolling:self.cityPicker]) {
        //显示默认城市
        [self reloadData];
    }else{
//        NSLog(@"地址选择器正在滑动，请选定地址后再确定");
    }
    //显示默认城市
    //    [self reloadData];
}
#pragma mark - 判断地址选择器是否正在滑动
- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in  view.subviews) {
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}

- (void)reloadData
{
    NSInteger index0 = [self.cityPicker selectedRowInComponent:0];
    NSInteger index1 = [self.cityPicker selectedRowInComponent:1];
    NSInteger index2 = [self.cityPicker selectedRowInComponent:2];
    self.province = self.arrayProvince[index0];
    self.city = self.arrayCity[index1];
    if (self.arrayArea.count != 0) {
        self.area = self.arrayArea[index2];
        self.idNumber = self.arrayIdNumber[index2];
    }else{
        self.area = @"";
        self.idNumber = @"";
    }
    
    //    NSString *title = [NSString stringWithFormat:@"%@%@%@%@", self.province, self.city, self.area,self.idNumber];//最后添加一个区的id测试数据
//    NSLog(@"所选择的地区的ID====%@",self.idNumber);
    NSString *title = [NSString stringWithFormat:@"%@%@%@", self.province, self.city, self.area];//最后添加一个区的id测试数据
    
    if ([_Delegate respondsToSelector:@selector(selectedProvinceAndCityAndArea:)]) {
        [_Delegate selectedProvinceAndCityAndArea:title];
    }
    self.cityLabel.text = title;
    
}
#pragma mark - 设置列宽
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [UIScreen mainScreen].bounds.size.width/3.0;
//    return 100;
}
#pragma mark - 行高
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}
#pragma mark - 返回显示的列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
#pragma mark - 返回当前列显示的行数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _arrayProvince.count;
    }
    else if (component == 1) {
        return _arrayCity.count;
    }
    else {
        return _arrayArea.count;
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view
{
    
    NSString *text;
    if (component == 0) {
        text =  self.arrayProvince[row];
    }else if (component == 1){
        text =  self.arrayCity[row];
    }else{
        if (self.arrayArea.count > 0) {
            text = self.arrayArea[row];
        }else{
            text =  @"";
        }
    }
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.frame = CGRectMake(0, 3,  125, 40 - 6);
    [label setFont:[UIFont systemFontOfSize:17]];
//    label.backgroundColor = [UIColor greenColor];
    [label setText:text];
    
    
    for(UIView *speartorView in _cityPicker.subviews)
    {
        if (speartorView.frame.size.height < 1)//取出分割线view
        {
            speartorView.hidden = NO;
            speartorView.backgroundColor = [UIColor redColor];//隐藏分割线
        }
    }
    
    
    
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        //        self.arraySelected = self.arrayRoot[row][@"citys"];
        self.arraySelected = self.arrayRoot[row][@"city"];//
        
        [self.arrayCity removeAllObjects];
        [self.arraySelected enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.arrayCity addObject:obj[@"_name"]];
        }];
        
        //        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"area"]];
        NSArray *tempArray = [self.arraySelected firstObject][@"district"];
        self.arrayArea = [[NSMutableArray alloc] initWithCapacity:0];
        self.arrayIdNumber = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in tempArray) {
            
            if (![dic[@"_name"] isEqualToString:@"其他区"]) {
                [self.arrayArea addObject:dic[@"_name"]];
                [self.arrayIdNumber addObject:dic[@"_zipcode"]];
            }
            
            
            //            [self.arrayArea addObject:dic[@"_name"]];
            //            [self.arrayIdNumber addObject:dic[@"_zipcode"]];
        }
        //        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected firstObject][@"areas"]];
        
        
        
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else if (component == 1) {
        if (self.arraySelected.count == 0) {
            //            self.arraySelected = [self.arrayRoot firstObject][@"citys"];
            self.arraySelected = [self.arrayRoot firstObject][@"city"];
            
        }
        
        //        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"area"]];
        
        NSArray *tempArray = [self.arraySelected objectAtIndex:row][@"district"];
        self.arrayArea = [[NSMutableArray alloc] initWithCapacity:0];
        self.arrayIdNumber = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary *dic in tempArray) {
            if (![dic[@"_name"] isEqualToString:@"其他区"]) {
                [self.arrayArea addObject:dic[@"_name"]];
                [self.arrayIdNumber addObject:dic[@"_zipcode"]];
            }
            
            
            //            [self.arrayArea addObject:dic[@"_name"]];
            //            [self.arrayIdNumber addObject:dic[@"_zipcode"]];
        }
        
        
        //        self.arrayArea = [NSMutableArray arrayWithArray:[self.arraySelected objectAtIndex:row][@"areas"]];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
        
    }else{
    }
    //    [self reloadData];
}

@end
