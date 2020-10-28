package math;

import io.BytesWriter;
import io.BytesReader;

class PlaneF
{
    public var x: Float;
    public var y: Float;
    public var z: Float;
    public var d: Float;

    public function new() {
        this.x = 0;
        this.y = 0;
        this.z = 0;
        this.d = 0;
    }

    public static function read(io: BytesReader) {
        var ret = new PlaneF();
        ret.x = io.readFloat();
        ret.y = io.readFloat();
        ret.z = io.readFloat();
        ret.d = io.readFloat();
        return ret;
    }

    public function write(io: BytesWriter) {
        io.writeFloat(this.x);
        io.writeFloat(this.y);
        io.writeFloat(this.z);
        io.writeFloat(this.d);
    }
}