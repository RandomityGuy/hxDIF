import sys.io.FileOutput;
import sys.io.FileInput;
import math.Point3F;
using ReaderExtensions;
using WriterExtensions;

class VehicleCollision
{
    var vehicleCollisionFileVersion: Int;
    var convexHulls: Array<ConvexHull>;
    var convexHullEmitStrings: Array<Int>;
    var hullIndices: Array<Int>;
    var hullPlaneIndices: Array<Int>;
    var hullEmitStringIndices: Array<Int>;
    var hullSurfaceIndices: Array<Int>;
    var polyListPlanes: Array<Int>;
    var polyListPoints: Array<Int>;
    var polyListStrings: Array<Int>;
    var nullSurfaces: Array<NullSurface>;
    var points: Array<Point3F>;
    var planes: Array<Plane>;
    var windings: Array<Int>;
    var windingIndices: Array<WindingIndex>;

    public function new() {

    }

    public static function read(io: FileInput) {
        var ret = new VehicleCollision();
        ret.vehicleCollisionFileVersion = io.readInt32();
        ret.convexHulls = io.readArray(ConvexHull.read);
        ret.convexHullEmitStrings = io.readArray(io -> io.readByte());
        ret.hullIndices = io.readArray(io -> io.readInt32());
        ret.hullPlaneIndices = io.readArray(io -> io.readInt16());
        ret.hullEmitStringIndices = io.readArray(io -> io.readInt32());
        ret.hullSurfaceIndices = io.readArray(io -> io.readInt32());
        ret.polyListPlanes = io.readArray(io -> io.readInt16());
        ret.polyListPoints = io.readArray(io -> io.readInt32());
        ret.polyListStrings = io.readArray(io -> io.readByte());
        ret.nullSurfaces = io.readArray(io -> NullSurface.read(io,new Version()));
        ret.points = io.readArray(Point3F.read);
        ret.planes = io.readArray(Plane.read);
        ret.windings = io.readArray(io -> io.readInt32());
        ret.windingIndices = io.readArray(WindingIndex.read);
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.vehicleCollisionFileVersion);
        io.writeArray(this.convexHulls,(io,p) -> p.write(io));
        io.writeArray(this.convexHullEmitStrings,(io,p) -> io.writeByte(p));
        io.writeArray(this.hullIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.hullPlaneIndices,(io,p) -> io.writeInt16(p));
        io.writeArray(this.hullEmitStringIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.hullSurfaceIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.polyListPlanes, (io,p) -> io.writeInt16(p));
        io.writeArray(this.polyListPoints,(io,p) -> io.writeInt32(p));
        io.writeArray(this.polyListStrings,(io,p) -> io.writeByte(p));
        io.writeArray(this.nullSurfaces,(io,p) -> p.write(io,new Version()));
        io.writeArray(this.points,(io,p)->p.write(io));
        io.writeArray(this.planes,(io,p) -> p.write(io));
        io.writeArray(this.windings,(io,p) -> io.writeInt32(p));
        io.writeArray(this.windingIndices,(io,p)->p.write(io));
    }

}