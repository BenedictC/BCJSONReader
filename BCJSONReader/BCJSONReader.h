//
//  BCJSONReader.h
//  BCJSONReader
//
//  Created by Benedict Cohen on 20/11/2014.
//  Copyright (c) 2014 Benedict Cohen. All rights reserved.
//

#import "BCJConstants.h"
#import "BCJDefines.h"



#pragma mark - Reading options
/**
 Options to modifiy the behaviour of the JSONPath reading methods. It is reccommend that these values are not used directly. Instead use a BCJSONReaderMode value which are pre-defined combinations of BCJSONReaderOptions.
 */
typedef NS_OPTIONS(NSUInteger, BCJSONReaderOptions){
    /**
     If the JSONPath evaluates to nil then the source will return BCJSONReaderResultFailure instead of BCJSONReaderResultValueNotFound.
     */
     BCJSONReaderOptionPathMustEvaluateToValue     = (1UL << 0),

    /**
     If the JSONPath evaluates to NSNull then this will be replaced with nil.
     */
     BCJSONReaderOptionReplaceNullWithNil          = (1UL << 1),
};



#pragma mark - Reading modes (i.e. predefined reading options)
/**
  BCJSONReaderMode are pre-defined combinations of BCJSONReaderOptions which describe common behaviours.
 */
typedef BCJSONReaderOptions BCJSONReaderMode;

/**
 The method will return defaultValue if JSONPath evaluates to nil.
 */
const static BCJSONReaderMode BCJSONReaderModeOptional = BCJNoOptions;
/**
 The method will return defaultValue if JSONPath evaluates to NSNull or nil.
 */
const static BCJSONReaderMode BCJSONReaderModeOptionalNullable = BCJSONReaderOptionReplaceNullWithNil;
/**
 The method will return nil and report an error if JSONPath evaluates to nil.
 */
const static BCJSONReaderMode BCJSONReaderModeRequired = BCJSONReaderOptionPathMustEvaluateToValue;
/**
 The method will return nil and report an error if JSONPath evaluates to nil. If JSONPath evaluates to NSNull then it will return defaultValue which maybe nil.
 */
const static BCJSONReaderMode BCJSONReaderModeRequiredNullable = BCJSONReaderOptionPathMustEvaluateToValue | BCJSONReaderOptionReplaceNullWithNil;



/**
 
 BCJSONReader provides an API for query a JSON object graph. BCJSONReader provides type checking and error reporting thus making extracting values from the object graphs safer.
 
 The recommend usage of BCJSONReader is to call the readJSON... class methods, for example:
 
 NSError *mappingError = [BCJSONReader readJSONData:jsonData defaultOptions:BCJSONReaderModeOptional usingBlock:(BCJSONReader *reader) {
    NSString *title = [reader stringAt:@"title"];
    NSString *name = [reader stringAt:@"author.name"];
    NSDate *publishedDate = [reader dateFromTimeIntervalSince1970At:@"publishedAt"];
 }];
 
 Values are extracted by calling the query methods on an BCJSONReader instance. The query methods come in 2 forms, short form, eg stringAt: and long form stringAt:options:defaultValue:outError:.
 
 The first parameter is a require JSONPath that is used to locate the object. Example JSONPaths are:
 - @"events"
 - @"events[0]"
 - @"events[0].date"
 - @"['events'][0]['date']"
 - @"['latest events']"
 - @"[.]"
 
 The second parameter takes options which affect the behaviour of the method. There are options which affect how NSNull is handled and options which for affect how a method behaves if the value is not found. When using the short form self.defaultOptions are used.
 
 The third parameter is the defaultValue to use. This value is used if the path evaluates to nil. defaultValue may be nil.
 
 The forth parameter is didSucceed. If the query fails then didSucceed will be set to NO, otherwise YES. This parameter can be NULL. A failed method will add exactly 1 error to the readers error array.

 */
@interface BCJSONReader : NSObject

#pragma mark - factory
+(NSError *)readJSONData:(NSData *)jsonData defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block BCJ_REQUIRED(1,3);
+(NSError *)readJSONObject:(id)jsonObject   defaultOptions:(BCJSONReaderOptions)defaultOptions usingBlock:(void(^)(BCJSONReader *reader))block BCJ_REQUIRED(1,3);

#pragma mark - instance life cycle
-(instancetype)initWithJSONObject:(id)jsonObject defaultOptions:(BCJSONReaderOptions)defaultOptions BCJ_DESIGNATED_INIT BCJ_REQUIRED(1);
@property(nonatomic, readonly) id jsonObject;
@property(nonatomic, readonly) BCJSONReaderOptions defaultOptions;

#pragma mark - errors
-(void)addError:(NSError *)error BCJ_REQUIRED();
-(BOOL)hasErrors;
-(void)resetErrors;
@property(nonatomic, readonly) NSArray *errors;

#pragma mark - JSON path access
-(id)objectAt:(NSString *)jsonPath type:(Class)expectedClass BCJ_REQUIRED(1);
-(id)objectAt:(NSString *)jsonPath type:(Class)expectedClass options:(BCJSONReaderOptions)options defaultValue:(id)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end



@interface BCJSONReader (StandardTypeQueries)

-(NSString *)stringAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSString *)stringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSString *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSNull *)nullAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSNull *)nullAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSArray *)arrayAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSArray *)arrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSArray *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSDictionary *)dictionaryAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSDictionary *)dictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDictionary *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSNumber *)numberAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSNumber *)numberAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSNumber *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(BOOL)boolAt:(NSString *)jsonPath BCJ_REQUIRED();
-(BOOL)boolAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(BOOL)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(int64_t)integerAt:(NSString *)jsonPath BCJ_REQUIRED();
-(int64_t)integerAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(int64_t)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(double)doubleAt:(NSString *)jsonPath BCJ_REQUIRED();
-(double)doubleAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(double)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end



@interface BCJSONReader (AdditionalTypeQueries)

-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath BCJ_REQUIRED();
-(NSDate *)dateFromTimeIntervalSince1970At:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSDate *)dateFromISO8601StringAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSDate *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

-(NSURL *)URLAt:(NSString *)jsonPath BCJ_REQUIRED();
-(NSURL *)URLAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options defaultValue:(NSURL *)defaultValue didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1);

@end



@interface BCJSONReader (Collections)

-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping BCJ_REQUIRED();
-(id)enumAt:(NSString *)jsonPath enumMapping:(NSDictionary *)enumMapping options:(BCJSONReaderOptions)options defaultKey:(id)defaultKey didSucceed:(BOOL *)didSucceed BCJ_REQUIRED(1,2);

-(NSArray *)arrayFromArrayAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, NSUInteger elementIndex))block BCJ_REQUIRED(1,4);
-(NSArray *)arrayFromDictionaryAt:(NSString *)jsonPath options:(BCJSONReaderOptions)options didSucceed:(BOOL *)didSucceed usingElementReaderBlock:(id(^)(BCJSONReader *elementReader, id elementKey))block BCJ_REQUIRED(1,4);

@end



@interface BCJSONReader (Validation)

-(NSError *)assertObject:(id)object isKindOfClass:(Class)class BCJ_REQUIRED();
-(NSError *)assertPredicate:(NSPredicate *)predicate BCJ_REQUIRED();
-(NSError *)assertPredicateWithFormat:(NSString *)predicateFormat, ...  BCJ_PRINTF_FORMAT_STYLE(1,2) BCJ_REQUIRED(1);

@end
