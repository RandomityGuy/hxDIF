@:expose
class Version {
	public var difVersion:Int;
	public var interiorVersion:Int;
	public var interiorType:String;
	public var useLargeLightmaps:Bool;

	public function new() {
		this.difVersion = 44;
		this.interiorVersion = 0;
		this.interiorType = "?";
		this.useLargeLightmaps = false;
	}
}
