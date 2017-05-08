//
//  ViewController.h
//  AwsWebServices
//
//  Created by Snehal Patel on 2017-04-26.
//  Copyright © 2017 Snehal Patel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AWSCore.h"
#import "AWSS3.h"


@interface ViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>




@property (nonatomic, strong) UIView *loadingBg;
@property (nonatomic, strong) UIView *progressView;
@property (nonatomic, strong) UILabel *progressLabel;
@property (nonnull, strong) NSURL *selectedImageUrl;


@property (nonatomic,strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t sizeUploaded;

- (IBAction)updateBtn:(id)sender;


@end

