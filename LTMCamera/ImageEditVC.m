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
@property (nonatomic, assign) BOOL statusHiden;

/// 原图
@property (nonatomic, strong) UIImageView *originImage;
/// 左转
@property (nonatomic, strong) UIButton *turnLeftBtn;
/// 右转
@property (nonatomic, strong) UIButton *turnRightBtn;
/// 线
@property (nonatomic, strong) UIView *lineView;
/// 取消
@property (nonatomic, strong) UIButton *cancelBtn;
/// 还原
@property (nonatomic, strong) UIButton *resetBtn;
/// 确定
@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIImage *editImage;
@property (nonatomic, assign) BOOL isEdit;

/// 起始点
@property (nonatomic, assign) CGPoint startPoint;
/// 半透明view
@property (nonatomic, strong) UIView *clipView;

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
    // 给控制器的view添加pan手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        
        [self.view addGestureRecognizer:pan];
}

-(void)pan:(UIPanGestureRecognizer *)pan {
    [self configEdit];
    CGPoint endPoint = CGPointZero;

    if (pan.state == UIGestureRecognizerStateBegan) { //一开始拖动的时候
        // 获取一开始的点
        self.startPoint = [pan locationInView:self.view];
    } else if (pan.state == UIGestureRecognizerStateChanged) { // 拖动过程中
        // 获取结束点
        endPoint = [pan locationInView:self.view];
        
        CGFloat w = endPoint.x - _startPoint.x;
        CGFloat h = endPoint.y - _startPoint.y;
        
        // 截取范围
        CGRect clipRect = CGRectMake(self.startPoint.x, self.startPoint.y, w, h);
        self.clipView.frame = clipRect;
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // 创建上下文
        UIGraphicsBeginImageContextWithOptions(self.originImage.bounds.size, NO, 0);
        
        // 获取上下文
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        // 设置裁剪区域
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.clipView.frame];
        
        // 添加裁剪
        [path addClip];
        // 将图片渲染到上下图中
        [self.originImage.layer renderInContext:context];
        
        // 获取截取下来的图片
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        [self turnTransform:0];

        self.originImage.image = image;
        
        // 截取的半透明view移除
        [self.clipView removeFromSuperview];
        
        self.clipView = nil;
    }
}


#pragma mark - Event

- (void)turnLeftBtnClick{
    [self configEdit];
    Degree =  Degree - 90.0/180.0;
    [self turnTransform:Degree];
}

- (void)turnRightBtnClick{
    [self configEdit];
    Degree =  Degree + 90.0/180.0;
    [self turnTransform:Degree];
}
/// 进行旋转
- (void)turnTransform:(double)angle {
    CGFloat scale = UIScreen.mainScreen.bounds.size.width / UIScreen.mainScreen.bounds.size.height;
    
    CGAffineTransform transform= CGAffineTransformMakeRotation(M_PI* angle);
    self.originImage.transform = transform;//旋转
    int value = angle / 0.5;
    
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

- (void)configEdit {
    self.isEdit = true;
    [self.resetBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.resetBtn.enabled = true;
}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)resetBtnClick {
    [self turnTransform:0];
    self.originImage.image = self.image;
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
        _originImage.contentMode = UIViewContentModeScaleAspectFill;
        
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
        _resetBtn.enabled = false;
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

-(UIView *)clipView {
    if (!_clipView) {
        _clipView = [[UIView alloc] init];
        _clipView.backgroundColor = [UIColor blackColor];
        _clipView.alpha = 0.3;
        
        [self.view addSubview:_clipView];
    }
    
    return _clipView;
}
@end
