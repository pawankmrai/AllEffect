//
//  AEDataClass.h
//  AllEffect
//
//  Created by Sandeep Nasa on 2/22/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
@interface AEDataClass : NSObject<NSCoding>
{

     GPUImageFilter *filter;
     NSString *filterName;
}
@property(nonatomic,strong) GPUImageFilter *filter;
@property(nonatomic,strong) NSString *filterName;

+(id)liveFilter:(GPUImageFilter *)filter withName:(NSString *)filterName;
@end
