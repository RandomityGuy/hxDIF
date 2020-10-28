import haxe.Int32;
import sys.io.FileOutput;
import sys.io.FileInput;

class StateData
{
    var surfaceIndex: Int32;
    var mapIndex: Int32;
    var lightStateIndex: Int32;

    public function new(surfaceIndex: Int32, mapIndex: Int32, lightStateIndex: Int32) {
        this.surfaceIndex = surfaceIndex;
        this.mapIndex = mapIndex;
        this.lightStateIndex = lightStateIndex;
    }

    public static function read(io: FileInput) {
        return new StateData(io.readInt32(),io.readInt32(),io.readInt32());
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.surfaceIndex);
        io.writeInt32(this.mapIndex);
        io.writeInt32(this.lightStateIndex);
    }
}