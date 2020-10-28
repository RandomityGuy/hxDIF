import sys.io.FileOutput;
import sys.io.FileInput;

class WindingIndex
{
    public var windingStart: Int;
    public var windingCount: Int;

    public function new(windingStart, windingCount) {
        this.windingStart = windingStart;
        this.windingCount = windingCount;
    }

    public static function read(io: FileInput) {
        return new WindingIndex(io.readInt32(),io.readInt32());
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.windingStart);
        io.writeInt32(this.windingCount);
    }
}