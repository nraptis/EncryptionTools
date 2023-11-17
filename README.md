=== UnBreaKablE EnCRYptION PoSSiblE ===

First of all, AES and ChaChaPoly cyphers should be unbreakable as long as you do not share your key and nonce.<br />

Build your own layer of encryption by combining multiple cyphers.<br />
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

=== Example ===

```
struct ExampleCrypt: Cryptable {
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
    
    private var crypts: [Cryptable] {
        var result = [Cryptable]()
        result.append(RotateMaskCrypt(mask: 170, shift: 1))
        result.append(WeaveCrypt(count: 1, frontStride: 1, backStride: 0))
        result.append(RangeRotationCrypt(lowerBound: 36, upperBound: 180, shift: -17))
        
        result.append(PasswordCrypt(password: "EnCrYpTiOn"))
        result.append(RotateMaskCrypt(mask: 204, shift: -1))
        result.append(WeaveCrypt(count: 2, frontStride: 0, backStride: 1))
        result.append(RangeRotationCrypt(lowerBound: 121, upperBound: 255, shift: 14))
        
        result.append(RotateMaskBlockCrypt(blockSize: 6, mask: 240, shift: 1))
        result.append(WeaveCrypt(count: 1, frontStride: 1, backStride: 1))
        result.append(RangeRotationCrypt(lowerBound: 0, upperBound: 111, shift: -20))
        
        return result
    }
}
```

=== Usage ===

```
let original = "My big long string that I want to encrypt and decrypt"

let originalData = original.data(using: .utf8)!

let myCrypt = ExampleCrypt()

let encrypted = try! myCrypt.encrypt(data: originalData)
let decrypted = try! myCrypt.decrypt(data: encrypted)

let final = String(data: decrypted, encoding: .utf8)!

print("original string: \"\(original)\"")
print("final string: \"\(final)\"")
print("they should be the same...")
```


Please see EncryptionToolsTests for verification of these crypts.

=== The Crypts ===

AESCrypt (CryptoKit)<br />
A container for Advanced Encryption Standard (AES) ciphers.<br />

ChaChaPolyCrypt (CryptoKit)<br />
An implementation of the ChaCha20-Poly1305 cipher.<br />

PasswordCrypt<br />
XOR all the bytes by a password, looping through the password.<br />

TaylorCrypt<br />
A variation of PasswordCrypt which uses two passwords and advances the second password based on the characters in the first.<br />

RotateCrypt<br />
Rotates the bytes of the data by a fixed amount.<br />

RotateMaskCrypt<br />
Performs RotateCrypt only on the bits which match the mask.<br />

RotateBlockCrypt<br />
Breaks the data into blocks and performs RotateCrypt on each block.<br />

RotateMaskBlockCrypt<br />
Performs RotateBlockCrypt only on the bits which match the mask.<br />

SplintCrypt<br />
Breaks the data in half and interleaves the two halves together.<br />

SplintBlockCrypt<br />
Breaks the data into blocks, breaks the blocks in half, and interleaves the blocks together.<br />

SplintByteBlockCrypt<br />
Breaks the data into blocks, then does SplintCrypt on each block of data.<br />

WeaveCrypt<br />
Swaps elements from the front and back of the data array, skipping some bytes.<br />

WeaveBlockCrypt<br />
Breaks the data into blocks, then swaps blocks from the front and back of the block array, skipping some blocks.<br />

WeaveByteBlockCrypt<br />
Breaks the data into blocks and performs WeaveCrypt on each block.<br />

WeaveMaskCrypt<br />
Performs WeaveCrypt only on the bits which match the mask.<br />

WeaveMaskBlockCrypt<br />
Performs WeaveBlockCrypt only on the bits which match the mask.<br />

WeaveMaskByteBlockCrypt<br />
Performs WeaveByteBlockCrypt only on the bits which match the mask.<br />

RangeRotationCrypt<br />
Rotates bytes within specified ranges by a given amount.<br />

ShuffleCrypt<br />
A crypt that moves the middle byte to the front, then recurses to both sides.<br />

JulianCrypt<br />
A variation of ShuffleCrypt with different rules for all smaller sized blocks.<br />

ReverseCrypt<br />
Reverses the order of the data... Should only be used alongside other crypts.<br />

InvertCrypt<br />
Reverses the bits of the data... Should only be used alongside other crypts.<br />

