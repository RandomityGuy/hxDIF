import haxe.io.Bytes;
import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.Int32;
using ReaderExtensions;
using WriterExtensions;

class LightMap
{
    var lightmap: Array<Int>;
    var lightdirmap: Array<Int>;
    var keepLightMap: Int;

    public function new() {
        this.lightmap = new Array<Int>();
        this.lightdirmap = new Array<Int>();
        this.keepLightMap = 0;
    }

    public static function read(io: FileInput, version: Version) {
        var ret = new LightMap();
        ret.lightmap = io.readPNG();

        if (version.interiorType != "mbg" && version.interiorType != "tge") {
            ret.lightdirmap = io.readPNG();
        }
        ret.keepLightMap = io.readByte();
        return ret;
    }

    public function writeLightMap(io: FileOutput, version: Version) {
        io.writePNG(this.lightmap);
        if (version.interiorType != "mbg" && version.interiorType != "tge") {
            io.writePNG(this.lightdirmap);
        }
        io.writeByte(this.keepLightMap);
    }
}
