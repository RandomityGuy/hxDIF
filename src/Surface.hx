import sys.io.FileOutput;
import sys.io.FileInput;

class Surface
{
    var windingStart: Int;
    var windingCount: Int;
    var planeIndex: Int;
    var textureIndex: Int;
    var texGenIndex: Int;
    var surfaceFlags: Int;
    var fanMask: Int;
    var lightMapFinalWord: Int;
    var lightMapTexGenXD: Float;
    var lightMapTexGenYD: Float;
    var lightCount: Int;
    var lightStateInfoStart: Int;
    var mapOffsetX: Int;
    var mapOffsetY: Int;
    var mapSizeX: Int;
    var mapSizeY: Int;
    var brushId: Int;

    public function new() {
        this.windingStart = 0;
        this.windingCount = 0;
        this.planeIndex = 0;
        this.textureIndex = 0;
        this.texGenIndex = 0;
        this.surfaceFlags = 0;
        this.fanMask = 0;
        this.lightMapFinalWord = 0;
        this.lightMapTexGenXD = 0;
        this.lightMapTexGenYD = 0;
        this.lightCount = 0;
        this.lightStateInfoStart = 0;
        this.mapOffsetX = 0;
        this.mapOffsetY = 0;
        this.mapSizeX = 0;
        this.mapSizeY = 0;
        this.brushId = 0;
    }

    public static function read(io: FileInput,version: Version) {
        var ret = new Surface();
        ret.windingStart = io.readInt32();
        
        if (version.interiorVersion >= 13)
            ret.windingCount = io.readInt32();
        else 
            ret.windingCount = io.readByte();

        ret.planeIndex = io.readInt16();
        ret.textureIndex = io.readInt16();
        ret.texGenIndex = io.readInt32();
        ret.surfaceFlags = io.readByte();
        ret.fanMask = io.readInt32();
        ret.lightMapFinalWord = io.readInt16();
        ret.lightMapTexGenXD = io.readFloat();
        ret.lightMapTexGenYD = io.readFloat();
        ret.lightCount = io.readInt16();
        ret.lightStateInfoStart = io.readInt32();

        if (version.interiorVersion >= 13) {
            ret.mapOffsetX = io.readInt32();
            ret.mapOffsetY = io.readInt32();
            ret.mapSizeX = io.readInt32();
            ret.mapSizeY = io.readInt32();
        } else {
            ret.mapOffsetX = io.readByte();
            ret.mapOffsetY = io.readByte();
            ret.mapSizeX = io.readByte();
            ret.mapSizeY = io.readByte();
        }

        if (version.interiorType != "tge" && version.interiorType != "mbg") {
            io.readByte();
            if (version.interiorVersion >= 2 && version.interiorVersion <= 5)
                ret.brushId = io.readInt32();
        }

        return ret;
    }

    public function write(io: FileOutput,version: Version) {
        io.writeInt32(this.windingStart);

        if (version.interiorVersion >= 13)
            io.writeInt32(this.windingCount);
        else 
            io.writeByte(this.windingCount);

        io.writeInt16(this.planeIndex);
        io.writeInt16(this.textureIndex);
        io.writeInt32(this.texGenIndex);
        io.writeByte(this.surfaceFlags);
        io.writeInt32(this.fanMask);
        io.writeInt16(this.lightMapFinalWord);
        io.writeFloat(this.lightMapTexGenXD);
        io.writeFloat(this.lightMapTexGenYD);
        io.writeInt16(this.lightCount);
        io.writeInt32(this.lightStateInfoStart);

        if (version.interiorVersion >= 13) {
            io.writeInt32(this.mapOffsetX);
            io.writeInt32(this.mapOffsetY);
            io.writeInt32(this.mapSizeX);
            io.writeInt32(this.mapSizeY);
        } else {
            io.writeByte(this.mapOffsetX);
            io.writeByte(this.mapOffsetY);
            io.writeByte(this.mapSizeX);
            io.writeByte(this.mapSizeY);
        }

        if (version.interiorType != "tge" && version.interiorType != "mbg") {
            io.writeByte(0);
            if (version.interiorVersion >= 2 && version.interiorVersion <= 5)
                io.writeInt32(this.brushId);
        }
    }

}