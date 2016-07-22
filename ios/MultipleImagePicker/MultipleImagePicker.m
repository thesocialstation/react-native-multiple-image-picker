//
//  MultipleImagePicker.m
//  MultipleImagePicker
//
//  Created by Ron Heft on 7/22/16.
//  Copyright © 2016 The Social Station. All rights reserved.
//

#import "MultipleImagePicker.h"

@interface MultipleImagePicker ()

@property (nonatomic, retain) NSDictionary *options;
@property (nonatomic, strong) RCTPromiseResolveBlock resolve;
@property (nonatomic, strong) RCTPromiseRejectBlock reject;
@property (nonatomic, retain) QBImagePickerController *picker;

@end

@implementation MultipleImagePicker

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(showImagePicker:(NSDictionary *)options resolver:(RCTPromiseResolveBlock)resolve rejector:(RCTPromiseRejectBlock)reject)
{
    self.options = options;
    self.resolve = resolve;
    self.reject = reject;
    
    self.picker = [QBImagePickerController new];
    self.picker.delegate = self;
    self.picker.allowsMultipleSelection = YES;
    self.picker.maximumNumberOfSelection = 6;
    self.picker.showsNumberOfSelectedAssets = YES;
    
    void (^showImagePickerViewController)() = ^void() {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            while (root.presentedViewController != nil) {
                root = root.presentedViewController;
            }
            [root presentViewController:self.picker animated:YES completion:nil];
        });
    };
    
    [self checkPhotosPermissions:^(BOOL granted) {
        if (!granted) {
            self.reject(@"Permissions", @"Photos permission not granted", nil);
            return;
        }
        
        showImagePickerViewController();
    }];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets
{
    dispatch_block_t dismissCompletionBlock = ^{
        self.resolve(assets);
    };
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.picker dismissViewControllerAnimated:YES completion:dismissCompletionBlock];
    });
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.picker dismissViewControllerAnimated:YES completion:^{
            self.reject(@"Cancel", @"User canceled picker interface", nil);
        }];
    });
}

- (void)checkPhotosPermissions:(void(^)(BOOL granted))callback
{
    if (![PHPhotoLibrary class]) { // iOS 7 support
        callback(YES);
        return;
    }
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusAuthorized) {
        callback(YES);
        return;
    } else if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                callback(YES);
                return;
            }
            else {
                callback(NO);
                return;
            }
        }];
    }
    else {
        callback(NO);
    }
}

@end
