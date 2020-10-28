import sys.io.FileOutput;
import sys.io.FileInput;
import haxe.Int32;


class AnimatedLight
{
    var nameIndex: Int32;
    var stateIndex: Int32;
    var stateCount: Int;
    var flags: Int;
    var duration: Int32;

    public function new(nameIndex: Int32,stateIndex: Int32, stateCount: Int,flags: Int,duration: Int32) {
        this.nameIndex = nameIndex;
        this.stateIndex = stateIndex;
        this.stateCount = stateCount;
        this.flags = flags;
        this.duration = duration;
    }

    public static function read(io: FileInput) {
        return new AnimatedLight(io.readInt32(),io.readInt32(),io.readInt16(),io.readInt16(),io.readInt32());
    }

    public function write(io: FileOutput) {
        io.writeInt32(this.nameIndex);
        io.writeInt32(this.stateIndex);
        io.writeUInt16(this.stateCount);
        io.writeUInt16(this.flags);
        io.writeInt32(this.duration);
    }
}