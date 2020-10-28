import sys.io.FileOutput;
import sys.io.FileInput;
import math.PlaneF;
import math.Point3F;
using ReaderExtensions;
using WriterExtensions;

class Polyhedron
{
    var pointList: Array<Point3F>;
    var planeList: Array<PlaneF>;
    var edgeList: Array<PolyhedronEdge>;

    public function new() {
        this.pointList = new Array<Point3F>();
        this.planeList = new Array<PlaneF>();
        this.edgeList = new Array<PolyhedronEdge>();
    }

    public static function read(io: FileInput) {
        var ret = new Polyhedron();
        ret.pointList = io.readArray(Point3F.read);
        ret.planeList = io.readArray(PlaneF.read);
        ret.edgeList = io.readArray(PolyhedronEdge.read);
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeArray(this.pointList,(io,p) -> p.write(io));
        io.writeArray(this.planeList,(io,p) -> p.write(io));
        io.writeArray(this.edgeList,(io,p) -> p.write(io));
    }
}