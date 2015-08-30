//
//  UIDiagramViewController.h
//  DiagramView
//
//  Created by Danil Tulin on 8/25/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIDiagramViewDataSource;
@interface UIDiagramView : UIView

@property (nonatomic, weak) id <UIDiagramViewDataSource> dataSource;

@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
+ (instancetype)diagramViewWithFrame:(CGRect)frame title:(NSString *)title;

- (void)reload;

@end

@protocol UIDiagramViewDataSource <NSObject>

@required

- (NSInteger)numberOfPointsInDiagramView:(UIDiagramView *)diagramView;
- (CGFloat)diagramView:(UIDiagramView *)diagramView valueForPointAtIndex:(NSInteger)index;

@end
