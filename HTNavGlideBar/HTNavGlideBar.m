//
//  HTNavGlideBar.m
//  HTNavGlideBarDemo
//
//  Created by Horae.tech on 16/1/28.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "HTNavGlideBar.h"

#define UIColorWithRGBA(r,g,b,a)        [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define BAR_WIDTH        (self.frame.size.width)
#define BAR_HEIGHT       (self.frame.size.height)
#define ARROW_BUTTON_WIDTH  20.0f
#define DOT_COORDINATE      0.0f

@interface HTNavHintLayer : UIView{
    UILabel *_hintLbl;
}
@end

@implementation HTNavHintLayer

-(id) initWithHint:(NSString *)hint {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.frame = CGRectMake(10, -40, 100, 35);
    UIImageView * bkImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
    bkImgView.image = [UIImage imageNamed:@"time_pop"];
    bkImgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:bkImgView];
    
    _hintLbl = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 20)];
    [_hintLbl setTextColor:UIColorWithRGBA(14.0f, 147.0f, 95.0f, 1.0f)];
    _hintLbl.text = hint;
    
    [self addSubview:_hintLbl];
    
    return self;
}
- (void)setHint:(NSString *)hint{
    _hintLbl.text = hint;
}

@end

@interface HTNavGlideBar () <HTNavGlideBarDelegate,UIScrollViewDelegate>
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view
    UIImageView     *_arrowButton;          // arrow button
    UIView          *_line;                 // underscore show which item selected
    
    NSInteger       _offsetIndex;           //
    NSMutableArray  *_items;                // HITNavGlideBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    BOOL            _showArrowButton;       // is showed arrow button
    
    HTNavHintLayer *_hintView;
    CGRect _hintViewFrame;
}

@end

@implementation HTNavGlideBar

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _showArrowButton = YES;
        [self initConfig];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showArrowButton = YES;
        [self initConfig];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showArrowButton = show;
        [self initConfig];
    }
    return self;
}

#pragma mark -
#pragma mark - Private Methods

- (void)initConfig
{
    _items = [@[] mutableCopy];
    
    [self viewConfig];
    [self addTapGestureRecognizer];
}

- (void)viewConfig
{
    CGFloat functionButtonX = _showArrowButton ? (BAR_WIDTH - ARROW_BUTTON_WIDTH) : BAR_WIDTH;
    if (_showArrowButton)
    {
        _arrowButton = [[UIImageView alloc] initWithFrame:CGRectMake(functionButtonX, DOT_COORDINATE, ARROW_BUTTON_WIDTH, BAR_HEIGHT)];
        _arrowButton.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _arrowButton.image = _arrowImage;
        _arrowButton.userInteractionEnabled = YES;
        [self addSubview:_arrowButton];
        [self viewShowShadow:_arrowButton shadowRadius:1.0f shadowOpacity:0.0f];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
        [_arrowButton addGestureRecognizer:tapGestureRecognizer];
    }
    
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, functionButtonX, BAR_HEIGHT)];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    _navgationTabBar.delegate = self;
    [self addSubview:_navgationTabBar];
    
    _hintViewFrame = _hintView.frame;
    _hintView = [[HTNavHintLayer alloc]initWithHint:@""];
    [self addSubview:_hintView];
    
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

- (void)addTapGestureRecognizer
{
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(functionButtonPressed)];
    [_arrowButton addGestureRecognizer:tapGestureRecognizer];
}

- (void)itemPressed:(UIButton *)button
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelegate:self];
    
    NSInteger index = [_items indexOfObject:button];
    CGRect hintFrame = _hintView.frame;
    hintFrame.origin.x = button.frame.origin.x -_navgationTabBar.contentOffset.x +10 ;
    _hintView.frame = hintFrame;
    [_hintView setHint:_itemHints[index]];
    _hintViewFrame = _hintView.frame;
    _hintViewFrame.origin.x = button.frame.origin.x +10;
    [UIView commitAnimations];
    
    for (int i = 0; i<[_items count]; i++) {
        UIButton *btn = (UIButton *)_items[i];
        btn.selected = NO;
    }
    button.selected = YES;
    [_delegate itemDidSelectedWithIndex:index];
}

- (void)functionButtonPressed
{
    NSInteger offset =_navgationTabBar.contentOffset.x+40;
    NSInteger width =_navgationTabBar.contentSize.width + 40 - BAR_WIDTH;
    if (offset>width) {
        offset =0;
    }
    [_navgationTabBar setContentOffset:CGPointMake(offset,0) animated:YES];
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    
    CGFloat avgWidth = self.frame.size.width/[titles count];
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:[UIFont systemFontSize]]}];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        if ([titles count] > 4) {
            [widths addObject:width];
        }else{
            [widths addObject:[NSNumber numberWithFloat:avgWidth]];
        }
    }
    
    return widths;
}

- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = DOT_COORDINATE;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (index ==0) {
            button.selected =YES;
        }
        
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, [widths[index] floatValue], BAR_HEIGHT-6);
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:UIColorWithRGBA(14.0f, 147.0f, 95.0f, 1.0f) forState:UIControlStateSelected];
        
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        
        [_items addObject:button];
        
        buttonX += [widths[index] floatValue];
        
        if (index < [_itemTitles count]-1) {
            UIView *spliterLine= [[UIView alloc] initWithFrame:CGRectMake(buttonX, 0, 1,BAR_HEIGHT)];
            spliterLine.backgroundColor = UIColorWithRGBA(204.0f, 204.0f, 204.0f, 0.7f);
            [_navgationTabBar addSubview:spliterLine];
        }
    }
    return buttonX;
}

- (void)showLineWithButton:(CGRect)rect{
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x,rect.origin.y+rect.size.height+5.0f, rect.size.width, 1.0f)];
    bottomLine.backgroundColor = UIColorWithRGBA(204.0f, 204.0f, 204.0f, 0.7f);
    
    UIView *topLine= [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y+1.0f, rect.size.width, 1.0f)];
    topLine.backgroundColor = UIColorWithRGBA(204.0f, 204.0f, 204.0f, 0.7f);
    
    [_navgationTabBar addSubview:bottomLine];
    [_navgationTabBar addSubview:topLine];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGRect hintFrame = _hintView.frame;
    hintFrame.origin.x =_hintViewFrame.origin.x- scrollView.contentOffset.x ;
    _hintView.frame = hintFrame;
}

#pragma mark -
#pragma mark - Public Methods

- (void)updateData
{
    _arrowButton.backgroundColor = self.backgroundColor;
    _arrowButton.image = _arrowImage;
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    [_hintView setHint:_itemHints[0]];
    
    if (_itemsWidth.count)
    {
        CGFloat contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
}

#pragma mark - SCFunctionView Delegate Methods
#pragma mark -
- (void)itemPressedWithIndex:(NSInteger)index
{
    [self functionButtonPressed];
    [_delegate itemDidSelectedWithIndex:index];
}



@end
