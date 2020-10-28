import sys.io.FileOutput;
import sys.io.FileInput;

class Portal
{
    var planeIndex: Int;
    var triFanCount: Int;
    var triFanStart: Int;
    var zoneFront: Int;
    var zoneBack: Int;

    public function new(planeIndex, triFanCount, triFanStart, zoneFront, zoneBack) {
        this.planeIndex = planeIndex;
        this.triFanCount = triFanCount;
        this.triFanStart = triFanStart;
        this.zoneFront = zoneFront;
        this.zoneBack = zoneBack;
    }

    public static function read(io: FileInput) {
        return new Portal(io.readUInt16(),io.readUInt16(),io.readInt32(),io.readUInt16(),io.readUInt16());
    }

    public function write(io: FileOutput) {
        io.writeUInt16(this.planeIndex);
        io.writeUInt16(this.triFanCount);
        io.writeInt32(this.triFanStart);
        io.writeUInt16(this.zoneFront);
        io.writeUInt16(this.zoneBack);
    }
}