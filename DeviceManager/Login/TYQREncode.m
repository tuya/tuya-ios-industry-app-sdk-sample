//
//  TYQREncode.m
//  DeviceManager
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "TYQREncode.h"

@implementation TYQREncode

//+ (NSString *)getNowTimeTimestamp {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
//    return timeSp;
//}

+ (NSString *)stringXOREncryptWithData:(NSString *)data key:(NSString *)key {
    NSData* bytes = [data dataUsingEncoding:NSUTF8StringEncoding];
    Byte  *myByte = (Byte *)[bytes bytes];
    NSData* keyBytes = [key dataUsingEncoding:NSUTF8StringEncoding];
    Byte  *keyByte = (Byte *)[keyBytes bytes];
    
    for (int x = 0; x < [bytes length]; x++) {
        myByte[x]  = myByte[x] ^ keyByte[x % key.length];
    }

    NSData *newData = [[NSData alloc] initWithBytes:myByte length:[bytes length]];
    NSString *aString = [[NSString alloc] initWithData:newData encoding:NSUTF8StringEncoding];

    return aString;
}

+ (NSDictionary *)infoFromEncryptString:(NSString *)string {
    NSString *timeStr = [string componentsSeparatedByString:@"&t="].lastObject;
    NSString *key = [NSString stringWithFormat:@"%@%@", timeStr, @"g7GKjj2Z"];
    
    NSString *c = [[string componentsSeparatedByString:@"c="].lastObject componentsSeparatedByString:@"&t="].firstObject;
    NSData *data = [[NSData alloc] initWithBase64EncodedString:c options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *decodeStr = [TYQREncode stringXOREncryptWithData:dataString key:key];

    NSData *cData = [decodeStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:cData options:NSJSONReadingMutableContainers error:nil];
    return dict;
}



@end
