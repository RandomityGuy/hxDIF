import sys.io.FileOutput;
import sys.io.FileInput;
import math.PlaneF;

class TexGenEQ
{
    var planeX: PlaneF;
    var planeY: PlaneF;

    public function new() {
        planeX = new PlaneF();
        planeY = new PlaneF();
    }

    public static function read(io: FileInput) {
        var ret = new TexGenEQ();
        ret.planeX = PlaneF.read(io);
        ret.planeY = PlaneF.read(io);
        return ret;
    }

    public function write(io: FileOutput) {
        this.planeX.write(io);
        this.planeY.write(io);
    }
}