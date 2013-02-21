//
//  AEEditViewController.h
//  AllEffect
//
//  Created by Sandeep Nasa on 2/18/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface AEEditViewController : UIViewController

@property (strong, nonatomic) UIImage *holdImage;
@property (strong, nonatomic) IBOutlet UIImageView *holdImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *effectScrollView;
@end
