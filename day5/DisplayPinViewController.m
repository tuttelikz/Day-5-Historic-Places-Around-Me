//
//  DisplayPinViewController.m
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import "DisplayPinViewController.h"
#import <Parse/Parse.h>

@interface DisplayPinViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *starsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (nonatomic) NSMutableArray *comments;

@end

@implementation DisplayPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.comments = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.nameLabel.text = self.place.name;
    self.descriptionLabel.text = self.place.descr;
    self.imageView.image = self.place.picture;

    [self getDataFromParse];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getDataFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Activity"];
//    [query whereKey:@"toPlace" ];
    //[query includeKey:@"toPlace"];
    [query whereKey:@"type" equalTo:@"comment"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSString *comment = object[@"content"];
                NSLog(@"%@",object);
                [self.comments addObject:comment];
                [self.tableView reloadData];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
#pragma mark - Table View methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.comments count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = self.comments[indexPath.row];
    
    return cell;
}

#pragma mark - onClick methods

- (IBAction)oneStar:(UIButton *)sender {
}

- (IBAction)twoStars:(UIButton *)sender {
}

- (IBAction)threeStars:(UIButton *)sender {
}

- (IBAction)commentPressed:(UIButton *)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
