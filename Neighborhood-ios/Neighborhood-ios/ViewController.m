//
//  ViewController.m
//  Neighborhood-ios
//
//  Created by Danil Tulin on 8/24/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import "ViewController.h"
#import "UIDiagramView.h"

#import <Parse/Parse.h>

@interface ViewController () <UIDiagramViewDataSource, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIDiagramView *diagramView;

@property (nonatomic, strong) UIBarButtonItem *refreshBarButtonItem;

@property (nonatomic) CGFloat previousScrollViewYOffset;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"neighborhood";
    label.font = [UIFont fontWithName:@"SwistblnkMonthoers" size:32.0f];
    label.adjustsFontSizeToFitWidth = YES;
    [label sizeToFit];
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName:family])
        {
            NSLog(@"  %@", name);
        }
    }
    
    self.navigationItem.titleView = label;
//    self.navigationItem.rightBarButtonItem = self.refreshBarButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.delegate = self;
    
    self.scrollView.contentSize = CGSizeMake(320, 1000);
    self.scrollView.frame = self.view.bounds;
    
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        
//        [Parse setApplicationId:@"VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU" clientKey:@"XCPG2OTVrapoymNGS5XGQIhsRM3F2tnVUgaceyec"];
//        
//        while (1)
//        {
//            sleep(1);
//            PFQuery *query = [PFQuery queryWithClassName:@"Temperature"];
//            [query orderByDescending:@"createdAt"];
//            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
//                if (error)
//                {
//                    NSLog(@"%@", [error description]);
//                    return;
//                }
//            }];
//        }
    });
}

- (void)loadView
{
    [super loadView];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

#pragma mark - scrollView

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.frame = self.view.bounds;
        _scrollView.contentSize = self.view.bounds.size;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.showsVerticalScrollIndicator = YES;
        
        [_scrollView addSubview:self.diagramView];
        
    }
    return _scrollView;
}

#pragma mark - diagramView

- (UIDiagramView *)diagramView
{
    if (!_diagramView)
    {
        float offset = 4.0f;
        float height = 185.0f;
        
        _diagramView = [UIDiagramView diagramViewWithFrame:CGRectMake(offset, offset, CGRectGetWidth(self.view.frame) - 2*offset, height) title:@"Temperature"];
    }
    return _diagramView;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect navigationBarFrame = self.navigationController.navigationBar.frame;
    CGFloat navigationBarContentHeight = CGRectGetHeight(navigationBarFrame) - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    CGFloat framePercentageHidden = ((CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) - navigationBarFrame.origin.y) / CGRectGetHeight(navigationBarFrame));
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollDiff = scrollOffset - self.previousScrollViewYOffset;
    
    if (scrollOffset <= -scrollView.contentInset.top)
    {
        navigationBarFrame.origin.y = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    }
    else if ((scrollOffset + CGRectGetHeight(scrollView.frame)) >= scrollView.contentSize.height + scrollView.contentInset.bottom)
    {
        navigationBarFrame.origin.y = -navigationBarContentHeight;
    }
    else
    {
        navigationBarFrame.origin.y = MIN(CGRectGetHeight([UIApplication sharedApplication].statusBarFrame), MAX(-navigationBarContentHeight, navigationBarFrame.origin.y - scrollDiff));
    }
    
    self.navigationController.navigationBar.frame = navigationBarFrame;
    
    [self updateBarButtonItems:(1 - framePercentageHidden)];
    self.previousScrollViewYOffset = scrollOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self stoppedScrolling];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self stoppedScrolling];
    }
}

- (void)stoppedScrolling
{
    CGRect frame = self.navigationController.navigationBar.frame;
    if (frame.origin.y < CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)) {
        [self animateNavBarTo:-(frame.size.height - CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))];
    }
}

- (void)updateBarButtonItems:(CGFloat)alpha
{
    [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem* item, NSUInteger i, BOOL *stop) {
        item.customView.alpha = alpha;
    }];
    
    self.navigationController.navigationBar.tintColor = [self.navigationController.navigationBar.tintColor colorWithAlphaComponent:alpha];
}

- (void)animateNavBarTo:(CGFloat)y
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.navigationController.navigationBar.frame;
        CGFloat alpha = (frame.origin.y >= y ? 0 : 1);
        frame.origin.y = y;
        [self.navigationController.navigationBar setFrame:frame];
        [self updateBarButtonItems:alpha];
    }];
}

#pragma mark - RefreshBarButtonItem

- (UIBarButtonItem *)refreshBarButtonItem
{
    if (!_refreshBarButtonItem)
    {
        _refreshBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(didTapRefreshBarButtonItem:)];
        _refreshBarButtonItem.tintColor = [UIColor blackColor];
    }
    return _refreshBarButtonItem;
}

- (void)didTapRefreshBarButtonItem:(id)sender
{
    [self.diagramView reload];
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
