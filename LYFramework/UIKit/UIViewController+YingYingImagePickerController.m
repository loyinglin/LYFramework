//
//  UIViewController+YingYingImagePickerController.m
//  Yingying
//
//  Created by 林伟池 on 16/1/3.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "UIViewController+YingYingImagePickerController.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIViewController (YingYingImagePickerController)
//@dynamic myPickImage;
//
//- (id) myPickImage
//{
//    return objc_getAssociatedObject(self, @selector(myPickImage));
//}
//
//- (void)setMyPickImage:(id)image
//{
//    objc_setAssociatedObject(self, @selector(myPickImage), image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


- (void)lyModalChoosePicker {
    UIAlertController* controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    @weakify(self);
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"cancel");
    }];
    [controller addAction:cancel];
    
    UIAlertAction* takePhoto = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self takePhoto];
    }];
    [controller addAction:takePhoto];
    
    UIAlertAction* localPhoto = [UIAlertAction actionWithTitle:@"从手机相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        @strongify(self);
        [self LocalPhoto];
    }];
    [controller addAction:localPhoto];
    
    [self presentViewController:controller animated:YES completion:nil];
}
#pragma mark - ui

-(void)takePhoto
{
//    if([ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusRestricted||[ALAssetsLibrary authorizationStatus]==ALAuthorizationStatusDenied)
//    {
//        
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:@"相册已禁用，请在系统设置里设置此应用访问相册权限"
//                                                       delegate:self
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil,nil];
//        
//        [alert show];
//        
//        return;
//    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        CGRect rect = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        image = [self imageChangeWithSize:rect WithImage:image];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_UI_IMAGE_PICKER_DONE object:image];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageChangeWithSize:(CGRect)rect WithImage:(UIImage *)image
{
    UIImage *sourceImage = image;
    UIImage *newImage = nil;
    CGImageRef newCGImage = CGImageCreateWithImageInRect([sourceImage CGImage], rect);
    newImage = [UIImage imageWithCGImage:newCGImage];
    if(newImage == nil) {
        NSLog(@"could not scale image");
    }
    return newImage;
}
@end
