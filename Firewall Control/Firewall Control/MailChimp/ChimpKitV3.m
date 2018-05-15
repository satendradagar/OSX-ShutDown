//
//  ChimpKitV3.m
//  Candy Apple
//
//  Created by Satendra Singh on 03/12/16.
//
//

#import "ChimpKitV3.h"
#import "NSData+Base64.h"
#import "NSString+MD5.h"

#define PARAMETER_FORMAT_JSON @"{\"id\":\"%@\",\"email_address\":\"%@\",\"status\":\"%@\",\"apikey\":\"%@\",\"merge_vars\":{\"FNAME\":\"%@\",\"LNAME\":\"%@\",\"Serial\":\"%@\"}}"

@implementation ChimpKitV3

@synthesize apiKey = _apiKey;


#pragma mark - Initialization

- (void)setApiKey:(NSString*)key {
    _apiKey = key;
    if (_apiKey) {
            //Parse out the datacenter and template it into the URL.
        NSArray *apiKeyParts = [_apiKey componentsSeparatedByString:@"-"];
        if ([apiKeyParts count] > 1) {
            self.apiUrl = [NSString stringWithFormat:@"http://%@.api.mailchimp.com/3.0/lists/", [apiKeyParts objectAtIndex:1]];
        }
    }
}

- (id)initWithDelegate:(id)aDelegate andApiKey:(NSString *)key {
    self = [super init];
    if (self != nil) {
            //        self.apiUrl  = @"https://api.mailchimp.com/1.3/?method=";
        [self setApiKey:key];
        self.delegate = aDelegate;
        self.responseData = [NSMutableData data];
    }
    return self;
}

#pragma mark - Setup

- (NSMutableData *)encodeRequestParams:(NSDictionary *)params {
    NSMutableDictionary *postBodyParams = [NSMutableDictionary dictionary];
    if (self.apiKey) {
        [postBodyParams setValue:self.apiKey forKey:@"apikey"];
    }
    
    if (params) {
        [postBodyParams setValuesForKeysWithDictionary:params];
    }
    
    NSDictionary *mergeVars = [postBodyParams valueForKey:@"merge_vars"];
//    NSString *outRes =  [NSString stringWithFormat:PARAMETER_FORMAT_JSON,(NSString *)[postBodyParams valueForKey:@"id"], (NSString *)[postBodyParams valueForKey:@"email_address"], (NSString *)[postBodyParams valueForKey:@"status"],(NSString *)[postBodyParams valueForKey:@"apikey"], (NSString *)[mergeVars valueForKey:@"FNAME"], (NSString *)[mergeVars valueForKey:@"LNAME"], (NSString *)[mergeVars valueForKey:@"Serial"]];
//    NSLog(@"outRes = %@",outRes);
//    NSString *encodedParamsAsJson = [self encodeString:outRes];
//    NSMutableData *postData = [NSMutableData dataWithData:[encodedParamsAsJson dataUsingEncoding:NSUTF8StringEncoding]];

    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setValue:[postBodyParams valueForKey:@"email_address"] forKey:@"email_address"];
    [dict setValue:(NSString *)[postBodyParams valueForKey:@"status"] forKey:@"status"];
    [dict setValue:mergeVars forKey:@"merge_fields"];
    NSMutableData *postData = [NSMutableData dataWithData:[NSJSONSerialization dataWithJSONObject:dict options:0 error:nil]];
    return postData;
}

- (void)callApiMethod:(NSString *)method withParams:(NSDictionary *)params {
    [self cancel];
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.apiUrl, method];
    NSString *email = [params valueForKey:@"email_address"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@/members/%@", self.apiUrl, [params objectForKey:@"id"],[email MD5]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"PUT"];
    [request setTimeoutInterval:timeout];
    
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"anystring", self.apiKey];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];//set authorization header
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];//set authorization header

    NSMutableData *postData = [self encodeRequestParams:params];
    [request setHTTPBody:postData];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}


@end
