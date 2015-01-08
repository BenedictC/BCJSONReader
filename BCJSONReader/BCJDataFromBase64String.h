/*

 This file is based on code taken from http://en.wikibooks.org/w/index.php?title=Algorithm_Implementation/Miscellaneous/Base64&oldid=2735872 on 7th January 2015.

 The page includes the follow text:
 """
 This code is also public domain. This solution has been optimized using pointer math and a look-up table. This algorithm handles multiple encoding formats: with and without line breaks, with and without whitespace, and with and without padding characters.
 """
 */



#ifndef BCJSONReader_WikiBookBase64Decode_h
#define BCJSONReader_WikiBookBase64Decode_h

#import <Foundation/Foundation.h>



static inline NSData *BCJDataFromBase64String(NSString *base64String) {

    int (^base64decode)(const char *in, size_t inLen, unsigned char *out, size_t *outLen) = ^int(const char *in, size_t inLen, unsigned char *out, size_t *outLen) {
        static const char WHITESPACE = 64;
        static const char PADDING = 65;
        static const char INVALID = 66;
        static const unsigned char d[] = {
            66,66,66,66,66,66,66,66,66,64,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,62,66,66,66,63,52,53,
            54,55,56,57,58,59,60,61,66,66,66,65,66,66,66, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,66,66,66,66,66,66,26,27,28,
            29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,66,
            66,66,66,66,66,66
        };


        const char *end = in + inLen;
        size_t buf = 1;
        size_t len = 0;

        while (in < end) {
            unsigned char c = d[*in++];

            switch (c) {
                case WHITESPACE: continue;   /* skip whitespace */
                case INVALID:    return 1;   /* invalid input, return error */
                case PADDING:                /* pad character, end of data */
                    in = end;
                    continue;
                default:
                    buf = buf << 6 | c;

                    /* If the buffer is full, split it into bytes */
                    if (buf & 0x1000000) {
                        if ((len += 3) > *outLen) return 1; /* buffer overflow */
                        *out++ = buf >> 16;
                        *out++ = buf >> 8;
                        *out++ = buf;
                        buf = 1;
                    }
            }
        }

        if (buf & 0x40000) {
            if ((len += 2) > *outLen) return 1; /* buffer overflow */
            *out++ = buf >> 10;
            *out++ = buf >> 2;
        }
        else if (buf & 0x1000) {
            if (++len > *outLen) return 1; /* buffer overflow */
            *out++ = buf >> 4;
        }
        
        *outLen = len; /* modify to reflect the actual output size */
        return 0;
    };

    if (base64String == nil) return nil;

    const char *input = base64String.UTF8String;
    const size_t inLength = [base64String lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    unsigned char *dataBuf = malloc(inLength * sizeof(char)); //Theoretically we could figure out the exact output size and thus make a smaller malloc, but lots of effort for little gain.
    size_t outLength;
    int result = base64decode(input, inLength, dataBuf, &outLength);

    BOOL didSucceed = result == 0;
    if (!didSucceed) {
        free(dataBuf);
        return nil;
    }

    return [[NSData alloc] initWithBytesNoCopy:dataBuf length:outLength freeWhenDone:YES];
}



#endif
