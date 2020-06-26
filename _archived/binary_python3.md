# Python3 Binary Cheatsheet

## Types:

- `int` when computing natively
- `bytes` for immutable data
- `bytearray` for mutable bytes
- `struct` as a parser and container for bytes
- `string` for hex representations and I/O with humans or tooling

## string -> int -> string:

```python
i = int('0x1001', 16)  # 4097
hex(i)
# '0x1001'
```

## int -> bytes:

```python
i = 12  # 12

## when converting, choose word size (4) and encoding ('big')
b_i = i.to_bytes(4, 'big')  # b'\x00\x00\x00\x0c'
ba_i = bytearray(a.to_bytes(4, 'big'))  # bytearray(b'\x00\x00\x00\x0c')

## 'bytes' and 'bytearray' can be compared directly
b_i == ba_i
# True

## NOTICE both above are big-endian, to byteswap:
lba_i = ba_i
ba_i.reverse()  # does not return a value; don't use to assign
lba_i
# bytearray(b'\x0c\x00\x00\x00')

## ... or parse as little-endian in the first place:
lb_i = i.to_bytes(4, 'little')  # b'\x0c\x00\x00\x00'

lb_i == lba_i
# True
```

## int -(struct)-> bytes:

```python
import struct

## For format codes, see https://docs.python.org/3.8/library/struct.html#format-characters
s4 = struct.pack('<I', 0x1004)  # b'\x04\x10\x00\x00'
s8 = struct.pack('<Q', 0x1004)  # b'\x04\x10\x00\x00\x00\x00\x00\x00'

## Use ranges on 'bytes'
s4 == s8
# False
s4 == s8[0:4]
# True
```

## bytes -> string:

```python
s4 = int('0x1004', 16).to_bytes(4, 'little')  # b'\x04\x10\x00\x00'

st_be = s4.hex()  # '04100000'

## reverse endianness when printing
## NOTE this *will* break if working with values greater than the word size of the machine
st_le = s4[::-1].hex()  # '00001004'

## can also use struct to parse
import struct

hex(struct.unpack('<I', s4)[0])  # '0x1004'
```

## string -> bytearray -> string

```python
ba = bytearray.fromhex('e77bd7f6e4ce3e8c1e8812791e2add7c')  # b'\xe7{\xd7\xf6\xe4\xce>\x8c\x1e\x88\x12y\x1e*\xdd|'
ba.hex()  # 'e77bd7f6e4ce3e8c1e8812791e2add7c'
```
