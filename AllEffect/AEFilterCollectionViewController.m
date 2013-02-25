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

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@interface AEFilterCollectionViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{

    GPUImageStillCamera *stillCamera;
    GPUImageFilter *tempFilter;
    AEDataClass *data;
}

@property (strong, nonatomic) NSMutableArray *filterScenes;
@end

@implementation AEFilterCollectionViewController
@synthesize filterScenes;

- (void)customSetup
{
    
    filterScenes = [[NSMutableArray alloc] init];
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageFilter alloc] init] withName:@"Original"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageGrayscaleFilter alloc] init] withName:@"Gray Scale"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageSepiaFilter alloc] init] withName:@"Sepia"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageSketchFilter alloc] init] withName:@"Sketch"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImagePixellateFilter alloc] init] withName:@"Pixellate"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageColorInvertFilter alloc] init] withName:@"Color Invert"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImageToonFilter alloc] init] withName:@"Toon"]];
    
    [filterScenes addObject:[AEDataClass liveFilter:[[GPUImagePinchDistortionFilter alloc] init] withName:@"Distort"]];
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self performSelectorOnMainThread:@selector(customSetup) withObject:nil waitUntilDone:YES];
}
-(void)viewWillAppear:(BOOL)animated{

    [self.collectionView reloadData];
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
    return [filterScenes count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AEFilterCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MyCell"
                                    forIndexPath:indexPath];
    
    
    [myCell setBackgroundColor:[UIColor whiteColor]];
    
    dispatch_async(kBgQueue, ^{
        
        data=(AEDataClass *)[filterScenes objectAtIndex:indexPath.row];
    
        stillCamera=[[GPUImageStillCamera alloc] init];
        stillCamera.outputImageOrientation=UIInterfaceOrientationPortrait;
        tempFilter=[data filter];
        [stillCamera addTarget:tempFilter];
        
        GPUImageView *filterView = (GPUImageView *)myCell.filterView;
        [tempFilter addTarget:filterView];
        [stillCamera startCameraCapture];
        
        //NSString *name=[filterScenes objectAtIndex:indexPath.row];
        [[myCell filterLabel] setText:[data filterName]];
        NSLog(@"filter name--%@",[data filterName]);
        
    });
     
    
    return myCell;
}
#pragma mark – UICollectionViewDelegateFlowLayout

// 1
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize=CGSizeMake(123, 147);
    
    return cellSize;
}

// 3
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50, 20, 50, 20);
    
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // TODO: Select Item
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (IBAction)dismissCollectionView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
