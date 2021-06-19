//
//  ViewController.m
//  RacTest
//
//  Created by Helios on 2021/4/15.
//

#import "ViewController.h"
#import "ReactiveObjC.h"

@interface ViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *lable;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.delegate = self;
    
    
    
    
    
    //按钮点击事件
    [[self.button rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIButton * _Nullable x) {
        NSLog(@"点击了:%@",x);
    }];
    
    //监听通知 / 键盘弹出
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardWillShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"键盘将要弹出 - %@",x);
    }];
    
    
    
    //输入变化
    [self.textField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {

        NSLog(@"%@",x);
    }];
    
    //带条件地监听变化
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {

        //当输入长度大于3时，才获取内容
        return value.length > 3;
    }] subscribeNext:^(NSString * _Nullable x) {

        NSLog(@"%@",x);
    }];
    
    //代理
    [[self rac_signalForSelector:@selector(textFieldDidBeginEditing:) fromProtocol:@protocol(UITextFieldDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"textFieldDidBeginEditing - %@",x);
    }];
    
    
    
    //手势
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] init];
    [self.view addGestureRecognizer:viewTap];
    __weak typeof(self) weakSelf = self;
    [[viewTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        NSLog(@"点击手势");
        [weakSelf.view endEditing:YES];
    }];
    
    //数组 - 遍历
    NSArray *array = @[@"凡几多",@"感",@"最潇洒"];
    [array.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    //字典 - 遍历
    NSDictionary *dict = @{@"name":@"凡几多",
                           @"age":@"20",
                           @"sex":@"男"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        RACTwoTuple *tuple = (RACTwoTuple *)x;
        NSLog(@"key == %@ , value = %@",tuple[0],tuple[1]);
    }];
    
    
    //宏
    
    //_textField的输入变化 与 lable的text绑定
    RAC(_lable,text) = _textField.rac_textSignal;
}


@end
