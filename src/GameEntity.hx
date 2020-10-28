import io.BytesWriter;
import io.BytesReader;
import math.Point4F;
import haxe.xml.Access;
import haxe.ds.StringMap;
import math.Point3F;
using ReaderExtensions;
using WriterExtensions;

class GameEntity
{
    public var datablock: String;
    public var gameClass: String;
    public var position: Point3F;
    public var properties: StringMap<String>;

    public function new() {
        this.datablock = "";
        this.gameClass = "";
        this.position = new Point3F();
        this.properties = new StringMap<String>();
    }

    public static function read(io: BytesReader) {
        var ret = new GameEntity();
        ret.datablock = io.readStr();
        ret.gameClass = io.readStr();
        ret.position = Point3F.read(io);
        ret.properties = io.readDictionary();
        return ret;
    }

    public function write(io: BytesWriter) {
        io.writeStr(this.datablock);
        io.writeStr(this.gameClass);
        this.position.write(io);
        io.writeDictionary(this.properties);
    }
}