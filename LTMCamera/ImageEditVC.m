//
//  ImageEditVC.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/28.
//

#import "ImageEditVC.h"

#import <Masonry/Masonry.h>

@interface ImageEditVC ()
{
    double Degree;
}
@property(nonatomic,assign) BOOL statusHiden;

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

@property (strong, nonatomic) UIImage *editImage;

@end

@implementation ImageEditVC

- (BOOL)prefersStatusBarHidden{
    return  self.statusHiden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.statusHiden = true;
    self.view.backgroundColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    [self configOperationUI];
    self.editImage = self.image;
    Degree = 0/180.0;
}

#pragma mark - Event

- (void)turnLeftBtnClick{
    CGFloat scale = UIScreen.mainScreen.bounds.size.width / UIScreen.mainScreen.bounds.size.height;

     Degree =  Degree - 90.0/180.0;
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI* Degree);
    self.originImage.transform = transform;//旋转
    int value = Degree / 0.5;

    if (value % 2 == 1) {
        [self.originImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.mas_equalTo(UIScreen.mainScreen.bounds.size.width - 40);
            make.width.mas_equalTo((UIScreen.mainScreen.bounds.size.width - 40) * 2/3);
        }];
    }else{
        [self.originImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.turnRightBtn.mas_top).offset(-30);
            make.width.equalTo(self.originImage.mas_height).multipliedBy(scale);
        }];
    }
}

- (void)turnRightBtnClick{
    CGFloat scale = UIScreen.mainScreen.bounds.size.width / UIScreen.mainScreen.bounds.size.height;

     Degree =  Degree + 90.0/180.0;
        CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI* Degree);
    self.originImage.transform = transform;//旋转
    int value = Degree / 0.5;

    if (value % 2 == 1) {
        [self.originImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.mas_equalTo(UIScreen.mainScreen.bounds.size.width - 40);
            make.width.mas_equalTo((UIScreen.mainScreen.bounds.size.width - 40) * 2/3);
        }];
    }else{
        [self.originImage mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
            make.centerX.equalTo(self.view);
            make.bottom.equalTo(self.turnRightBtn.mas_top).offset(-30);
            make.width.equalTo(self.originImage.mas_height).multipliedBy(scale);
        }];
    }
}


- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)resetBtnClick {
    
}

- (void)sureBtnClick {
    
}

- (void)configOperationUI {
    [self.view addSubview:self.turnLeftBtn];
    [self.view addSubview:self.turnRightBtn];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.cancelBtn];
    [self.view addSubview:self.resetBtn];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.originImage];
    
    CGFloat scale = UIScreen.mainScreen.bounds.size.width / UIScreen.mainScreen.bounds.size.height;
    self.originImage.image = self.image;
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-20);
        make.bottom.equalTo(self.view).offset(-14);
        make.width.equalTo(self.view).dividedBy(6);
        make.height.mas_equalTo(32);
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureBtn);
        make.centerX.equalTo(self.view);
        make.size.equalTo(self.sureBtn);
    }];
    [self.cancelBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureBtn);
        make.left.equalTo(self.view).offset(20);
        make.size.equalTo(self.sureBtn);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.sureBtn.mas_top).offset(-14);
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
    
    [self.originImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(10);
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.turnRightBtn.mas_top).offset(-30);
        make.width.equalTo(self.originImage.mas_height).multipliedBy(scale);
    }];
}

- (void)dealloc{
    NSLog(@"图片释放了");
}

#pragma mark - UILazy

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
