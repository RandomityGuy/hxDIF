package math;

import io.BytesWriter;
import io.BytesReader;

class Box3F
{
    public var minX: Float;
    public var minY: Float;
    public var minZ: Float;
    public var maxX: Float;
    public var maxY: Float;
    public var maxZ: Float;

    public function new() {
        this.minX = 0;
        this.minY = 0;
        this.minZ = 0;
        this.maxX = 0;
        this.maxY = 0;
        this.maxZ = 0;
    }

    public static function read(io: BytesReader) {
        var ret = new Box3F();
        ret.minX = io.readFloat();
        ret.minY = io.readFloat();
        ret.minZ = io.readFloat();
        ret.maxX = io.readFloat();
        ret.maxY = io.readFloat();
        ret.maxZ = io.readFloat();
        return ret;
    }

    public function write(io: BytesWriter) {
        io.writeFloat(this.minX);
        io.writeFloat(this.minY);
        io.writeFloat(this.minZ);
        io.writeFloat(this.maxX);
        io.writeFloat(this.maxY);
        io.writeFloat(this.maxZ);
    }
    

}