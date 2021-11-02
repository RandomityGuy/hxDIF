import io.BytesWriter;
import io.BytesReader;

@:expose
class Zone {
	public var portalStart:Int;
	public var portalCount:Int;
	public var surfaceStart:Int;
	public var surfaceCount:Int;
	public var staticMeshStart:Int;
	public var staticMeshCount:Int;
	public var flags:Int;

	public function new() {
		this.portalStart = 0;
		this.portalCount = 0;
		this.surfaceStart = 0;
		this.surfaceCount = 0;
		this.staticMeshStart = 0;
		this.staticMeshCount = 0;
		this.flags = 0;
	}

	public static function read(io:BytesReader, version:Version) {
		var ret = new Zone();
		ret.portalStart = io.readUInt16();
		ret.portalCount = io.readUInt16();
		ret.surfaceStart = io.readInt32();
		if (version.interiorType == 'tgea' || version.interiorType == 'tge') {
			if (version.interiorVersion >= 14 || version.interiorVersion == 0) {
				ret.surfaceCount = io.readUInt16();
			} else {
				ret.surfaceCount = io.readInt32();
			}
		} else
			ret.surfaceCount = io.readInt32();
		if (version.interiorVersion >= 12) {
			ret.staticMeshStart = io.readInt32();
			ret.staticMeshCount = io.readInt32();
		}
		if (version.interiorType == 'tgea' || version.interiorType == 'tge') {
			if (version.interiorVersion >= 14 || version.interiorVersion == 0) {
				ret.flags = io.readUInt16();
			}
		}
		return ret;
	}

	public function write(io:BytesWriter, version:Version) {
		io.writeInt16(this.portalStart);
		io.writeInt16(this.portalCount);
		io.writeInt32(this.surfaceStart);
		if (version.interiorType == 'tgea' || version.interiorType == 'tge') {
			if (version.interiorVersion >= 14 || version.interiorVersion == 0) {
				io.writeUInt16(this.surfaceCount);
			} else {
				io.writeInt32(this.surfaceCount);
			}
		} else
			io.writeInt32(this.surfaceCount);
		if (version.interiorVersion >= 12) {
			io.writeInt32(this.staticMeshStart);
			io.writeInt32(this.staticMeshCount);
		}
		if (version.interiorType == 'tgea' || version.interiorType == 'tge') {
			if (version.interiorVersion >= 14 || version.interiorVersion == 0) {
				io.writeUInt16(this.flags);
			}
		}
	}
}
