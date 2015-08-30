//
//  iHStretchableView.h
//  iHakulaImageView
//
//  Created by Wei Wayde Sun on 8/30/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface iHStretchableView : NSObject

@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view;
- (void)scrollViewDidScroll:(UIScrollView*)scrollView;
- (void)resizeView;

@end
