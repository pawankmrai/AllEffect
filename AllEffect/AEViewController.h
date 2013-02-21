//
//  AEViewController.h
//  AllEffect
//
//  Created by Sandeep Nasa on 2/18/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "AECameraViewController.h"

@interface AEViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,UIActionSheetDelegate, iCarouselDataSource, iCarouselDelegate, AECameraViewControllerDelegate>


//-(IBAction)pickImage:(id)sender;
@end
