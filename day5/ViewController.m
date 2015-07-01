//
//  ViewController.m
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "HistoricPlace.h"
#import <Parse/Parse.h>
#import "AddPinViewController.h"
#import "DisplayPinViewController.h"

@interface ViewController () <MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,AddPinViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSMutableArray *places;
@property (nonatomic) HistoricPlace *currentPlace;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.places = [NSMutableArray new];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:43.255938 longitude:76.942989];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(initialLocation.coordinate, 1000.0, 1000.0);
    
    [self.mapView setRegion:region];
    self.mapView.delegate = self;
    [self getDataFromParse];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    longPress.minimumPressDuration = 0.5;
    [self.mapView addGestureRecognizer:longPress];
    
    [self showMap];
}

- (void)getDataFromParse
{
    PFQuery *query = [PFQuery queryWithClassName:@"Place"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSString *name = object[@"name"];
                NSString *descr = object[@"description"];
                PFGeoPoint *point = object[@"location"];
                PFFile *picture = object[@"picture"];
                NSString *objectId = object.objectId;
                
                if(!picture){
                    UIImage *image = [UIImage imageNamed:@"no_photo.png"];
                    HistoricPlace *place = [[HistoricPlace alloc] initWithName:name andLocation:CLLocationCoordinate2DMake(point.latitude, point.longitude) andDescription:descr andPicture:image andId:objectId];
                    
                    [self addPlace:place];
                }
                else {
                    [picture getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                        if(!error){
                            UIImage *image = [UIImage imageWithData:data];
                            HistoricPlace *place = [[HistoricPlace alloc] initWithName:name andLocation:CLLocationCoordinate2DMake(point.latitude, point.longitude) andDescription:descr andPicture:image andId:objectId];
                            
                            [self addPlace:place];
                        }
                    }];
                }
                
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Prepare For Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[AddPinViewController class]]){
        AddPinViewController *nextVC = segue.destinationViewController;
        nextVC.place = self.currentPlace;
        nextVC.delegate = self;
    }
    if([segue.destinationViewController isKindOfClass:[DisplayPinViewController class]]){
        DisplayPinViewController *nextVC = segue.destinationViewController;
        nextVC.place = self.currentPlace;
    }
}

#pragma mark - AddPinViewControllerDelegate

-(void)didCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didAdd:(HistoricPlace *)place;
{
    [self savePlace:place];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Long Press Recognizer

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
   
    self.currentPlace = [[HistoricPlace alloc] initWithName:@"Sample name" andLocation:touchMapCoordinate andDescription:@"Sample description" andPicture:[UIImage imageNamed:@"no_photo.png"] andId:nil];
    
    [self performSegueWithIdentifier:@"AddPinSegue" sender:self];
}

#pragma mark - MapView

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"pin"];
    if(!annotationView){
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(-5.0, 5.0);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = button;
        
        UIImageView *imageView;
        HistoricPlace *place = (HistoricPlace *)annotation;
        imageView = [[UIImageView alloc] initWithImage:place.picture];
        imageView.frame = CGRectMake(imageView.frame.origin.x, imageView.frame.origin.y, 32.0, 32.0);
        imageView.contentMode = UIViewContentModeScaleToFill;
        annotationView.leftCalloutAccessoryView = imageView;
    }
    else {
        annotationView.annotation = annotation;
    }
    return annotationView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    HistoricPlace *place = view.annotation;
    [self alertHistoricPlace:place];
}

#pragma mark - TableView delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.places count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    HistoricPlace *place = self.places[indexPath.row];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.descr;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoricPlace *place = self.places[indexPath.row];
    [self alertHistoricPlace:place];
}

#pragma mark - helper methods

-(void)savePlace:(HistoricPlace *)place
{
    PFObject *newPlace = [PFObject objectWithClassName:@"Place"];
    newPlace[@"name"] = place.name;
    newPlace[@"description"] = place.descr;
    newPlace[@"location"] = [PFGeoPoint geoPointWithLatitude:place.coordinate.latitude longitude:place.coordinate.longitude];
    newPlace[@"picture"] = [PFFile fileWithName:@"photo.png" data:UIImagePNGRepresentation(place.picture)];
    [newPlace saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        place.objectId = newPlace.objectId;
        [self addPlace:place];
    }];
}

-(void)addPlace:(HistoricPlace *)place
{
    [self.places addObject:place];
    [self.mapView addAnnotation:place];
    [self.tableView reloadData];
}

-(void)showMap
{
    self.mapView.hidden = NO;
    self.tableView.hidden = YES;
}

-(void)showList
{
    self.mapView.hidden = YES;
    self.tableView.hidden = NO;
}

-(void)alertHistoricPlace: (HistoricPlace *)place
{
    self.currentPlace = place;
    [self performSegueWithIdentifier:@"DisplayPinSegue" sender:self];
}

- (IBAction)segmentControl:(UISegmentedControl *)sender {
    if(self.segmentedControl.selectedSegmentIndex == 0){
        [self showMap];
    }
    if(self.segmentedControl.selectedSegmentIndex == 1){
        [self showList];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
