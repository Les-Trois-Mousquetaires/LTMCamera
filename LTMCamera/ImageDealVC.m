//
//  ImageDealVC.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/28.
//

#import "ImageDealVC.h"
#import "ImageEditVC.h"
#import <Masonry/Masonry.h>

@interface ImageDealVC ()
@property(nonatomic,assign) BOOL statusHiden;
/// 原图
@property (strong, nonatomic) UIImageView *originImage;
/// 返回
@property (strong, nonatomic) UIButton *backBtn;
/// 完成
@property (strong, nonatomic) UIButton *completeBtn;
/// 编辑
@property (strong, nonatomic) UIButton *editBtn;
@end

@implementation ImageDealVC

- (BOOL)prefersStatusBarHidden{
    return  self.statusHiden;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.statusHiden = true;
    [self configOperationUI];
}

- (void)backBtnClick {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)completeBtnClick {
    
}

- (void)editBtnClick {
    ImageEditVC *edit = [[ImageEditVC alloc]init];
    edit.image = self.image;
    edit.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:edit animated:true completion:nil];
}

- (void)configOperationUI {
    [self.view addSubview:self.originImage];
    [self.view addSubview:self.completeBtn];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.editBtn];
    
    [self.originImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.equalTo(self.view);
    }];
    self.originImage.image = self.image;
    
    [self.completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-50);
        make.centerX.equalTo(self.view);
        make.width.equalTo(self.view).dividedBy(4);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.completeBtn);
        make.left.equalTo(self.view).offset(50);
    }];
    [self.editBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.completeBtn);
        make.right.equalTo(self.view).offset(-50);
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

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"BackBtnImage"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _backBtn;
}

- (UIButton *)completeBtn{
    if (!_completeBtn) {
        _completeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeBtn setTitle:@"完成" forState:(UIControlStateNormal)];
        [_completeBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
        _completeBtn.backgroundColor = [UIColor colorWithRed:247/255.0 green:223/255.0 blue:0/255.0 alpha:1];
        _completeBtn.layer.cornerRadius = 5;
        [_completeBtn addTarget:self action:@selector(completeBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _completeBtn;
}

- (UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setBackgroundImage:[UIImage imageNamed:@"EditBtnImage"] forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    return _editBtn;
}
@end
