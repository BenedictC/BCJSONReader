//
//  BCJEnumerateJSONPathComponents.m
//  BCJJSONContinuations
//
//  Created by Benedict Cohen on 05/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJError.h"



static inline BOOL scanSubscriptComponent(NSScanner *scanner, id *outComponent) {

    id subscript = nil;
    BOOL isSubscript = [scanner scanString:@"[" intoString:NULL];
    if (!isSubscript) return NO;

    unsigned long long idx = 0;
    BOOL didScanIntegerSubscript = [scanner scanUnsignedLongLong:&idx];
    if (didScanIntegerSubscript) {
        subscript = @(idx);
    }

    BOOL shouldScanForStringSubscript = (subscript == nil);
    BOOL didScanStringSubscriptOpening = shouldScanForStringSubscript && [scanner scanString:@"'" intoString:NULL];
    if (didScanStringSubscriptOpening) {

        static NSCharacterSet *delimiters = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            delimiters = [NSCharacterSet characterSetWithCharactersInString:@"`'"];
        });

        NSMutableString *stringSubscript = [NSMutableString new];
        NSString *fragment = nil;
        //The scan will fail if the string starts with a backtick or is the closing ' (the empty string is a valid key).
        BOOL isFirstScan = YES;
        while ([scanner scanUpToCharactersFromSet:delimiters intoString:&fragment] || isFirstScan) {
            isFirstScan = NO;

            if (fragment != nil) [stringSubscript appendString:fragment];

            BOOL isAtEndOfSubscript = [scanner scanString:@"'" intoString:NULL];
            if (isAtEndOfSubscript) {
                subscript = stringSubscript;
                break;
            }

            //Scan the backtick escape
            [scanner scanString:@"`" intoString:NULL]; //If this fails then that would mean something very strange as happend.

            //Append the escaped character
            if ([scanner scanString:@"'" intoString:NULL]) {
                [stringSubscript appendString:@"'"];
                continue;
            }
            if ([scanner scanString:@"`" intoString:NULL]) {
                [stringSubscript appendString:@"`"];
                continue;
            }

            //Escaped character is invalid.
            return NO;
        }
    }

    BOOL didCloseSubscript = [scanner scanString:@"]" intoString:NULL];
    if (!didCloseSubscript) return NO;

    //If there's another path component, thus meaning there're at least 2 more characters ("[SUBSCRIPT" or .indentifer),
    BOOL hasAtLeast1MoreComponent = (scanner.scanLocation < scanner.string.length - 1);
    //...then consume the optional trailing dot providing it's not followed by a '[' so that the remaining string is a valid path.
    if (hasAtLeast1MoreComponent) {
        NSUInteger dotLocation = scanner.scanLocation;
        if ([scanner scanString:@"." intoString:NULL] && [scanner scanString:@"[" intoString:NULL]) {
            //That's an invalid sequence! Reset the scanLocation.
            scanner.scanLocation = dotLocation;
        }
    }

    *outComponent = subscript;
    return YES;
}



static inline BOOL scanIdentifierComponent(NSScanner *scanner, id *outComponent) {
    //Technically there are a lot more unicode code points that are acceptable, but we go for 99+% of JSON keys.
    //See on https://mathiasbynens.be/notes/javascript-properties.
    static NSCharacterSet *headCharacters = nil;
    static NSCharacterSet *bodyCharacters = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        headCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ$_"];
        bodyCharacters = ({
            NSMutableCharacterSet *mutableCharacterSet = [NSMutableCharacterSet characterSetWithCharactersInString:@"0123456789"];
            [mutableCharacterSet formUnionWithCharacterSet:headCharacters];
            mutableCharacterSet;
        });
    });

    NSMutableString *identifier = [NSMutableString new];
    NSString *fragment = nil;
    if (![scanner scanCharactersFromSet:headCharacters intoString:&fragment]) {
        return NO;
    }

    [identifier appendString:fragment];

    if ([scanner scanCharactersFromSet:bodyCharacters intoString:&fragment]) {
        [identifier appendString:fragment];
    }

    //If there's another component, i.e. there're at least 2 more characters ("[SUBSCRIPT" or .indentifer),
    BOOL hasAtLeast1MoreComponent = (scanner.scanLocation < scanner.string.length - 1);
    //...then we must consume the optional trailing '.' but only if it's not followed by a '['
    //so that the remaining string is a valid path.
    if (hasAtLeast1MoreComponent) {
        NSUInteger dotLocation = scanner.scanLocation;
        if ([scanner scanString:@"." intoString:NULL] && [scanner scanString:@"[" intoString:NULL]) {
            //That's an invalid sequence! Reset the scanLocation.
            //But if just the '.' was scanned then that was fine.
            scanner.scanLocation = dotLocation;
        }
    }

    *outComponent = identifier;
    return YES;
}



NSError *BCJEnumerateJSONPathComponents(NSString *JSONPath, void(^enumerator)(id component, NSUInteger componentIdx, BOOL *stop)) {
    NSCParameterAssert(JSONPath);
    NSCParameterAssert(enumerator);

    NSScanner *scanner = [NSScanner scannerWithString:JSONPath];
    scanner.charactersToBeSkipped = nil; //Don't skip whitespace!
    NSUInteger componentIdx = 0;
    do {
        //Attempt to get the next component
        id component = nil;
        BOOL didScanComponent = scanSubscriptComponent(scanner, &component) || scanIdentifierComponent(scanner, &component);
        if (!didScanComponent) {
            return [BCJError invalidJSONPathErrorWithInvalidJSONPath:JSONPath errorPosition:scanner.scanLocation];
        }

        //Call the enumerator
        BOOL stop = NO;
        enumerator(component, componentIdx, &stop);
        if (stop) return nil;

        //Prepare for next loop
        componentIdx++;
    } while (![scanner isAtEnd]);

    //Done without error
    return nil;
}
