//
//  ViewController.m
//  fbShare
//
//  Created by 杨乐乐 on 17/3/8.
//  Copyright © 2017年 com.gumptech. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface ViewController ()<FBSDKSharingDelegate,UIImagePickerControllerDelegate>
- (IBAction)shareWindowBtnClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//link 分享
- (IBAction)shareWindowBtnClick:(id)sender {
    
    FBSDKShareLinkContent *linkContent = [[FBSDKShareLinkContent alloc] init];
    linkContent.contentURL = [NSURL URLWithString:@"https://image.baidu.com"];
    linkContent.contentTitle = @"百度";
    linkContent.contentDescription = [[NSString alloc] initWithFormat:@"%@",@"星空图片欣赏"];
    linkContent.imageURL = [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561310690603&di=6fb462fc7c72ab479061c8045639f87b&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F4034970a304e251fb1a2546da986c9177e3e53c9.jpg"];
    [FBSDKShareDialog showFromViewController:self withContent:linkContent delegate:self];
    
}

- (IBAction)shareImageClick:(id)sender {
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1561310690603&di=6fb462fc7c72ab479061c8045639f87b&imgtype=0&src=http%3A%2F%2Fe.hiphotos.baidu.com%2Fimage%2Fpic%2Fitem%2F4034970a304e251fb1a2546da986c9177e3e53c9.jpg"]]];
    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;
    photo.userGenerated = YES;
    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[photo];
    
    [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    
    
}

- (IBAction)shareVideoClick:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.mediaTypes = @[(NSString *)kUTTypeMovie, (NSString *)kUTTypeImage];
    
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
}



#pragma mark FBSDKSharingDelegate
-(void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    NSLog(@"success");
}

-(void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    NSLog(@"cancel");
}

-(void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    NSLog(@"faile");
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        NSURL *url = info[UIImagePickerControllerImageURL];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
        
    }else if([mediaType isEqualToString:(NSString *)kUTTypeMovie]){
        NSURL *url = info[UIImagePickerControllerReferenceURL];
        FBSDKShareVideo *video = [[FBSDKShareVideo alloc] init];
        video.videoURL = url;
        FBSDKShareVideoContent *content = [[FBSDKShareVideoContent alloc] init];
        content.video = video;
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}
@end
