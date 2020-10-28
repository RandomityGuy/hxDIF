package;
import haxe.io.Bytes;
import haxe.ds.StringMap;
import sys.io.FileOutput;


class WriterExtensions
{
    public static function writeStr(io: FileOutput, str: String) {
        io.writeByte(str.length);
        for (i in 0...str.length) {
            io.writeByte(str.charCodeAt(i));
        }
    }

    public static function writeDictionary(io: FileOutput, dict: StringMap<String>) {
        var len = 0;
        for (key in dict.keys())
            len++;

        for (kvp in dict.keyValueIterator()) {
            writeStr(io,kvp.key);
            writeStr(io,kvp.value);
        }
    }

    public static function writeArray<V>(io: FileOutput,arr: Array<V>,writeMethod: (FileOutput,V)->Void) {
        
        io.writeInt32(arr.length);
        for (i in 0...arr.length) {
            writeMethod(io,arr[i]);
        }

        return arr;
    }

    public static function writeArrayFlags<V>(io: FileOutput,arr: Array<V>,flags: Int,writeMethod: (FileOutput,V)->Void) {
        io.writeInt32(arr.length);
        io.writeInt32(flags);
        for (i in 0...arr.length) {
            writeMethod(io,arr[i]);
        }
    };

    public static function writePNG(io: FileOutput,arr: Array<Int>) {
        for (i in 0...arr.length) {
            io.writeByte(arr[i]);
        }
    };

    public static function writeColorF(io: FileOutput,color: Array<Int>) {
        io.writeByte(color[0]);
        io.writeByte(color[1]);
        io.writeByte(color[2]);
        io.writeByte(color[3]);
    }
    
    
}