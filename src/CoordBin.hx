import haxe.Int32;
import sys.io.FileOutput;
import sys.io.FileInput;

class CoordBin
{
    var binStart: Int32;
    var binCount: Int32;

    public function new() {
        this.binStart = 0;
        this.binCount = 0;
    }

    public static function read(io: FileInput) {
        var ret = new CoordBin();
        ret.binStart = io.readInt32();
        ret.binCount = io.readInt32();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.binStart);
        io.writeInt32(this.binCount);
    }
}
