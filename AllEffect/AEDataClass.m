//
//  AEDataClass.m
//  AllEffect
//
//  Created by Sandeep Nasa on 2/22/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import "AEDataClass.h"


@implementation AEDataClass
@synthesize filter;
@synthesize filterName;

+(id)liveFilter:(GPUImageFilter *)filter withName:(NSString *)filterName{

    AEDataClass *newData=[[self alloc] init];
    newData.filter=filter;
    newData.filterName=filterName;
    return newData;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:filter forKey:@"value1"];
    [aCoder encodeObject:filterName forKey:@"value2"];
    
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self.filter=[aDecoder decodeObjectForKey:@"value1"];
    self.filterName=[aDecoder decodeObjectForKey:@"value2"];
    return self;
}


@end
