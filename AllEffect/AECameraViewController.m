//
//  AECameraViewController.m
//  AllEffect
//
//  Created by Sandeep Nasa on 2/21/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import "AECameraViewController.h"
#import "GPUImage.h"
#import "AEDataClass.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface AECameraViewController ()
{

    GPUImageStillCamera *stillCamera;
    GPUImageFilter *filter;
}
-(IBAction)captureImage:(id)sender;

@end


@implementation AECameraViewController
@synthesize delegate;

-(void)customSetup{
    
    // Setup initial camera filter
    filter = [[GPUImageFilter alloc] init];
    [filter prepareForImageCapture];
    GPUImageView *filterView = (GPUImageView *)self.view;
    [filter addTarget:filterView];
    // Create custom GPUImage camera
    stillCamera = [[GPUImageStillCamera alloc] init];
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    [stillCamera addTarget:filter];
    // Begin showing video camera stream
    [stillCamera startCameraCapture];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    [self customSetup];
}

-(IBAction)captureImage:(id)sender{
    
    // Disable to prevent multiple taps while processing
    UIButton *captureButton = (UIButton *)sender;
    captureButton.enabled = NO;
    // Snap Image from GPU camera, send back to main view controller
    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error)
     {
         if([delegate respondsToSelector:@selector(didSelectStillImage:withError:)])
         {
             [self.delegate didSelectStillImage:processedJPEG withError:error];
         }
         else
         {
             NSLog(@"Delegate did not respond to message");
         }
         runOnMainQueueWithoutDeadlocking(^{
             
             [self.navigationController popToRootViewControllerAnimated:YES];
             
         });
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    
    [super viewDidUnload];
}
@end

/*
-(void)setupFavCameraFeed{
    
    
     NSMutableArray *effectArray=[[NSMutableArray alloc] init];
     
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageFilter alloc] init] withName:@"Original"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageGrayscaleFilter alloc] init] withName:@"Gray Scale"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageSepiaFilter alloc] init] withName:@"Sepia"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageSketchFilter alloc] init] withName:@"Sketch"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImagePixellateFilter alloc] init] withName:@"Pixellate"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageColorInvertFilter alloc] init] withName:@"Color Invert"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImageToonFilter alloc] init] withName:@"Toon"]];
     [effectArray addObject:[AEDataClass liveFilter:[[GPUImagePinchDistortionFilter alloc] init] withName:@"Distort"]];
     
     
     [self createScrollFilter:self.favScrollView withData:effectArray];
     

    
}
-(void)createScrollFilter:(UIScrollView *)scrollView withData:effectArray{

    float x=scrollView.frame.origin.x;
    NSString *deviceModel=[UIDevice currentDevice].model;
    CGRect frame=CGRectZero;
    
    for (int i=0; i<[effectArray count]; i++) {
        
        AEDataClass *data=nil;
        
        data=(AEDataClass *)[effectArray objectAtIndex:i];
        GPUImageFilter *favFilter=[data filter];
        
         AECustomView *favImageView=[[AECustomView alloc] init];
         [favImageView setBackgroundColor:[UIColor lightGrayColor]];
        
         if ([deviceModel isEqualToString:@"iPad Simulator"]) {
        
            frame =CGRectMake(x+2, 2,150, 62);
        
            }
            else{
                frame=CGRectMake(x+2, 2, 150, 64);
        
          }
         [favImageView setFrame:frame];

        [favFilter addTarget:favImageView];
        // Create custom GPUImage camera
        GPUImageStillCamera  *favStillCamera = [[GPUImageStillCamera alloc] init];
        favStillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        [favStillCamera addTarget:favFilter];
        // Begin showing video camera stream
        [favStillCamera startCameraCapture];

        [scrollView addSubview:favImageView];
        x+=160;
        [scrollView setContentSize:CGSizeMake(x, 40)];
    }
}
 */

