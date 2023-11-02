AESCrypt
A container for Advanced Encryption Standard (AES) ciphers.

ChaChaPolyCrypt
An implementation of the ChaCha20-Poly1305 cipher.

ShuffleCrypt
A crypt that moves the middle byte to the front, then recurses to both sides.

JulianCrypt
A variation of ShuffleCrypt with different rules for all smaller sized blocks.

PasswordCrypt
XOR all the bytes by a password, looping through the password.

TaylorCrypt
A variation of PasswordCrypt which uses two passwords and advances the second password based on the characters in the first.

RotateCrypt
Rotates the bytes of the data by a fixed amount.

RotateMaskCrypt
Performs RotateCrypt only on the bits which match the mask.

RotateBlockCrypt
Breaks the data into blocks and performs RotateCrypt on each block.

RotateMaskBlockCrypt
Performs RotateBlockCrypt only on the bits which match the mask.

SplintCrypt
Breaks the data in half and interleaves the two halves together.

SplintBlockCrypt
Breaks the data into blocks, breaks the blocks in half, and interleaves the blocks together.

SplintByteBlockCrypt
Breaks the data into blocks, then does SplintCrypt on each block of data.

WeaveCrypt
Swaps elements from the front and back of the data array, skipping some bytes.

WeaveBlockCrypt
Breaks the data into blocks, then swaps blocks from the front and back of the block array, skipping some blocks.

WeaveByteBlockCrypt
Breaks the data into blocks and performs WeaveCrypt on each block.

WeaveMaskCrypt
Performs WeaveCrypt only on the bits which match the mask.

WeaveMaskBlockCrypt
Performs WeaveBlockCrypt only on the bits which match the mask.

WeaveMaskByteBlockCrypt
Performs WeaveByteBlockCrypt only on the bits which match the mask.

RangeRotationCrypt
Rotates bytes within specified ranges by a given amount.

ReverseCrypt
Reverses the order of the data... Should only be used alongside other crypts.

InvertCrypt
Reverses the bits of the data... Should only be used alongside other crypts.
