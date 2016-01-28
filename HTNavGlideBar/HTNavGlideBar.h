//
//  HTNavGlideBar.h
//  HTNavGlideBarDemo
//
//  Created by Horae.tech on 16/1/28.
//  Copyright © 2016年 horae. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTNavGlideBarDelegate <NSObject>

@optional
/**
 *  When NavGlideBar Item Is Pressed Call Back
 *
 *  @param index - pressed item's index
 */
- (void)itemDidSelectedWithIndex:(NSInteger)index;

@end
@interface HTNavGlideBar : UIView

@property (nonatomic, weak)     id          <HTNavGlideBarDelegate>delegate;

@property (nonatomic, strong)   NSArray     *itemHints;     // current selected item's index
@property (nonatomic, strong)   NSArray     *itemTitles;    // all items' title
@property (nonatomic, strong)   UIColor     *lineColor;     // set the underscore color
@property (nonatomic, strong)   UIImage     *arrowImage;    // set arrow button's image

/**
 *  Initialize Methods
 *
 *  @param frame - HITNavGlideBar frame
 *  @param show  - is show Arrow Button
 *
 *  @return Instance
 */
- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show;

/**
 *  Update Item Data
 */
- (void)updateData;

@end

