//
//  ViewController.m
//  知乎日报
//
//  Created by P tYou on 2021/2/21.
//  Copyright © 2021年 P tYou. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *monthlabel;

@property (weak, nonatomic) IBOutlet UILabel *daylabel;
@property (weak, nonatomic) IBOutlet UIScrollView *totalScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic, strong) NSTimer *timer;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UITableView *tabelVIew;
@property (nonatomic, strong) NSArray *stories;


@end

@implementation ViewController


//实现UIScrollView的滚动方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    //offsetX = offsetX + (scrollView.frame.size.width * 5);
    int page = offsetX / scrollView.frame.size.width;
    self.pageControl.currentPage = page;
    
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    self.daylabel.text = dateStr;
    [dateFormat setDateFormat:@"MM"];
    dateStr = [dateFormat stringFromDate:date];
    /*if (dateStr>@"2") {
    self.monthlabel.text = dateStr;
    }*/
    
    self.tabelVIew.rowHeight=100;
    //确定请求路径
    NSURL *url = [NSURL URLWithString:@"https://news-at.zhihu.com/api/3/news/latest"];
    //创建请求对象
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    //请求发送
    NSURLResponse *response = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    //解析 data-->string
    
    //NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    //josn-->oc 反序列化
    /*
     参数
     1.JSON的二进制数据
     2.
     3.
     */
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",[dic objectForKey:@"title"]);
    //NSLog(@"%@",response);
    
    self.stories=dic[@"stories"];
    self.tabelVIew.dataSource = self;
    
    
    self.totalScrollView.contentSize = CGSizeMake(414, 1068);
    // 创建UIImageView添加到UIAScrollView
    
    CGFloat imgW = 414;
    CGFloat imgH = 300;
    CGFloat imgY = 0;
    
    //循环创建5个uiimageview添加到scrollview
    for (int i=0; i<5; i++) {
        
        
        UIImageView *imgeView =[[UIImageView alloc] init];

        NSArray *top_stories = dic[@"top_stories"];
        NSDictionary *Item = top_stories[i];
        NSString *imgurl = Item[@"image"];
        
        //设置UIImageView的图片
        NSURL *url1 = [NSURL URLWithString: imgurl];
        NSData *imageData = [NSData dataWithContentsOfURL:url1];
        UIImage *image = [UIImage imageWithData:imageData];
        imgeView.image = image;

        
        
        CGFloat imgX = i*imgW;
        //设置imgView的frame
        imgeView.frame = CGRectMake(imgX, imgY, imgW, imgH);
        
        //把imgView添加到UIScrollView
        [self.scrollView addSubview:imgeView];
        
        UILabel *label = [[UILabel alloc] init];
        NSString *toptitle = Item[@"title"];
        label.text = toptitle;
        label.textColor = [UIColor whiteColor];
        label.frame = CGRectMake(10+imgX, 180, 350, 100);
        label.numberOfLines = 2;
        label.font = [UIFont boldSystemFontOfSize:30];
        [self.scrollView addSubview:label];
        
        UILabel *sublabel = [[UILabel alloc] init];
        NSString *subtitle = Item[@"hint"];
        sublabel.text = subtitle;
        sublabel.textColor = [UIColor whiteColor];
        sublabel.frame = CGRectMake(10+imgX, 250, 350, 50);
        sublabel.numberOfLines = 1;
        sublabel.font = [UIFont systemFontOfSize:10];
        [self.scrollView addSubview:sublabel];
        
    }
    
    //设置UIScrollView的contentSize
    CGFloat maxW = self.scrollView.frame.size.width*5;
    self.scrollView.contentSize = CGSizeMake(maxW, 0);
    
    //实现UIScrollView的分页效果
    self.scrollView.pagingEnabled = YES;
    
    //隐藏
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    self.pageControl.numberOfPages = 5;
    self.pageControl.currentPage = 0;
    
    


    

   
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.stories.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    
    
    NSDictionary *dictM = self.stories[indexPath.row];
    
    cell.textLabel.text = dictM[@"title"];
    
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", dictM[@"hint"]];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    NSArray *diccc = dictM[@"images"];

    
    
    NSURL *url = [NSURL URLWithString:diccc[0]];
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    cell.imageView.image=image;
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyyMMdd"];
    NSString *dateStr = [dateFormat stringFromDate:date];
    if(section == 0) {
        return dateStr;
    }
    return 0;
}





@end
