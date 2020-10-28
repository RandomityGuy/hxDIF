import sys.io.FileOutput;
import sys.io.FileInput;
import math.Point4F;
import haxe.xml.Access;
import haxe.ds.StringMap;
import math.Point3F;
using ReaderExtensions;
using WriterExtensions;

class GameEntity
{
    var datablock: String;
    var gameClass: String;
    var position: Point3F;
    var properties: StringMap<String>;

    public function new() {
        this.datablock = "";
        this.gameClass = "";
        this.position = new Point3F();
        this.properties = new StringMap<String>();
    }

    public static function read(io: FileInput) {
        var ret = new GameEntity();
        ret.datablock = io.readString(io.readByte());
        ret.gameClass = io.readString(io.readByte());
        ret.position = Point3F.read(io);
        ret.properties = io.readDictionary();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeStr(this.datablock);
        io.writeStr(this.gameClass);
        this.position.write(io);
        io.writeDictionary(this.properties);
    }
}