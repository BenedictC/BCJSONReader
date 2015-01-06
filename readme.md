# BCJSONReader

## TL;DR
 BCJSONReader is a library for processing the crazy JSON structures that exist in the real world. Its key features are:
+ Flexible. Provides functionality for handling many JSON usage styles.
+ Extensible. Easy to integrate new processing (e.g. peculiar date formats).
//+ Documented.
//+ Tested.



### Example

```objc
@interface TestObject : NSObject
@property NSArray *array;
@property NSInteger number;
@property NSString *string;

@property NSDate *date;
@property NSURL *url;
@end

@implementation TestObject
@end



void demo(void) {
    //Input data
    NSDictionary *sourceObject = @{
                                   @"number": @1234,
                                   @"string": @"arf",
                                   @"dict" : @{
                                           @"one": @(1),
                                           @"two": @(2),
                                           @"three": @(3),
                                           @"four": @(4),
                                           @"five": @(5)
                                           },
                                   @"array": @[@{@"name": @"John Lennon",
                                                 @"url": @"http://johnlennon.com"},
                                               @{@"name": @"Paul McCartney",
                                                 @"url": @"http://paulmccartney.com"},
                                               @{@"name": @"George Harrison",
                                                 @"url": @"http://georgeharrison.com"},
                                               @{@"name": @"Ringo Starr",
                                                 @"url": @"http://ringostarr.com"}],
                                   @"date" : @([[NSDate new] timeIntervalSince1970]), //Unix timestamp-style date
                                   };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:sourceObject options:kNilOptions error:NULL];

    //Output objects
    TestObject *target = [TestObject new];

    //Go!
    NSError *mappingError =
    [ BCJReader mapJSONData:jsonData intoObject:target options:BCJNoOptions usingContinuations:
         BCJ_SET(@"number", number), //Fetches the value of the jsonPath, 'number' and sets the 'number' property of target.
         BCJSetProperty(BCJCreateSource(@"date"), BCJCreateTarget(BCJ_KEY(date))),  //The previous line uses the BCJ_SET macro which is just a wrapper arround BCJSetProperty to add runtime selector checking. Note that the date is being implicitly converted from a number to a date. BCJSetProperty supports three such conversions. number->date, string->date & string->url.
         BCJ_SET(@"array[0].url", url), //Fetches the value from a JSON path and implicitly converts it to the correct type.
         BCJSetString(BCJCreateSource(@"string", BCJSourceModeStrict), BCJCreateTarget(BCJ_KEY(string))), //Unlike BCJSetProperty, BCJSetString (and the other type-specific continuation constructors) does not perform 'magic'. It expects the source to be a string and the destination to be a string property. The source has its option set to BCJSourceModeStrict so that it will fail if the value is not found.
         
         //BCJSetMap. There's a lot going on here:
            //A map takes a collection (i.e. an array or a dictionary) and creates an array. In these case we're taking an array of dictionaries and creating an array of urls.
            //The last parameter of BCJSetMap is a block which creates the element to include in the resulting array. In this case we're using BCJGetURL to get the value of the 'url' key and return a URL.
         BCJSetMap(BCJCreateSource(@"array"), BCJCreateTarget(BCJ_KEY(array)), NSDictionary.class, BCJNoOptions, ^id(NSUInteger elementIdx, NSDictionary *elementValue, NSError *__autoreleasing *outError) {
            NSURL *url;
            BCJSourceResult result = BCJGetURL(BCJCreateSource(elementValue, @"url"), &url, outError);
            return (result == BCJSourceResultSuccess) ? url : nil;
         }),
     nil];
}

```


## There are lots of other libraries for handling JSON, why not use one of them?
Other JSON libraries tends to make simplifying assumptions about the JSON structures that they'll be faced with. These assumptions may be suitable for a specific JSON structure but not for all. The promise of these libraries tend to break down when faced with JSON that does not conform to the assumptions. When these assumptions fail we're left in a worse position that if we hadn't used the library: first we must figure out how to breakout of the library and only then can we write the manual code that the library claimed to help use avoid. Other undesirable and common patterns in JSON libraries are:

- Forcing the model objects to be coupled with the JSON library (e.g. by requiring inheriting from a specific class).
- Implicitly coupling the model objects to the JSON structure by use of 'magical' mapping (e.g. by implicitly reading the keys in a dictionary and finding a property on the object with a matching name).


## So what's different about BCJSONReader?
First and foremost BCJSONReader provides the infrastructure for processing JSON (this infrastructure is actually provided by another library, BCLContinuations, which is included with BCJSONReader). BCJSONReader then builds on top of this infrastructure and provides functions for processing JSON. 

If you're lucky enough to be dealing with well structed JSON then you may be better off using a simpler library.
