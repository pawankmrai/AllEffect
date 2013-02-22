//
//  AEViewController.m
//  AllEffect
//
//  Created by Sandeep Nasa on 2/18/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import "AEViewController.h"
#import "GPUImage.h"
#import "UIImage+Resize.h"

@interface AEViewController ()
{
    UIImage *originalImage;
    NSMutableArray *displayImages;
}
@property(nonatomic, weak) IBOutlet iCarousel *photoCarousel;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *filterButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property(strong, nonatomic)  UIPopoverController *popController;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

-(IBAction)photoFromAlbum:(id)sender;
-(IBAction)photoFromCamera:(id)sender;
-(IBAction)applyImageFilter:(id)sender;
-(IBAction)saveImageToAlbum:(id)sender;
@end

@implementation AEViewController
@synthesize popController;
@synthesize filterButton,saveButton,toolBar;
@synthesize photoCarousel;

- (void)customSetup
{
    displayImages = [[NSMutableArray alloc] init];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]))
    {
        [self customSetup];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self customSetup];
    }
    return self;
}
#pragma mark
#pragma mark iCarousel DataSource/Delegate/Custom
- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [displayImages count];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
    // Create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 300.0f)];
        view.contentMode = UIViewContentModeCenter;
    }
    // Intelligently scale down to a max of 250px in width or height
    originalImage = [displayImages objectAtIndex:index];
    CGSize maxSize = CGSizeMake(250.0f, 250.0f);
    CGSize targetSize;
    // If image is landscape, set width to 250px and dynamically figure out height
    if(originalImage.size.width >= originalImage.size.height)
    {
        float newHeightMultiplier = maxSize.width / originalImage.size.width;
        targetSize = CGSizeMake(maxSize.width, round(originalImage.size.height * newHeightMultiplier));
    } // If image is portrait, set height to 250px and dynamically figure out width
    else
    {
        float newWidthMultiplier = maxSize.height / originalImage.size.height;
        targetSize = CGSizeMake( round(newWidthMultiplier * originalImage.size.width), maxSize.height );
    }
    // Resize the source image down to fit nicely in iCarousel
    ((UIImageView *)view).image = [[displayImages objectAtIndex:index] resizedImage:targetSize interpolationQuality:kCGInterpolationHigh];
    // Two finger double-tap will delete an image
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImageFromCarousel:)];
    gesture.numberOfTouchesRequired = 1;
    gesture.numberOfTapsRequired = 2;
    view.gestureRecognizers = [NSArray arrayWithObject:gesture];
    return view;
}
- (void)removeImageFromCarousel:(UIGestureRecognizer *)gesture
{
    [gesture removeTarget:self action:@selector(removeImageFromCarousel:)];
    [UIView animateWithDuration:0.9
                          delay:1.0f
                        options: UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         
                          CGRect frame=CGRectMake(320, 480, 10, 10);
                          [self.photoCarousel.currentItemView setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         [displayImages removeObjectAtIndex:self.photoCarousel.currentItemIndex];
                         [self.photoCarousel reloadData];
                         
                     }];
    
    [UIView commitAnimations];

    
    
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // iCarousel Configuration
    self.photoCarousel.type = iCarouselTypeCoverFlow2;
    self.photoCarousel.bounces = NO;
}
- (IBAction)applyImageFilter:(id)sender
{
    if ([displayImages count]<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waring"
                                                        message:@"No Image to apply filter"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
        self.saveButton.enabled=NO;
        self.filterButton.enabled=NO;
        
    }
    else{
        
        UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter"
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                         destructiveButtonTitle:nil
                                                              otherButtonTitles:@"Grayscale", @"Sepia", @"Sketch", @"Pixellate", @"Color Invert", @"Toon", @"Pinch Distort", @"None", nil];
        
        [filterActionSheet showFromToolbar:self.toolBar];
        
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    GPUImageFilter *selectedFilter;
    switch (buttonIndex) {
        case 0:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImagePixellateFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageToonFilter alloc] init];
            break;
        case 6:
            selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 7:
            selectedFilter = [[GPUImageFilter alloc] init];
            break;
        default:
            break;
    }
    UIImage *filteredImage = [selectedFilter imageByFilteringImage:[displayImages objectAtIndex:self.photoCarousel.currentItemIndex]];
    [displayImages replaceObjectAtIndex:self.photoCarousel.currentItemIndex withObject:filteredImage];
    [self.photoCarousel reloadData];
}
-(IBAction)photoFromAlbum:(id)sender{

        
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:NULL];
    
}
-(IBAction)photoFromCamera:(id)sender{

    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:photoPicker animated:YES completion:NULL];
    
}

- (void)imagePickerController:(UIImagePickerController *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.saveButton.enabled = YES;
    self.filterButton.enabled = YES;
    [displayImages addObject:[info valueForKey:UIImagePickerControllerOriginalImage]];
    [self.photoCarousel reloadData];
    [photoPicker dismissViewControllerAnimated:YES completion:NULL];
}
-(IBAction)saveImageToAlbum:(id)sender{
    
    if ([displayImages count]<1) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waring"
                                                        message:@"No Image to save"
                                                       delegate:self
                                              cancelButtonTitle:@"Okay"
                                              otherButtonTitles:nil];
        [alert show];
        self.saveButton.enabled=NO;
        self.filterButton.enabled=NO;
        
    }
    else{

         UIImage *selectedImage = [displayImages objectAtIndex:self.photoCarousel.currentItemIndex];
         UIImageWriteToSavedPhotosAlbum(selectedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *alertTitle;
    NSString *alertMessage;
    if(!error)
    {
        alertTitle   = @"Image Saved";
        alertMessage = @"Image saved to photo album successfully.";
    }
    else
    {
        alertTitle   = @"Error";
        alertMessage = @"Unable to save to photo album.";
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushAECamera"])
    {
        // Set the delegate so this controller can received snapped photos
        AECameraViewController *cameraViewController = (AECameraViewController *) segue.destinationViewController;
        cameraViewController.delegate = self;
    }
}
#pragma mark -
#pragma mark MTCameraViewController
// This delegate method is called after our custom camera class takes a photo
- (void)didSelectStillImage:(NSData *)imageData withError:(NSError *)error
{
    if(!error)
    {
        UIImage *image = [[UIImage alloc] initWithData:imageData];
        [displayImages addObject:image];
        [self.photoCarousel reloadData];
        self.filterButton.enabled = YES;
        self.saveButton.enabled = YES;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Capture Error" message:@"Unable to capture photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}
/*
- (IBAction)pickImage:(id)sender {
    if ([sender tag]==1) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Camera" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    else{
    
        UIImagePickerController *picker=[[UIImagePickerController alloc] init];
        picker.delegate=self;
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        
        self.popController=[[UIPopoverController alloc] initWithContentViewController:picker];
        self.popController.delegate=self;
        CGRect frame=CGRectMake(618, 263, 200, 200);
        [self.popController presentPopoverFromRect:frame inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    [self.popController dismissPopoverAnimated:YES];
    
    [self performSegueWithIdentifier:@"editPage" sender:image];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

 if ([segue.identifier isEqualToString:@"editPage"]){
  
       AEEditViewController *vc=segue.destinationViewController;
       [vc setHoldImage:(UIImage *)sender];
    }
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
