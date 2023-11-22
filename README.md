=== UnBreaKablE EnCRYptION PoSSiblE ===

First of all, AES and ChaChaPoly ciphers should be unbreakable as long as you do not share your key and nonce.<br />

Does AES have a backdoor? Probably not, but adding additional layers of encryption can guarantee the absense of a backdoor. Many of the ciphers in this library spread/mix data across the whole file, which can ensure stronger encryption than any block-based encryption.<br />

Build your own layer of encryption by combining multiple ciphers.<br />
Decrypt in reverse-order of how you encrypted using the same crypts and parameters.<br />

This is an example of a process:<br />

```
Rotate with the mask 10101010 (170) by 1 to the right.
Weave
Range rotate bytes in the range 36 to 180 by -17

Password

Rotate with the mask 11001100 (204) by 1 to the left.
Weave
Range rotate bytes in the range 121 to 255 by 14

Rotate with the mask 11110000 (240) by 1 to the right.
Weave
Range rotate bytes in the range 0 to 111 by -20
```

The more passes you add, the more difficult the encryption will be to break.<br />
The more different crypts you combine, the more difficult the encryption will be to break.<br />

Avoid useless cycles such as Weave, Weave, Weave, Weave, unless they are using different parameters.<br />

Too much is too much... There is not much added benefit to making, for example, 100's of layers of encryption.<br />

Too little is too little... Some of these ciphers such as "ReverseCipher" are extremely simplistic and included as corollary to their masked counter-part, they should not be used as an individual source of encryption. See "UnbreakableCipher.swift" for an example of how to build tough level encryption. I would advise you to use your own unique parameters and sequencing.<br />

=== Example ===

```
struct ExampleCipher: Cipher {
    func encrypt(data: Data) throws -> Data {
        var encrypted = data
        for crypt in crypts {
            encrypted = try crypt.encrypt(data: encrypted)
        }
        return encrypted
    }
    
    func decrypt(data: Data) throws -> Data {
        var decrypted = data
        for crypt in crypts.reversed() {
            decrypted = try crypt.decrypt(data: decrypted)
        }
        return decrypted
    }
    
    private var crypts: [Cipher] {
        var result = [Cipher]()
        result.append(RotateMaskCipher(mask: 170, shift: 1))
        result.append(WeaveCipher(count: 1, frontStride: 1, backStride: 0))
        result.append(RangeRotationCipher(lowerBound: 36, upperBound: 180, shift: -17))
        
        result.append(PasswordCipher(password: "EnCrYpTiOn"))
        result.append(RotateMaskCipher(mask: 204, shift: -1))
        result.append(WeaveCipher(count: 2, frontStride: 0, backStride: 1))
        result.append(RangeRotationCipher(lowerBound: 121, upperBound: 255, shift: 14))
        
        result.append(RotateMaskBlockCipher(blockSize: 6, mask: 240, shift: 1))
        result.append(WeaveCipher(count: 1, frontStride: 1, backStride: 1))
        result.append(RangeRotationCipher(lowerBound: 0, upperBound: 111, shift: -20))
        
        return result
    }
}
```

=== Usage ===

```
let original = "My big long string that I want to encrypt and decrypt"

let originalData = original.data(using: .utf8)!

let myCipher = ExampleCipher()

let encrypted = try! myCipher.encrypt(data: originalData)
let decrypted = try! myCipher.decrypt(data: encrypted)

let final = String(data: decrypted, encoding: .utf8)!

print("original string: \"\(original)\"")
print("final string: \"\(final)\"")
print("they should be the same...")
```

Please see EncryptionToolsTests for verification of these crypts.

=== The Ciphers ===

AESCipher (CryptoKit)<br />
A container for Advanced Encryption Standard (AES) ciphers.<br />

ChaChaPolyCipher (CryptoKit)<br />
An implementation of the ChaCha20-Poly1305 cipher.<br />

PasswordCipher<br />
XOR all the bytes by a password, looping through the password.<br />

TaylorCipher<br />
A variation of PasswordCipher which uses two passwords and advances the second password based on the characters in the first.<br />

RotateCipher<br />
Rotates the bytes of the data by a fixed amount.<br />

RotateMaskCipher<br />
Performs RotateCipher only on the bits which match the mask.<br />

RotateBlockCipher<br />
Breaks the data into blocks and performs RotateCipher on each block.<br />

RotateMaskBlockCipher<br />
Performs RotateBlockCipher only on the bits which match the mask.<br />

SplintCipher<br />
Breaks the data in half and interleaves the two halves together.<br />

SplintBlockCipher<br />
Breaks the data into blocks, breaks the blocks in half, and interleaves the blocks together.<br />

SplintByteBlockCipher<br />
Breaks the data into blocks, then does SplintCipher on each block of data.<br />

SplintMaskCipher<br />
Performs SplintCipher only on the bits which match the mask.<br />

SplintMaskBlockCipher<br />
Performs SplintBlockCipher only on the bits which match the mask.<br />

SplintMaskByteBlockCipher<br />
Performs SplintByteBlockCipher only on the bits which match the mask.<br />

WeaveCipher<br />
Swaps elements from the front and back of the data array, skipping some bytes.<br />

WeaveBlockCipher<br />
Breaks the data into blocks, then swaps blocks from the front and back of the block array, skipping some blocks.<br />

WeaveByteBlockCipher<br />
Breaks the data into blocks and performs WeaveCipher on each block.<br />

WeaveMaskCipher<br />
Performs WeaveCipher only on the bits which match the mask.<br />

WeaveMaskBlockCipher<br />
Performs WeaveBlockCipher only on the bits which match the mask.<br />

WeaveMaskByteBlockCipher<br />
Performs WeaveByteBlockCipher only on the bits which match the mask.<br />

RangeRotationCipher<br />
Rotates bytes within specified ranges by a given amount.<br />

ShuffleCipher<br />
A crypt that moves the middle byte to the front, then recurses to both sides.<br />

JulianCipher<br />
A variation of ShuffleCipher with different rules for all smaller sized blocks.<br />

ReverseCipher<br />
Reverses the order of the data... Should only be used alongside other crypts.<br />

ReverseMaskCipher<br />
Performs ReverseCipher only on the bits which match the mask.<br />

InvertCipher<br />
Reverses the bits of the data... Should only be used alongside other crypts.<br />

InvertMaskCipher<br />
Performs InvertCipher only on the bits which match the mask.<br />

MarshallCipher<br />
Uses a mask to generate a large key from the bits matching the mask.<br />
The key is applied to the bits which are opposite of the mask.<br />

MistyCipher<br />
Uses internal rotating mask to generate a large key from the bits matching the mask.<br />
The key is applied to the bits which are opposite of the rotating mask.<br />

MeganCipher<br />
Uses a mask and internal rotating mask to generate a large key from the bits matching the mask.<br />
The key is applied to the bits which are opposite of the rotating mask.<br />
