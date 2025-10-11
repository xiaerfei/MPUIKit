//
//  ViewController.m
//  TVUList
//
//  Created by erfeixia on 2025/8/4.
//

#import "ViewController.h"
#import "TVUPLListView.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self request];
    });
}


- (void)request {
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://mx-service.tvunetworks.com/mx-service/profile/editEncodingProfile"]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    NSDictionary *headers = @{
        @"referer": @"",
        @"Cookie": @"",
        @"User-Agent": @"Apifox/1.0.0 (https://apifox.com)",
        @"Content-Type": @"application/json",
        @"Accept": @"*/*",
        @"Host": @"mx-service.tvunetworks.com",
        @"Connection": @"keep-alive"
    };
    
    [request setAllHTTPHeaderFields:headers];
    NSData *postData = [[NSData alloc] initWithData:[@"{\n    \"profileId\": \"976dbac8e6ba4598a0db223b32511745\",\n    \"profileName\": \"DDD\",\n    \"videoEncoder\": {\n        \"name\": \"video_Default (Duplicate 1)\",\n        \"bitrate\": \"5M\",\n        \"resolution\": \"1920x1080\",\n        \"codec\": \"H.264\",\n        \"cbr\": true,\n        \"deinterlace\": \"true\",\n        \"frameRate\": \"30\",\n        \"gop\": 30,\n        \"scale\": \"fast_bilinear\",\n        \"profile\": \"main\",\n        \"level\": \"3.0\",\n        \"preset\": \"veryfast\",\n        \"tune\": \"none\",\n        \"hdrType\": 0,\n        \"bpp\": 2,\n        \"transpose\": 0,\n        \"id\": \"a55e31e480124787a9ab4d388d90ba4c\",\n        \"aspectRatio\": \"16:9\"\n    },\n    \"audioEncoders\": [\n        {\n            \"name\": \"audio_Default (Duplicate 1)\",\n            \"bitrate\": \"128K\",\n            \"codec\": \"AAC\",\n            \"sampleRate\": 48000,\n            \"id\": \"792878d79ab240178944a4bba1ac30a4\"\n        },\n        {\n            \"name\": \"audio_Default (Duplicate 1)\",\n            \"bitrate\": \"128K\",\n            \"codec\": \"AAC\",\n            \"sampleRate\": 48000,\n            \"id\": \"0c5bfeaeca2643779267195fee0483a7\"\n        }\n    ]\n}" dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:postData];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"323C61D1DFF242B38B0A854212CA1A5D" forHTTPHeaderField:@"SID"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            dispatch_semaphore_signal(sema);
        } else {
            NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            dispatch_semaphore_signal(sema);
        }
    }];
    [dataTask resume];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}


@end
