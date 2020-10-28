import sys.io.FileOutput;
import sys.io.FileInput;
import math.Point3F;
import haxe.ds.StringMap;
using ReaderExtensions;
using WriterExtensions;

class Trigger
{
    var name: String;
    var datablock: String;
    var properties: StringMap<String>;
    var polyhedron: Polyhedron;
    var offset: Point3F;

    public function new() {
        this.name = "";
        this.datablock = "";
        this.offset = new Point3F();
        this.properties = new StringMap<String>();
        this.polyhedron = new Polyhedron();
    }

    public static function read(io: FileInput) {
        var ret = new Trigger();
        ret.name = io.readString(io.readByte());
        ret.datablock = io.readString(io.readByte());
        ret.properties = io.readDictionary();
        ret.polyhedron = Polyhedron.read(io);
        ret.offset = Point3F.read(io);
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeStr(this.name);
        io.writeStr(this.datablock);
        io.writeDictionary(this.properties);
        this.polyhedron.write(io);
        this.offset.write(io);
    }
}