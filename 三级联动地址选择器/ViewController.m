//
//  ViewController.m
//  三级联动地址选择器
//
//  Created by suge on 2017/5/29.
//  Copyright © 2017年 郑州鹿客互联网科技有限公司. All rights reserved.
//

#define cityPickHeight 300

#import "ViewController.h"
#import "CityPickerView.h"
@interface ViewController ()<CityPickerViewDelegate>
@property (nonatomic,strong) CityPickerView *pickView;
@property (nonatomic,strong) UIView *mengbanView;
@property (weak, nonatomic) IBOutlet UIButton *selecteAddressButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initPickerView];
}
#pragma mark - 初始化地址选择器
- (void)initPickerView
{
    _pickView = [[CityPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, cityPickHeight)];
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.Delegate = self;
    [_pickView.cancelButton addTarget:self action:@selector(movePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickView];
    
}
#pragma mark - 地址选择pickerView的取消按钮的点击事件
- (void)movePickerView
{
    [UIView animateWithDuration:0.35 animations:^{
        _pickView.frame = CGRectMake(0,  self.view.frame.size.height,  self.view.frame.size.width, cityPickHeight);
    } completion:^(BOOL finished) {
        [_mengbanView removeFromSuperview];
    }];
}

#pragma mark - 调用地址选择器
- (IBAction)addressPick:(UIButton *)sender {
    _mengbanView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mengbanView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mengBanViewTapGesture:)];
    [_mengbanView addGestureRecognizer:tap];
    
    _mengbanView.backgroundColor = [UIColor blackColor];
    _mengbanView.alpha = 0.2;
    [self.view addSubview:_mengbanView];
    [self.view bringSubviewToFront:_pickView];
    [UIView animateWithDuration:0.35 animations:^{
        _pickView.frame = CGRectMake(0, (self.view.frame.size.height - cityPickHeight), self.view.frame.size.width, cityPickHeight);
    } completion:^(BOOL finished) {
    }];
    
}
#pragma mark - 所选择的城市
- (void)selectedProvinceAndCityAndArea:(NSString *)string
{
    [_selecteAddressButton setTitle:string forState:UIControlStateNormal];
    [UIView animateWithDuration:0.35 animations:^{
        _pickView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, cityPickHeight);
    } completion:^(BOOL finished) {
        [_mengbanView removeFromSuperview];
        
    }];
}



#pragma mark - 蒙版view的点击事件
- (void)mengBanViewTapGesture:(UITapGestureRecognizer *)gesture{
    // NSLog(@"******");
    [UIView animateWithDuration:0.35 animations:^{
        _pickView.frame = CGRectMake(0,  self.view.frame.size.height,  self.view.frame.size.width, cityPickHeight);
    } completion:^(BOOL finished) {
        [_mengbanView removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
