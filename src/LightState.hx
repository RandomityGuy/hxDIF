import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.Int32;

class LightState
{
    var red: Int;
    var green: Int;
    var blue: Int;
    var activeTime: Int32;
    var dataIndex: Int32;
    var dataCount: Int;

    public function new(red: Int,green: Int,blue: Int,activeTime: Int32,dataIndex: Int32,dataCount: Int) {
        this.red = red;
        this.green = green;
        this.blue = blue;
        this.activeTime = activeTime;
        this.dataIndex = dataIndex;
        this.dataCount = dataCount;
    }

    public static function read(io: FileInput) {
        return new LightState(io.readByte(),io.readByte(),io.readByte(),io.readInt32(),io.readInt32(),io.readInt16());
    }

    public function write(io: FileOutput) {
        io.writeByte(this.red);
        io.writeByte(this.green);
        io.writeByte(this.blue);
        io.writeInt32(this.activeTime);
        io.writeInt32(this.dataIndex);
        io.writeInt16(this.dataCount);
    }
}
