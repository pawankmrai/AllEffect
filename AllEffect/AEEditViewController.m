//
//  AEEditViewController.m
//  AllEffect
//
//  Created by Sandeep Nasa on 2/18/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import "AEEditViewController.h"

@interface AEEditViewController ()

@end

@implementation AEEditViewController
@synthesize holdImageView, effectScrollView;
@synthesize holdImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //NSLog(@"hold image---%@", holdImage);
    [holdImageView setImage:holdImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
