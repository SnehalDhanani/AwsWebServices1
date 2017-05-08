//
//  ViewController.m
//  AwsWebServices
//
//  Created by Snehal Patel on 2017-04-26.
//  Copyright © 2017 Snehal Patel. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()



@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)uploadToS3{
    

   // NSString *localfileName;
    
    
    
    UIImage *img = _imageView.image;
    
    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
    
    NSData *imageData = UIImagePNGRepresentation(img);
    
    [imageData writeToFile:path atomically:YES];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    
    _uploadRequest = [AWSS3TransferManagerUploadRequest new];
    
    _uploadRequest.bucket = @"musicintheair2";
    
    _uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    _uploadRequest.key = @"foldername/image.png";
    _uploadRequest.contentType = @"image/png";
    _uploadRequest.body = url;
    
    __weak ViewController *weakView = self;
    
    _uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_sync(dispatch_get_main_queue(),^{
            
            weakView.sizeUploaded = totalBytesSent;
            weakView.filesize = totalBytesExpectedToSend;
            [weakView update];
            
        });
        
    };
    
    AWSS3TransferManager * transferManager = [AWSS3TransferManager defaultS3TransferManager];
    [[transferManager upload:_uploadRequest] continueWithExecutor:[AWSExecutor mainThreadExecutor] withBlock:^id(AWSTask *task){
        
        if (task.error) {
            NSLog(@" Errrroooorrr : %@", task.error);
            
        }
        else{
            
            NSLog(@"https://s3-us-west-2.amazonaws.com/musicintheair2/foldername/image.png");
        }
        
        return nil;
        
    }];
    
}

- (void) update{
    
    _progressLabel.text = [NSString stringWithFormat:@"uploading:%.0f%%", (float)self.sizeUploaded/ (float)self.filesize * 100];
    
    
}

- (IBAction)pickImage:(id)sender {
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerController.delegate = self;
    [self presentViewController:pickerController animated:YES completion:nil];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    _selectedImageUrl = info[UIImagePickerControllerReferenceURL];
    
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = img;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)createLoadingView{
    
    _loadingBg = [[UIView alloc] initWithFrame:self.view.frame];
    [_loadingBg setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]];
    [self.view addSubview:_loadingBg];
    
    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 58)];
    _progressView.center = self.view.center;
    [_progressView setBackgroundColor:[UIColor whiteColor]];
    [_loadingBg addSubview:_progressView];
    
    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 258, 50)];
    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
    [_progressView addSubview:_progressLabel];
    
    _progressLabel.text = @"Uploading:";
                           
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)updateBtn:(id)sender {
    
    [self createLoadingView];
    [self uploadToS3];
    
    
}
@end
