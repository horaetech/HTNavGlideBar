# HTNavGlideBar
HTNavGlideBar is a simple and beautiful navigation bar with hint written in object-c.
# Example
 ![image](https://github.com/horaetech/HTNavGlideBar/blob/master/HTNavGlideBar.gif)
# Configuration
HTNavGlideBar has simple configuration system.
You need to create HTNavGlideBar object, set params:

>    self.navGlideBar.itemTitles = @[@"早餐",@"早茶",@"午餐",@"下午茶",@"晚餐",@"夜宵"];
>
>    self.navGlideBar.itemHints =@[@"AM 8:00",@"AM 10:00",@"AM 12:00",@"PM 2:00",@"PM 5:00",@"PM 8:00"];
>
>    self.navGlideBar.arrowImage = [UIImage imageNamed:@"right_button"];
>
>    self.navGlideBar.delegate = self;
>
>    [self.navGlideBar updateData];
