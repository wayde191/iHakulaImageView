//
//  iHPageView.m
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHPageView.h"
#import "iHAdditions.h"
#import "iHCommonMacros.h"

@interface iHPageView() {
    BOOL _isFromCoder;
    CGFloat _padding;
}
- (CGFloat)getPageViewWidth:(int)pageNum;
- (CGFloat)getDotXWithIndex:(int)index;
@end

@implementation iHPageView

@synthesize pageNum = _pageNum;
@synthesize currentPage = _currentPage;

#pragma mark - Private Methods
- (CGFloat)getPageViewWidth:(int)pageNum {
    return pageNum * PAGE_VIEW_DOT_WIDTH + (pageNum - 1) * PAGE_VIEW_SPACE_BETWEEN_DOTS;
}

- (CGFloat)getDotXWithIndex:(int)index {
    CGFloat left = index * (PAGE_VIEW_SPACE_BETWEEN_DOTS + PAGE_VIEW_DOT_WIDTH);
    if (_isFromCoder) {
        left += _padding;
    }
    
    return left;
}

#pragma mark - Public Methods

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.top = 0;
        self.left = 0;
        _isFromCoder = YES;
    }
    return self;
}

- (void)setupPageNumberForCoder:(int)pageNum {
    _currentPage = 0;
    _pageNum = pageNum;
    
    CGFloat realWidth = [self getPageViewWidth:pageNum];
    _padding = (self.width - realWidth) / 2;
    
    for (int i = 0; i < _pageNum; i++) {
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake([self getDotXWithIndex:i], 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
        dotView.image = [UIImage imageNamed:PAGE_VIEW_DOT_IMAGE];
        [self addSubview:dotView];
        RELEASE_SAFELY(dotView);
    }
    
    _selectedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
    _selectedDotView.image = [UIImage imageNamed:PAGE_VIEW_SELECTED_DOT_IMAGE];
    [self addSubview:_selectedDotView];
}

- (id)initWithPageNum:(int)pageNum {
    self = [super initWithFrame:CGRectMake(0, 0, [self getPageViewWidth:pageNum], PAGE_VIEW_DOT_HEIGHT)];
    if (self) {
        _currentPage = 0;
        _pageNum = pageNum;
        
        for (int i = 0; i < _pageNum; i++) {
            UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake([self getDotXWithIndex:i], 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
            dotView.image = [UIImage imageNamed:PAGE_VIEW_DOT_IMAGE];
            [self addSubview:dotView];
            RELEASE_SAFELY(dotView);
        }
        
        _selectedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
        _selectedDotView.image = [UIImage imageNamed:PAGE_VIEW_SELECTED_DOT_IMAGE];
        [self addSubview:_selectedDotView];
        
    }
    return self;
}

- (void)setInitStateFromNib:(int)pageNum {
    _currentPage = 0;
    _pageNum = pageNum;
    
    for (int i = 0; i < _pageNum; i++) {
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake([self getDotXWithIndex:i], 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
        dotView.image = [UIImage imageNamed:PAGE_VIEW_DOT_IMAGE];
        [self addSubview:dotView];
        RELEASE_SAFELY(dotView);
    }
    
    _selectedDotView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, PAGE_VIEW_DOT_WIDTH, PAGE_VIEW_DOT_HEIGHT)];
    _selectedDotView.image = [UIImage imageNamed:PAGE_VIEW_SELECTED_DOT_IMAGE];
    [self addSubview:_selectedDotView];
}

- (void)setCurrentPage:(int)currentPage{
    _currentPage = currentPage;
    _selectedDotView.left = [self getDotXWithIndex:_currentPage];
}

- (void)dealloc{
    RELEASE_SAFELY(_selectedDotView);
}

@end
