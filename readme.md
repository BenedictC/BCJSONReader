# BCJJSONContinuations

BCJJSONContinuations is a library designed to deal with crazy JSON structures that can be found in the real world. 
Other JSON libraries tends to make simplifying assumptions about the JSON structures that they'll be faced with. These
assumptions may be suitable for a specific JSON structure but not all. The promise of these libraries tend to break 
down when faced with JSON that does not conform to the assumptions. TODO: WHAT HAPPENS WHEN THE LIBRARIES COME UP SHORT.

First and foremost BCJJSONContinuations provides the infrastructure for handling the process. It then builds on this
infrastructure and provides mechnaism for the common steps that occur when handling JSON. Compared to other libaries
BCJJSONContinuations is slightly more verbose, for example it does not attempt to automatically map from dictionaries
to objects, but BCJJSONContinuations explicit nature makes for code that is easier to read and debug.

+ Flexible. Provides functions for lots of JSON usage patterns.
+ Predicatable and explicit. Based on strong conventions.
+ Extensible. For when the JSON is especially obscure.
+ Tested
+ Documented

+ Self documenting code. (Functions and constants make it clear what's expected to happen.)
+ Avoids implicity coupling model objects to web service
+ Transparent. No ObjC/Runtime.h magic
