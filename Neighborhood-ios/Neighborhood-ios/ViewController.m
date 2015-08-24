//
//  ViewController.m
//  Neighborhood-ios
//
//  Created by Danil Tulin on 8/24/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import "ViewController.h"
#import "UITemperatureView.h"

#import <Parse/Parse.h>

@interface ViewController ()

@property (nonatomic, strong) UITemperatureView *temperatureView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.temperatureView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.temperatureView sizeToFit];
    self.temperatureView.center = CGPointMake(CGRectGetMidX(self.view.frame), CGRectGetMidY(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0), ^{
        
        [Parse setApplicationId:@"VOB4wXj2mGOjJaqzdhkM701n2ahTSRMqZW6QQ8XU" clientKey:@"XCPG2OTVrapoymNGS5XGQIhsRM3F2tnVUgaceyec"];
        
        while (1)
        {
            sleep(1);
            PFQuery *query = [PFQuery queryWithClassName:@"Temperature"];
            [query orderByDescending:@"createdAt"];
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
                [UIView animateWithDuration:.3f animations:^{
                    self.temperatureView.value = [object[@"value"] floatValue];
                }];
            }];
        }
    });
}

#pragma mark - TemperatureView

- (UITemperatureView *)temperatureView
{
    if (!_temperatureView)
    {
        _temperatureView = [[UITemperatureView alloc] init];
    }
    return _temperatureView;
}

#pragma mark - Status Bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

@end
