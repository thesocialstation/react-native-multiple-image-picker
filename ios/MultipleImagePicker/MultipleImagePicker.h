//
//  MultipleImagePicker.h
//  MultipleImagePicker
//
//  Created by Ron Heft on 7/22/16.
//  Copyright © 2016 The Social Station. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RCTBridgeModule.h"
#import <QBImagePickerController/QBImagePickerController.h>

@interface MultipleImagePicker : NSObject<RCTBridgeModule, QBImagePickerControllerDelegate>

@end
