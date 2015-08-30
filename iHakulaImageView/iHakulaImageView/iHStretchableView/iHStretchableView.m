//
//  iHStretchableView.m
//  iHakulaImageView
//
//  Created by Wei Wayde Sun on 8/30/15.
//  Copyright (c) 2015 ihakula. All rights reserved.
//

#import "iHStretchableView.h"

@interface iHStretchableView()
{
    CGRect initialFrame;
    CGFloat defaultViewHeight;
}
@end

@implementation iHStretchableView

@synthesize tableView = _tableView;
@synthesize view = _view;

- (void)stretchHeaderForTableView:(UITableView*)tableView withView:(UIView*)view
{
    _tableView = tableView;
    _view = view;
    
    initialFrame       = _view.frame;
    defaultViewHeight  = initialFrame.size.height;
    
    UIView* emptyTableHeaderView = [[UIView alloc] initWithFrame:initialFrame];
    _tableView.tableHeaderView = emptyTableHeaderView;
    
    [_tableView addSubview:_view];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    CGRect f = _view.frame;
    f.size.width = _tableView.frame.size.width;
    _view.frame = f;
    
    if(scrollView.contentOffset.y < 0) {
        CGFloat offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1;
        initialFrame.origin.y = offsetY * -1;
        initialFrame.size.height = defaultViewHeight + offsetY;
        _view.frame = initialFrame;
    }
}

- (void)resizeView
{
    initialFrame.size.width = _tableView.frame.size.width;
    _view.frame = initialFrame;
}


@end
