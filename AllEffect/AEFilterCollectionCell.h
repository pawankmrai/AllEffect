//
//  AEFilterCollectionCell.h
//  AllEffect
//
//  Created by Sandeep Nasa on 2/22/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GPUImage.h"

@interface AEFilterCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *filterLabel;
@property (strong, nonatomic) IBOutlet GPUImageView *filterView;
@end
