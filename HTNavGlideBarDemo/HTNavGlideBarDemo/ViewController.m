//
//  ViewController.m
//  HTNavGlideBarDemo
//
//  Created by Horae.tech on 16/1/28.
//  Copyright © 2016年 horae. All rights reserved.
//

#import "ViewController.h"

@interface ViewController()
@property (weak, nonatomic) IBOutlet HTNavGlideBar *navGlideBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navGlideBar.itemTitles = @[@"早餐",@"早茶",@"午餐",@"下午茶",@"晚餐",@"夜宵"];
    self.navGlideBar.itemHints =@[@"AM 8:00",@"AM 10:00",@"AM 12:00",@"PM 2:00",@"PM 5:00",@"PM 8:00"];
    self.navGlideBar.arrowImage = [UIImage imageNamed:@"right_button"];
    self.navGlideBar.delegate = self;
    [self.navGlideBar updateData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - HTNavGlideBarDelegate methods
- (void)itemDidSelectedWithIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}


@end
