import sys.io.FileOutput;
import sys.io.FileInput;

class FFSurface
{
    var windingStart: Int;
    var windingCount: Int;
    var planeIndex: Int;
    var surfaceFlags: Int;
    var fanMask: Int;

    public function new() {
        this.windingStart = 0;
        this.windingCount = 0;
        this.planeIndex = 0;
        this.surfaceFlags = 0;
        this.fanMask = 0;
    }

    public static function read(io: FileInput) {
        var ret = new FFSurface();
        ret.windingStart = io.readInt32();
        ret.windingCount = io.readByte();
        ret.planeIndex = io.readInt16();
        ret.surfaceFlags = io.readByte();
        ret.fanMask = io.readInt32();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.windingStart);
        io.writeByte(this.windingCount);
        io.writeInt16(this.planeIndex);
        io.writeByte(this.surfaceFlags);
        io.writeInt32(this.fanMask);
    }
}