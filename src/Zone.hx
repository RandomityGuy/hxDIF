import sys.io.FileOutput;
import sys.io.FileInput;

class Zone
{
    var portalStart: Int;
    var portalCount: Int;
    var surfaceStart: Int;
    var surfaceCount: Int;
    var staticMeshStart: Int;
    var staticMeshCount: Int;

    public function new() {
        this.portalStart = 0;
        this.portalCount = 0;
        this.surfaceStart = 0;
        this.surfaceCount = 0;
        this.staticMeshStart = 0;
        this.staticMeshCount = 0;
    }

    public static function read(io: FileInput, version: Version) {
        var ret = new Zone();
        ret.portalStart = io.readUInt16();
        ret.portalCount = io.readUInt16();
        ret.surfaceStart = io.readInt32();
        ret.surfaceCount = io.readInt32();
        if (version.interiorVersion >= 12) {
            ret.staticMeshStart = io.readInt32();
            ret.staticMeshCount = io.readInt32();
        }
        return ret;
    }

    public function write(io: FileOutput, version: Version) {
        io.writeInt16(this.portalStart);
        io.writeInt16(this.portalCount);
        io.writeInt32(this.surfaceStart);
        io.writeInt32(this.surfaceCount);
        if (version.interiorVersion >= 12) {
            io.writeInt32(this.staticMeshStart);
            io.writeInt32(this.staticMeshCount);
        }
        
    }
}