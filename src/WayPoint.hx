import sys.io.FileOutput;
import sys.io.FileInput;
import math.QuatF;
import math.Point3F;

class WayPoint
{
    var position: Point3F;
    var rotation: QuatF;
    var msToNext: Int;
    var smoothingType: Int;

    public function new(position, rotation, msToNext, smoothingType) {
        this.position = position;
        this.rotation = rotation;
        this.msToNext = msToNext;
        this.smoothingType = smoothingType;
    }

    public static function read(io: FileInput) {
        return new WayPoint(Point3F.read(io), QuatF.read(io), io.readInt32(), io.readInt32());
    };

    public function write(io: FileOutput) {
        this.position.write(io);
        this.rotation.write(io);
        io.writeInt32(this.msToNext);
        io.writeInt32(this.smoothingType);
    }
}