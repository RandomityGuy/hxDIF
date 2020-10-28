import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.xml.Access;
import haxe.ds.StringMap;
import math.Point3F;
using ReaderExtensions;
using WriterExtensions;

class InteriorPathFollower
{
    var name: String;
    var datablock: String;
    var interiorResIndex: Int;
    var offset: Point3F;
    var properties: StringMap<String>;
    var triggerId: Array<Int>;
    var wayPoint: Array<WayPoint>;
    var totalMS: Int;

    public function new() {
        this.name = "";
        this.datablock = "";
        this.interiorResIndex = 0;
        this.offset = new Point3F();
        this.properties = new StringMap<String>();
        this.triggerId = new Array<Int>();
        this.wayPoint = new Array<WayPoint>();
        this.totalMS = 0;
    }

    public static function read(io: FileInput) {
        var ret = new InteriorPathFollower();
        ret.name = io.readString(io.readByte());
        ret.datablock = io.readString(io.readByte());
        ret.interiorResIndex = io.readInt32();
        ret.offset = Point3F.read(io);
        ret.properties = io.readDictionary();
        ret.triggerId = io.readArray(io -> io.readInt32());
        ret.wayPoint = io.readArray(WayPoint.read);
        ret.totalMS = io.readInt32();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeStr(this.name);
        io.writeStr(this.datablock);
        io.writeInt32(this.interiorResIndex);
        this.offset.write(io);
        io.writeDictionary(this.properties);
        io.writeArray(this.triggerId, (io,p) -> io.writeInt32(p));
        io.writeArray(this.wayPoint, (io,p) -> p.write(io));
        io.writeInt32(this.totalMS);
    }
}