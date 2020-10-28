package math;

import sys.io.FileOutput;
import sys.io.FileInput;

class QuatF
{
    var x: Float;
    var y: Float;
    var z: Float;
    var w: Float;

    public function new() {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.w = 0;
    }

    public static function read(io: FileInput) {
        var ret = new QuatF();
        ret.x = io.readFloat();
        ret.y = io.readFloat();
        ret.z = io.readFloat();
        ret.w = io.readFloat();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeFloat(this.x);
        io.writeFloat(this.y);
        io.writeFloat(this.z);
        io.writeFloat(this.w);
    }
}