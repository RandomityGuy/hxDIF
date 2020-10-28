import sys.io.FileOutput;
import sys.io.FileInput;

class PolyhedronEdge
{
    var pointIndex0: Int;
    var pointIndex1: Int;
    var faceIndex0: Int;
    var faceIndex1: Int;

    public function new(faceIndex0, faceIndex1,pointIndex0, pointIndex1) {
        this.pointIndex0 = pointIndex0;
        this.pointIndex1 = pointIndex1;
        this.faceIndex0 = faceIndex0;
        this.faceIndex1 = faceIndex1;
    }

    public static function read(io: FileInput) {
        return new PolyhedronEdge(io.readInt32(),io.readInt32(),io.readInt32(),io.readInt32());
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.faceIndex0);
        io.writeInt32(this.faceIndex1);
        io.writeInt32(this.pointIndex0);
        io.writeInt32(this.pointIndex1);
    }
}