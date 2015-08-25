//
//  UIDiagramViewController.h
//  DiagramView
//
//  Created by Danil Tulin on 8/25/15.
//  Copyright (c) 2015 Danil Tulin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDiagramView : UIView

@property (nonatomic, strong, readonly) NSString *title;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
+ (instancetype)diagramViewWithFrame:(CGRect)frame title:(NSString *)title;

@end
