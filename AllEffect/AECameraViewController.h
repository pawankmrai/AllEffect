//
//  AECameraViewController.h
//  AllEffect
//
//  Created by Sandeep Nasa on 2/21/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AECameraViewControllerDelegate
- (void)didSelectStillImage:(NSData *)image withError:(NSError *)error;
@end

@interface AECameraViewController : UIViewController

@property(weak, nonatomic) id delegate;
@end
