package math;

import sys.io.FileOutput;
import sys.io.FileInput;

class Point3F
{
    public var x: Float;
    public var y: Float;
    public var z: Float;

    public function new() {
        this.x = 0;
        this.y = 0;
        this.z = 0;
    }

    public static function read(io: FileInput) {
        var ret = new Point3F();
        ret.x = io.readFloat();
        ret.y = io.readFloat();
        ret.z = io.readFloat();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeFloat(this.x);
        io.writeFloat(this.y);
        io.writeFloat(this.z);
    }
}