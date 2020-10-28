import sys.io.FileOutput;
import sys.io.FileInput;
import math.Point3F;
using WriterExtensions;
class AISpecialNode
{
    var name: String;
    var position: Point3F;

    public function new(name,position) {
        this.name = name;
        this.position = position;
    }

    public static function read(io: FileInput) {
        return new AISpecialNode(io.readString(io.readByte()),Point3F.read(io));
    }

    public function write(io: FileOutput) {
        io.writeStr(this.name);
        this.position.write(io);
    }
}