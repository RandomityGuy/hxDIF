import sys.io.FileOutput;
import sys.io.FileInput;

class BSPSolidLeaf
{
    public var surfaceStart: Int;
    public var surfaceCount: Int;

    public function new(surfaceStart, surfaceCount) {
        this.surfaceStart = surfaceStart;
        this.surfaceCount = surfaceCount;
    }

    public static function read(io: FileInput) {
        return new BSPSolidLeaf(io.readInt32(),io.readInt16());
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.surfaceStart);
        io.writeInt16(this.surfaceCount);
    }
}