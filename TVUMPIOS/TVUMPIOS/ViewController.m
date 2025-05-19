//
//  ViewController.m
//  TVUMPIOS
//
//  Created by erfeixia on 2025/3/13.
//

#import "ViewController.h"
#import "TVUMPView.h"
#import "HTStack.h"
#import <sys/types.h>
#import <arpa/inet.h>
#import <netdb.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TVUMPView *view = [[TVUMPView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    HStack(@[view])
        .padding(10)
        .bind(self.view);
    
    int i=0;
    while (i>254) {
        i++;
        NSString *address = [NSString stringWithFormat:@"192.168.1.%d",i];
        struct hostent *he;
        struct in_addr ipv4addr;
        
        inet_pton(AF_INET, [address UTF8String], &ipv4addr);
        he = gethostbyaddr(&ipv4addr, sizeof ipv4addr, AF_INET);
        if (he) {
            printf("Host name: %s\n", he->h_name);
            NSLog(@"%@",address);
            //    NSLog(@"%@",address);
        }
    }
}


@end
