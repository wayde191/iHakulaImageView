//
//  iHImageView.m
//  iHakula
//
//  Created by Wayde Sun on 6/28/13.
//  Copyright (c) 2013 iHakula. All rights reserved.
//

#import "iHImageView.h"
#import "iHSingletonCloud.h"
#import "iHCommonMacros.h"
#import "iHCommonFunctions.h"

@interface iHImageView() {
    BOOL _loadingFailedReturned;
}
-(void)showLoading;
-(void)hideLoading;
-(void)handleTapGesture:(UITapGestureRecognizer *)recognizer;
@end

@implementation iHImageView

@synthesize delegate = _delegate;
@synthesize imageUrl = _imageUrl;
@synthesize enableTapEvent = _enableTapEvent;
@synthesize indicatorViewStyle = _indicatorViewStyle;

- (void)dealloc {
    [self cancelImageRequest];
    
    _delegate = nil;
    RELEASE_SAFELY(_indicator);
    RELEASE_SAFELY(_imageUrl);
}

- (id)init{
    self = [super init];
	if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        [self setDefaultImage:ImageNamed(@"empty.png")];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        [self setDefaultImage:ImageNamed(@"empty.png")];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.indicatorViewStyle = UIActivityIndicatorViewStyleGray;
//        [self setDefaultImage:ImageNamed(@"empty.png")];
    }
    return self;
}

- (void)setDefaultImage:(UIImage*)defaultImage {
    if (!_defaultImageView) {
        _defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 125)];
        _defaultImageView.center = CGRectGetCenter(self.bounds);
        _defaultImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    _defaultImageView.image = defaultImage;
}

- (void)cancelImageRequest{
    iHCacheCenter *ccenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    [ccenter cancelLoadingImgByUrlStr:_imageUrl];
    [self hideLoading];
}

- (void)loadImage:(NSString*)url{
    if( url==nil || [url isEqualToString:@""] ){
        return;
    }
	RELEASE_SAFELY(_imageUrl);
    [self cancelImageRequest];
    _imageUrl = url;
    
    _loadingFailedReturned = NO;
    iHCacheCenter *ccenter = [iHSingletonCloud getSharedInstanceByClassNameString:@"iHCacheCenter"];
    UIImage *img = [ccenter getImgFromUrlStr:_imageUrl byDelegate:self];
    if (img) {
        self.image = img;
        [self hideLoading];
    } else {
        BOOL showShowLoading = YES;
        if (self.image) {
            showShowLoading = NO;
        }
        if (showShowLoading) {
            [self showLoading];
        }
    }
    
    if (_enableTapEvent) {
        [self setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    
}

-(void)setIndicatorViewStyle:(UIActivityIndicatorViewStyle)style{
    _indicatorViewStyle = style;
    [_indicator setActivityIndicatorViewStyle:style];
}

-(void)showLoading{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_indicatorViewStyle];
        _indicator.center = CGRectGetCenter(self.bounds);
        [_indicator setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin];
    }
    _indicator.hidden = NO;
    if(!_indicator.superview){
        [self addSubview:_indicator];
    }
    [_indicator startAnimating];
    
    if (_defaultImageView) {
        _defaultImageView.center = CGRectGetCenter(self.bounds);
        [self addSubview:_defaultImageView];
        [self sendSubviewToBack:_defaultImageView];
    }
}
-(void)hideLoading{
    if (_indicator) {
        [_indicator stopAnimating];
        _indicator.hidden = YES;
        [_indicator removeFromSuperview];
    }
    
    if (_defaultImageView && !_loadingFailedReturned) {
        [_defaultImageView removeFromSuperview];
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer{
    if (_delegate && [_delegate respondsToSelector:@selector(imageClicked:)]) {
        [_delegate imageClicked:self];
	}
}

#pragma mark - ITTCacheDelegate
- (void)imgLoaded:(UIImage *)img byUrl:(NSString *)urlStr
{
    if ([urlStr isEqualToString:_imageUrl]) {
        [self performSelectorOnMainThread:@selector(imageLoaded:) withObject:img waitUntilDone:NO];
    }
}

- (void)imgLoadFailedByUrl:(NSString *)urlStr {
    _loadingFailedReturned = YES;
    [self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
    if (_delegate && [_delegate respondsToSelector:@selector(imgLoadFailedByUrl:)]) {
        [_delegate imageLoadFailed:self];
    }
}

#pragma mark - ITTImageDataOperationDelegate
- (void)imageLoaded:(UIImage *)image{
    [self hideLoading];
    self.image = image;
	if (_delegate && [_delegate respondsToSelector:@selector(imageLoaded:)]) {
        [_delegate imageLoaded:self];
	}
}

@end
