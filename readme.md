# BCJJSONContinuations

## TL;DR
BCJJSONContinuations is a library for processing the crazy JSON structures that exist in the real world. Its' key features:
+ Flexible. Provides functionality for handling many JSON usage styles.
+ Extensible. Easy to integrate new processing (e.g. peculiar date formats).
+ Explicit. Does not use reflection to second guess how to process the JSON.
+ Documented.
//+ Tested.



Examples:

````
NSData *jsonData = ...; 
BCMEvent *event = [BCMEvent new]; //The model object we wish to create.
BCJContainer *json = [BCJContainer new];
NSError *error = [BCLContinuation untilError:
                  BCJDeserialize(jsonData, json),
                  BCJSetString(event, BCJ_KEY(eventDescription), json, @"description"),
                  BCJSetDateFromISO8601String(event, BCJ_KEY(date), json, @"date"),
                  BCJSetNumber(event, BCJ_KEY(isRSVPRequired), json, @"rsvp_required", BCJSourceModeOptional, @NO),
                  BCJSetMap(event, BCJ_KEY(speakers), json, @"speakers", NSDictionary.class, BCJMapModeMandatory, id(^fromArrayMap)(NSUInteger elementIndex, NSDictionary *speakerJSON, NSError **outError)) {
                            BCMSpeaker *talk = [BCMTalk new];
                            BOOL didSucceed = [BCLContinuation withError:outError untilError:
                                               BCJSetString(talk, BCJ_KEY(speakerName), speakerJSON, @"name"),
                                               BCJSetString(talk, BCJ_KEY(title), speakerJSON, @"title"),
                                               nil];
                            return (didSucceed) ? talk : nil;
                            }),
                  nil];

````

## What is BCJJSONContinuations?
BCJJSONContinuations is a library for processing the crazy JSON structures that exist in the real world.

## There are lots of other libraries for handling JSON, why not use one of them?
Other JSON libraries tends to make simplifying assumptions about the JSON structures that they'll be faced with. These
assumptions may be suitable for a specific JSON structure but not for all. The promise of these libraries tend to break 
down when faced with JSON that does not conform to the assumptions. When these assumptions fail we're left in a worse
position that if we hadn't used the library: first we must figure out how to breakout of the library and only then can 
we write the manual code that the library claimed to help use avoid. Other undesirable and common patterns in JSON
libraries are:
- Forcing the model objects being coupled with either the JSON library (e.g. by requiring inheriting from a specfic 
class) 
- Implicitly coupling model objects to the JSON structure by encouraging 'magical' mapping. Such magic becomes painful
when debugging as it requires the coder to have an intimate knowledge of the assumptions of the JSON library. This 
knowldege is can only by found by reading the documentation (if there is any) or digging into the libraries codebase.



## So what's different about BCJJSONContinuations?
First and foremost BCJJSONContinuations provides the infrastructure for handling the JSON handling process (this 
infrastructure is actually provided by another library, BCLContinuations, which is included with BCJJSONContinuations). 
BCJJSONContinuations then builds on this infrastructure and provides functions for the common steps that occur when
processing JSON. 

EXPLAIN THAT ALL STEPS MUST BE EXPLICT AND WHY THIS EXTRA EFFORT IS A GOOD THING.

Compared to other libaries BCJJSONContinuations is more verbose. This is (in part) by design.
For example, some other libraries attempt to automatically map from dictionaries to objects. BCJJSONContinuations shuns
'magic' like this in favour of explict statements. Avoiding magic makes it much easier to fix bugs when they inevitable 
appear.

If you're lucky enough to be dealing with well structed JSON then you may be better off using a simplier library.



# Examples
How would implement 'find and update' be implemented if the object must exist when target is created?
- Simple (not reccomended way): 1. Fetch id and then create a sub continuation

- Create and merge: 1 pass and merge:

- walk and collect IDs, fetch all objects from the store, re-walk data, save:
