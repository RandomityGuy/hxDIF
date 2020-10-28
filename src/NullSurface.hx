import sys.io.FileOutput;
import sys.io.FileInput;

class NullSurface 
{
    var windingStart: Int;
    var planeIndex: Int;
    var surfaceFlags: Int;
    var windingCount: Int;

    public function new() {
        this.windingStart = 0;
        this.planeIndex = 0;
        this.surfaceFlags = 0;
        this.windingCount = 0;
    }

    public static function read(io: FileInput, version: Version) {
        var ret = new NullSurface();
        ret.windingStart = io.readInt32();
        ret.planeIndex = io.readUInt16();
        ret.surfaceFlags = io.readByte();
        if (version.interiorVersion >= 13) {
            ret.windingCount = io.readInt32();
        } else {
            ret.windingCount = io.readByte();
        }
        return ret;
    }

    public function write(io: FileOutput, version: Version) {
        io.writeInt32(this.windingStart);
        io.writeUInt16(this.planeIndex);
        io.writeByte(this.surfaceFlags);
        if (version.interiorVersion >= 13) {
            io.writeInt32(this.windingCount);
        } else {
            io.writeByte(this.windingCount);
        }
    }
}