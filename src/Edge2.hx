import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.Int32;

class Edge2
{
    var vertex0: Int32;
    var vertex1: Int32;
    var normal0: Int32;
    var normal1: Int32;
    var face0: Int32;
    var face1: Int32;

    public function new() {
        this.vertex0 = 0;
        this.vertex1 = 0;
        this.normal0 = 0;
        this.normal1 = 0;
        this.face0 = 0;
        this.face1 = 0;
    }

    public static function read(io: FileInput, version: Version) {
        var ret = new Edge2();
        ret.vertex0 = io.readInt32();
        ret.vertex1 = io.readInt32();
        ret.normal0 = io.readInt32();
        ret.normal1 = io.readInt32();
        if (version.interiorVersion >= 3) {
            ret.face0 = io.readInt32();
            ret.face1 = io.readInt32();
        }
        return ret;
    }

    public function write(io: FileOutput, version: Version) {
        io.writeInt32(this.vertex0);
        io.writeInt32(this.vertex1);
        io.writeInt32(this.normal0);
        io.writeInt32(this.normal1);
        if (version.interiorVersion >= 3) {
            io.writeInt32(this.face0);
            io.writeInt32(this.face1);
        }
    }
}