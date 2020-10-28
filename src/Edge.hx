import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.Int32;

class Edge
{
    var pointIndex0: Int32;
    var pointIndex1: Int32;
    var surfaceIndex0: Int32;
    var surfaceIndex1: Int32;

    public function new(pointIndex0, pointIndex1, surfaceIndex0, surfaceIndex1) {
        this.pointIndex0 = pointIndex0;
        this.pointIndex1 = pointIndex1;
        this.surfaceIndex0 = surfaceIndex0;
        this.surfaceIndex1 = surfaceIndex1;
    }

    public static function read(io: FileInput, version: Version) {
        return new Edge(io.readInt32(),io.readInt32(),io.readInt32(),io.readInt32());
    }

    public function write(io: FileOutput, version: Version) {
        io.writeInt32(this.pointIndex0);
        io.writeInt32(this.pointIndex1);
        io.writeInt32(this.surfaceIndex0);
        io.writeInt32(this.surfaceIndex1);
    }
}