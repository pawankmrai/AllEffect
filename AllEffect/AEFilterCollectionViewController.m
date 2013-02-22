//
//  AEFilterCollectionViewController.m
//  AllEffect
//
//  Created by Sandeep Nasa on 2/22/13.
//  Copyright (c) 2013 Pawan Rai. All rights reserved.
//

#import "AEFilterCollectionViewController.h"
#import "AEFilterCollectionCell.h"
#import "AEDataClass.h"

@interface AEFilterCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{

    GPUImageStillCamera *stillCamera;
    GPUImageFilter *filter;
}

@property (strong, nonatomic) NSMutableArray *filterScenes;
@end

@implementation AEFilterCollectionViewController
@synthesize filterScenes=_filterScenes;

- (void)customSetup
{
    
    //GPUImageFilter *filter1 =[[GPUImageSepiaFilter alloc] init];
    
    _filterScenes = [[NSMutableArray alloc] init];
    [_filterScenes addObject:[AEDataClass liveFilter:[[GPUImageGrayscaleFilter alloc] init] withName:@"Gray Scale"]];
    [_filterScenes addObject:[AEDataClass liveFilter:[[GPUImageSepiaFilter alloc] init] withName:@"Sepia"]];

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return _filterScenes.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AEFilterCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    [[myCell filterName] setText:[_filterScenes objectAtIndex:indexPath.row]];
    filter = [[GPUImageSepiaFilter alloc] init];
    GPUImageView *filterView = (GPUImageView *)myCell.filterView;
    [filter addTarget:filterView];
    [stillCamera addTarget:filter];
    
    return myCell;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
