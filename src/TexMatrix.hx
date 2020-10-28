import haxe.Int32;
import sys.io.FileOutput;
import sys.io.FileInput;

class TexMatrix
{
    public var t: Int32;
    public var n: Int32;
    public var b: Int32;

    public function new() {
        this.t = 0;
        this.n = 0;
        this.b = 0;
    }

    public static function read(io: FileInput) {
        var ret = new TexMatrix();
        ret.t = io.readInt32();
        ret.n = io.readInt32();
        ret.b = io.readInt32();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.t);
        io.writeInt32(this.n);
        io.writeInt32(this.b);
    }
}