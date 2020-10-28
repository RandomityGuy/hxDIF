import sys.io.FileOutput;
import sys.io.FileInput;
import math.Point3F;
import math.SphereF.Spheref;
import math.Box3F;
using ReaderExtensions;
using WriterExtensions;

class ForceField
{
    var forceFieldFileVersion: Int;
    var name: String;
    var triggers: Array<String>;
    var boundingBox: Box3F;
    var boundingSphere: Spheref;
    var normals: Array<Point3F>;
    var planes: Array<Plane>;
    var bspNodes: Array<BSPNode>;
    var bspSolidLeaves: Array<BSPSolidLeaf>;
    var windings: Array<Int>;
    var surfaces: Array<FFSurface>;
    var solidLeafSurfaces: Array<Int>;
    var color: Array<Int>;

    public function new() {

    }

    public static function read(io: FileInput) {
        var ret = new ForceField();
        ret.forceFieldFileVersion = io.readInt32();
        ret.name = io.readString(io.readByte());
        ret.triggers = io.readArray(io -> io.readString(io.readByte()));
        ret.boundingBox = Box3F.read(io);
        ret.boundingSphere = Spheref.read(io);
        ret.normals = io.readArray(Point3F.read);
        ret.planes = io.readArray(Plane.read);
        ret.bspNodes = io.readArray(io -> BSPNode.read(io,new Version()));
        ret.bspSolidLeaves = io.readArray(BSPSolidLeaf.read);
        ret.windings = io.readArray(io -> io.readInt32());
        ret.surfaces = io.readArray(FFSurface.read);
        ret.solidLeafSurfaces = io.readArray(io -> io.readInt32());
        ret.color = io.readColorF();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.forceFieldFileVersion);
        io.writeStr(this.name);
        io.writeArray(this.triggers,(io,p) -> io.writeStr(p));
        this.boundingBox.write(io);
        this.boundingSphere.write(io);
        io.writeArray(this.normals,(io,p) -> p.write(io));
        io.writeArray(this.planes,(io,p) -> p.write(io));
        io.writeArray(this.bspNodes,(io,p) -> p.write(io, new Version()));
        io.writeArray(this.bspSolidLeaves,(io,p) -> p.write(io));
        io.writeArray(this.windings,(io,p) -> io.writeInt32(p));
        io.writeArray(this.surfaces,(io,p) -> p.write(io));
        io.writeArray(this.solidLeafSurfaces,(io,p) -> io.writeInt32(p));
        io.writeColorF(this.color);
    }
}