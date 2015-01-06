# BCJSONReader

## TL;DR
 BCJSONReader is a library for processing the crazy JSON structures that exist in the real world. Its key features are:
+ Flexible. Provides functionality for handling many JSON usage styles.
+ Extensible. Easy to integrate own code and still use BCJSONReader intrastructure.
//+ Documented.
//+ Tested.



### Example

```objc
void demo(void) {
    //Input data
    NSDictionary *sourceObject = @{
                                   @"number": @1234,
                                   @"string": null,
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

    //Go!
    NSError *error = [BCJSONReader readJSONData:jsonData defaultOptions:BCJSONReaderModeOptional usingBlock:(BCJSONReader *reader) {
        NSInteger number = [reader integerAt:@"number"];
        NSString *name = [reader stringAt:@"array[0].name"];
        NSString *string = [reader StringAt:@"string" options:BCJSONReaderModeRequiredNullable defaultValue:@"just another string" didSucceed:NULL];
        NSDate *date = [reader dateFromTimeIntervalSince1970At:@"date"];
    }];
}

```


## There are lots of other libraries for handling JSON, why not use one of them?
Other JSON libraries tends to make simplifying assumptions about the JSON structures that they'll be faced with. These assumptions may be suitable for a specific JSON structure but not for all. The promise of these libraries tend to break down when faced with JSON that does not conform to the assumptions. When these assumptions fail we're left in a worse position that if we hadn't used the library: first we must figure out how to breakout of the library and only then can we write the manual code that the library claimed to help use avoid. Other undesirable and common patterns in JSON libraries are:

- Forcing the model objects to be coupled with the JSON library (e.g. by requiring inheriting from a specific class).
- Implicitly coupling the model objects to the JSON structure by use of 'magical' mapping (e.g. by implicitly reading the keys in a dictionary and finding a property on the object with a matching name).


## So what's different about BCJSONReader?
BCJSONReader only concerns itself with safely extracting values from a JSON object graph.

If you're lucky enough to be dealing with well structed JSON then you may be better off using a simpler library.
