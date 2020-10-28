# hxDIF
Never write a dif parser again

# Compilation
## C++
```haxe build-cpp.hxml```
## C#
```haxe build-cs.hxml```
## PHP
```haxe build-php.hxml```
## Python
```haxe build-py.hxml```
## Javascript
```haxe build-js.hxml```
## HashLink
```haxe build-hl.hxml```
# Usage
## Normal file loading from path
```
Dif.Load(<path>) // Parses the dif at the file location and returns it
Dif.Save(<dif>,<version>,<path>) // Exports the provided dif of target version to the file location
```
## For JS
```
Dif.LoadFromBuffer(haxe_io_Bytes(<your buffer here>)); // Load
let buffer = Dif.SaveToBuffer(<dif>,<version>).b // Save, buffer is of type UInt8Array
```
