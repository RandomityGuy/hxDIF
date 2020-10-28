package math;

import sys.io.FileOutput;
import sys.io.FileInput;

class Spheref
{
    public var originX: Float;
    public var originY: Float;
    public var originZ: Float;
    public var radius: Float;

    public function new() {
        this.originX = 0;
        this.originY = 0;
        this.originZ = 0;
        this.radius = 0;
    }

    public static function read(io: FileInput) {
        var ret = new Spheref();
        ret.originX = io.readFloat();
        ret.originY = io.readFloat();
        ret.originZ = io.readFloat();
        ret.radius = io.readFloat();
        return ret;
    }

    public function write(io: FileOutput) {
        io.writeFloat(this.originX);
        io.writeFloat(this.originY);
        io.writeFloat(this.originZ);
        io.writeFloat(this.radius);
    }
}