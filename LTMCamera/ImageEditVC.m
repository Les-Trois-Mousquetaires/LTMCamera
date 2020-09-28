//
//  ImageEditVC.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/28.
//

#import "ImageEditVC.h"

#import <Masonry/Masonry.h>

@interface ImageEditVC ()
/// 原图
@property (strong, nonatomic) UIImageView *originImage;
/// 左转
@property (strong, nonatomic) UIButton *turnLeftBtn;
/// 右转
@property (strong, nonatomic) UIButton *turnRightBtn;
/// 线
@property (strong, nonatomic) UIView *lineView;
/// 取消
@property (strong, nonatomic) UIButton *cancelBtn;
/// 还原
@property (strong, nonatomic) UIButton *resetBtn;
/// 确定
@property (strong, nonatomic) UIButton *sureBtn;
@end

@implementation ImageEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self configOperationUI];

}

#pragma mark - Event

- (void)turnLeftBtnClick{
    
}

- (void)turnRightBtnClick{
    
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)resetBtnClick {
    
}

- (void)sureBtnClick {
    
}
- (void)configOperationUI {
    [self.view addSubview:self.originImage];
    [self.view addSubview:self.turnLeftBtn];
    [self.view addSubview:self.turnRightBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.resetBtn];
    [self.view addSubview:self.sureBtn];
    CGFloat scale = (UIScreen.mainScreen.bounds.size.width  - 48 * 2)/UIScreen.mainScreen.bounds.size.width;
    
    [self.originImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view).offset(20);
        }
        make.left.equalTo(self.view).offset(48);
        make.right.equalTo(self.view).offset(-48);
        make.height.mas_equalTo(UIScreen.mainScreen.bounds.size.height * scale);
    }];
    self.originImage.image = self.image;
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.equalTo(self.view).offset(-20);
        make.width.equalTo(self.view).dividedBy(6);
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureBtn);
        make.centerX.equalTo(self.view);
    }];
    [self.cancelBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureBtn);
        make.left.equalTo(self.view).offset(20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(1);
    }];
    [self.turnLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cancelBtn);
        make.bottom.equalTo(self.lineView.mas_top).offset(-20);
    }];
    [self.turnRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.turnLeftBtn);
            make.right.equalTo(self.sureBtn);
    }];
}

- (void)dealloc{
    NSLog(@"图片释放了");
}

- (UIImageView *)originImage{
    if (!_originImage) {
        _originImage = [[UIImageView alloc]init];
    }
    return _originImage;
}

- (UIButton *)turnLeftBtn{
    if (!_turnLeftBtn) {
        _turnLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_turnLeftBtn setBackgroundImage:[UIImage imageNamed:@"TurnLeftImage"] forState:UIControlStateNormal];
        [_turnLeftBtn addTarget:self action:@selector(turnLeftBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _turnLeftBtn;
}

- (UIButton *)turnRightBtn{
    if (!_turnRightBtn) {
        _turnRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_turnRightBtn setBackgroundImage:[UIImage imageNamed:@"TurnRightImage"] forState:UIControlStateNormal];
        [_turnRightBtn addTarget:self action:@selector(turnRightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _turnRightBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
    }
    
    return _lineView;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:@"取消" forState:(UIControlStateNormal)];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _cancelBtn;
}

- (UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_resetBtn setTitle:@"还原" forState:(UIControlStateNormal)];
        [_resetBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:(UIControlStateNormal)];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        [_resetBtn addTarget:self action:@selector(resetBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _resetBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:(UIControlStateNormal)];
        [_sureBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _sureBtn.backgroundColor = [UIColor colorWithRed:247/255.0 green:223/255.0 blue:0/255.0 alpha:1];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
        _sureBtn.layer.cornerRadius = 5;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _sureBtn;
}

@end
