# hxDIF
Never write a dif parser again

# Compilation

## Build All Targets
```buildall.bat```   
OR   
```buildall.sh```   
## C++
```haxe build-cpp.hxml```
## C#
```haxe build-cs.hxml```
## PHP
```haxe build-php.hxml```
## Python
```haxe build-py.hxml```
## JavaScript
```haxe build-js.hxml```

## TypeScript
Requires hxtsdgen, get it using ```haxelib install hxtsdgen```   
```haxe build-ts.hxml```

## Java
```haxe build-java.hxml```

## Lua
```haxe build-lua.hxml```

## HashLink
```haxe build-hl.hxml```
# Usage
## Save/Load from file path
```
Dif.Load(<path>) // Parses the dif at the file location and returns it
Dif.Save(<dif>,<version>,<path>) // Exports the provided dif of target version to the file location
```

## Load from Buffer

### C#
```
var dif = Dif.LoadFromArray(byte[] bytes); // Load
var bytes = Dif.SaveToBuffer(Dif dif, Version version); // Save, Returns a byte[]
```

### JavaScript/TypeScript
```
let dif = Dif.LoadFromArrayBuffer(buffer: ArrayBuffer); // Load
let buffer = Dif.SaveToArrayBuffer(dif: Dif, version: Version) // Save, buffer is of type UInt8Array
```

### Python
```
dif = Dif.LoadFromByteArray(buffer: ByteArray); // Load
buffer = Dif.SaveToByteArray(dif: Dif, version: Version) // Save, returns a ByteArray
```

### Other Languages
Construct a haxe.io.Bytes object containing your data.  
Load the Dif using Dif.LoadFromBuffer static method.  
Save the dif by calling Dif.SaveToBuffer static method.  