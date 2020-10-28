import sys.io.File;
import sys.io.FileOutput;
import sys.io.FileInput;
using ReaderExtensions;
using WriterExtensions;

class Dif
{
    public var difVersion: Int;
    public var previewIncluded: Int;
    public var interiors: Array<Interior>;
    public var subObjects: Array<Interior>;
    public var triggers: Array<Trigger>;
    public var interiorPathfollowers: Array<InteriorPathFollower>;
    public var forceFields: Array<ForceField>;
    public var aiSpecialNodes: Array<AISpecialNode>;
    public var vehicleCollision: VehicleCollision = null;
    public var gameEntities: Array<GameEntity> = null;

    public function new() {

    }

    public static function Load(path: String) {
        var f = File.read(path);
        return Dif.read(f);
    }

    public static function Save(dif: Dif, version: Version, path: String) {
        var f = File.write(path);
        dif.write(f,version);
    }

    public static function read(io: FileInput) {
        var ret = new Dif();
        var version = new Version();
        version.difVersion = io.readInt32();
        ret.difVersion = version.difVersion;
        ret.previewIncluded = io.readByte();
        ret.interiors = io.readArray(io -> Interior.read(io,version));
        ret.subObjects= io.readArray(io -> Interior.read(io,version));
        ret.triggers = io.readArray(Trigger.read);
        ret.interiorPathfollowers = io.readArray(InteriorPathFollower.read);
        ret.forceFields = io.readArray(ForceField.read);
        ret.aiSpecialNodes = io.readArray(AISpecialNode.read);
        var readVehicleCollision = io.readInt32();
        if (readVehicleCollision == 1)
            ret.vehicleCollision = VehicleCollision.read(io);
        var readGameEntities = io.readInt32();
        if (readGameEntities == 2)
            ret.gameEntities = io.readArray(GameEntity.read);

        return ret;
    }

    public function write(io: FileOutput,version: Version) {
        io.writeInt32(this.difVersion);
        io.writeByte(this.previewIncluded);

        io.writeArray(this.interiors,(io,p) -> p.write(io,version));
        io.writeArray(this.subObjects,(io,p) -> p.write(io,version));
        io.writeArray(this.triggers,(io,p) -> p.write(io));
        io.writeArray(this.interiorPathfollowers,(io,p) -> p.write(io));
        io.writeArray(this.forceFields,(io,p) -> p.write(io));
        io.writeArray(this.aiSpecialNodes,(io,p) -> p.write(io));
        if (this.vehicleCollision != null) {
            io.writeInt32(1);
            this.vehicleCollision.write(io);
        } else {
            io.writeInt32(0);
        }
        if (this.gameEntities != null) {
            io.writeInt32(2);
            io.writeArray(this.gameEntities,(io,p) -> p.write(io));
        } else {
            io.writeInt32(0);
        }
        io.writeInt32(0);
    }
}