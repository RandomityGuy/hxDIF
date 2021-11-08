import math.Point3F;
import io.BytesWriter;
import io.BytesReader;

@:expose
class MirrorSubObject {
	public var detailLevel:Int;
	public var zone:Int;
	public var alphaLevel:Float;
	public var surfaceCount:Int;
	public var surfaceStart:Int;
	public var centroid:Point3F;

	public function new() {
		this.detailLevel = 0;
		this.zone = 0;
		this.alphaLevel = 0;
		this.surfaceCount = 0;
		this.surfaceStart = 0;
		this.centroid = new Point3F();
	}

	public static function read(io:BytesReader, version:Version) {
		var ret = new MirrorSubObject();
		ret.detailLevel = io.readInt32();
		ret.zone = io.readInt32();
		ret.alphaLevel = io.readFloat();
		ret.surfaceCount = io.readInt32();
		ret.surfaceStart = io.readInt32();
		ret.centroid = Point3F.read(io);

		return ret;
	}

	public function write(io:BytesWriter, version:Version) {
		io.writeInt32(this.detailLevel);
		io.writeInt32(this.zone);
		io.writeFloat(this.alphaLevel);
		io.writeInt32(this.surfaceCount);
		io.writeInt32(this.surfaceStart);
		this.centroid.write(io);
	}
}
