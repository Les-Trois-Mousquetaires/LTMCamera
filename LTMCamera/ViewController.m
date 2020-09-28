//
//  ViewController.m
//  LTMCamera
//
//  Created by 柯南 on 2020/9/27.
//

#import "ViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "CustomCameraVC.h"
@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.imagePicker = [[UIImagePickerController alloc]init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = true;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    CustomCameraVC *vc = [[CustomCameraVC alloc]init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
