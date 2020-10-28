import sys.io.FileOutput;
import sys.io.FileInput;

class Plane
{
    var normalIndex: Int;
    var planeDistance: Float;

    public function new(normalIndex,planeDistance) {
        this.normalIndex = normalIndex;
        this.planeDistance = planeDistance;
    }

    public static function read(io: FileInput) {
        return new Plane(io.readInt16(),io.readFloat());
    }

    public function write(io: FileOutput) {
        io.writeInt16(this.normalIndex);
        io.writeFloat(this.planeDistance);
    }
}