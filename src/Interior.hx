package;
import sys.io.FileSeek;
import math.Point4F;
import math.Point3F;
import math.SphereF.Spheref;
import math.Box3F;
import haxe.io.BytesBuffer;
import haxe.io.Bytes;
import haxe.Int32;
import sys.io.FileOutput;
import sys.io.FileInput;
using ReaderExtensions;
using WriterExtensions;

class Interior 
{
    var detailLevel: Int;
    var minPixels: Int;
    var boundingBox: Box3F;
    var boundingSphere: Spheref;
    var hasAlarmState: Int;
    var numLightStateEntries: Int;
    var normals: Array<Point3F>;
    var planes: Array<Plane>;
    var points: Array<Point3F>;
    var pointVisibilities: Array<Int>;
    var texGenEQs: Array<TexGenEQ>;
    var bspNodes: Array<BSPNode>;
    var bspSolidLeaves: Array<BSPSolidLeaf>;
    var materialListVersion: Int;
    var materialList: Array<String>;
    var windings: Array<Int>;
    var windingIndices: Array<WindingIndex>;
    var edges: Array<Edge>;
    var zones: Array<Zone>;
    var zoneSurfaces: Array<Int>;
    var zoneStaticMeshes: Array<Int>;
    var zonePortalList: Array<Int>;
    var portals: Array<Portal>;
    var surfaces: Array<Surface>;
    var edges2: Array<Edge2>;
    var normals2: Array<Point3F>;
    var normalIndices: Array<Int>;
    var normalLMapIndices: Array<Int>;
    var alarmLMapIndices: Array<Int>;
    var nullSurfaces: Array<NullSurface>;
    var lightMaps: Array<LightMap>;
    var solidLeafSurfaces: Array<Int>;
    var animatedLights: Array<AnimatedLight>;
    var lightStates: Array<LightState>;
    var stateDatas: Array<StateData>;
    var stateDataFlags: Int;
    var stateDataBuffers: Array<Int>;
    var nameBuffer: Array<Int>;
    var numSubObjects: Int;
    var convexHulls: Array<ConvexHull>;
    var convexHullEmitStrings: Array<Int>;
    var hullIndices: Array<Int>;
    var hullPlaneIndices: Array<Int>;
    var hullEmitStringIndices: Array<Int>;
    var hullSurfaceIndices: Array<Int>;
    var polyListPlanes: Array<Int>;
    var polyListPoints: Array<Int>;
    var polyListStrings: Array<Int>;
    var coordBins: Array<CoordBin>;
    var coordBinIndices: Array<Int>;
    var coordBinMode: Int;
    var baseAmbientColor: Array<Int>;
    var alarmAmbientColor: Array<Int>;
    var numStaticMeshes: Int;
    var texNormals: Array<Point3F>;
    var texMatrices: Array<TexMatrix>;
    var texMatIndices: Array<Int>;
    var extendedLightMapData: Int;
    var lightMapBorderSize: Int;

    public function new() {

    }

    public static function read(io: FileInput, version: Version) {
        if (version.interiorType == "?")
            version.interiorType = "tgea";

        version.interiorVersion = io.readInt32();
        var it = new Interior();
        it.detailLevel = io.readInt32();
        it.minPixels = io.readInt32();
        it.boundingBox = Box3F.read(io);
        it.boundingSphere = Spheref.read(io);
        it.hasAlarmState = io.readByte();
        it.numLightStateEntries = io.readInt32();
        it.normals = io.readArray(Point3F.read);
        it.planes = io.readArray(Plane.read);
        it.points = io.readArray(Point3F.read);
        if (version.interiorVersion == 4) {
            it.pointVisibilities = new Array<Int>();
        } else {
            it.pointVisibilities = io.readArray((io) -> { return io.readByte(); });
        }
        it.texGenEQs = io.readArray(TexGenEQ.read);
        it.bspNodes = io.readArray( (io) -> {return BSPNode.read(io,version);});
        it.bspSolidLeaves = io.readArray(BSPSolidLeaf.read);
        it.materialListVersion = io.readByte();
        it.materialList = io.readArray((io) -> io.readString(io.readByte()));
        it.windings = io.readArrayAs((signed,param) -> param >= 0,(io) -> io.readInt32(),io -> io.readInt16());
        it.windingIndices = io.readArray(WindingIndex.read);
        if (version.interiorVersion >= 12) {
            it.edges = io.readArray(io -> Edge.read(io,version));
        }
        it.zones = io.readArray(io -> Zone.read(io,version));
        it.zoneSurfaces = io.readArrayAs((signed,param) -> false, io-> io.readInt16(), io -> io.readInt16());
        if (version.interiorVersion >= 12) {
            it.zoneStaticMeshes = io.readArray(io -> io.readInt32());
        }
        it.zonePortalList = io.readArrayAs((signed,param) -> false, io-> io.readInt16(), io -> io.readInt16());
        it.portals = io.readArray(Portal.read);

        var pos = io.tell();
        try {
            it.surfaces = io.readArray(io -> Surface.read(io,version));
            if (version.interiorType == "?") {
                version.interiorType = "tge";
            }
        } catch (e) {
            if (version.interiorType == "?")
                version.interiorType = "mbg";
            io.seek(pos,FileSeek.SeekBegin);
            try {
                it.surfaces = io.readArray(io -> Surface.read(io,version));
            } catch (e) {

            }
        }

        if (version.interiorVersion >= 2 && version.interiorVersion  <= 5) {
            it.edges2 = io.readArray(io -> Edge2.read(io,version));
            if (version.interiorVersion >= 4 && version.interiorVersion <= 5) {
                it.normals2 = io.readArray(Point3F.read);
                it.normalIndices = io.readArrayAs((alt,param) -> alt && param == 0,io -> io.readUInt16(),io -> io.readByte());
            }
        }

        if (version.interiorVersion == 4) {
            it.normalLMapIndices = io.readArray(io -> io.readByte());
            it.alarmLMapIndices = new Array<Int>();
        } else if (version.interiorVersion >= 13) {
            it.normalLMapIndices = io.readArray(io -> io.readInt32());
            it.alarmLMapIndices = io.readArray(io -> io.readInt32());
        } else {
            it.normalLMapIndices = io.readArray(io -> io.readByte());
            it.alarmLMapIndices = io.readArray(io -> io.readByte());        
        }

        it.nullSurfaces = io.readArray(io -> NullSurface.read(io,version));
        if (version.interiorVersion != 4) {
            it.lightMaps = io.readArray(io -> LightMap.read(io,version));
            if (it.lightMaps.length > 0 && version.interiorType == "mbg") {
                version.interiorType = "tge";
            }
        } else {
            it.lightMaps = new Array<LightMap>();
        }
        it.solidLeafSurfaces = io.readArrayAs((alt,void) -> alt, io -> io.readInt32(), io -> io.readUInt16());
        it.animatedLights = io.readArray(AnimatedLight.read);
        it.lightStates = io.readArray(LightState.read);
        
        if (version.interiorVersion == 4) {
            it.stateDatas = new Array<StateData>();
            it.stateDataFlags = 0;
            it.stateDataBuffers = new Array<Int>();
            it.numSubObjects = 0;
        } else {
            it.stateDatas = io.readArray(StateData.read);
            it.stateDataBuffers = io.readArrayFlags(io -> io.readByte());
            it.nameBuffer = io.readArray(io -> io.readByte());
            it.stateDataFlags = 0;
            it.numSubObjects = io.readInt32();
        }

        it.convexHulls = io.readArray(ConvexHull.read);
        it.convexHullEmitStrings = io.readArray(io -> io.readByte());
        it.hullIndices = io.readArrayAs((alt,that) -> alt,io -> io.readInt32(), io -> io.readUInt16());
        it.hullPlaneIndices = io.readArrayAs((alt,that) -> true, io -> io.readUInt16(), io -> io.readUInt16());
        it.hullEmitStringIndices = io.readArrayAs((alt,that) -> alt, io -> io.readInt32(), io -> io.readUInt16());
        it.hullSurfaceIndices = io.readArrayAs((alt,that) -> alt, io -> io.readInt32(), io -> io.readUInt16());
        it.polyListPlanes = io.readArrayAs((alt,that) -> true, io -> io.readUInt16(), io -> io.readUInt16());
        it.polyListPoints = io.readArrayAs((alt,that) -> alt, io -> io.readInt32(), io -> io.readUInt16());
        it.polyListStrings = io.readArray(io -> io.readByte());

        it.coordBins = new Array<CoordBin>();
        for (i in 0...256) {
            it.coordBins.push(CoordBin.read(io));
        }

        it.coordBinIndices = io.readArrayAs((a,b) -> true,io -> io.readUInt16(),io -> io.readUInt16());
        it.coordBinMode = io.readInt32();
        
        if (version.interiorVersion == 4) {
            it.baseAmbientColor = [0,0,0,255];
            it.alarmAmbientColor = [0,0,0,255];
            it.extendedLightMapData = 0;
            it.lightMapBorderSize = 0;
        } else {
            it.baseAmbientColor = io.readColorF();
            it.alarmAmbientColor = io.readColorF();
            if (version.interiorVersion >= 10) {
                it.numStaticMeshes = io.readInt32();
            }
            if (version.interiorVersion >= 11) {
                it.texNormals = io.readArray(Point3F.read);
                it.texMatrices = io.readArray(TexMatrix.read);
                it.texMatIndices = io.readArray(io -> io.readInt32());
            } else {
                io.readInt32();
                io.readInt32();
                io.readInt32();
            }
            it.extendedLightMapData = io.readInt32();
            if (it.extendedLightMapData > 0) {
                it.lightMapBorderSize = io.readInt32();
                io.readInt32();
            }
        }

        return it;
    }

    public function write(io: FileOutput,version: Version) {
        io.writeInt32(this.detailLevel);
        io.writeInt32(this.minPixels);
        this.boundingBox.write(io);
        this.boundingSphere.write(io);
        io.writeByte(this.hasAlarmState);
        io.writeInt32(this.numLightStateEntries);
        io.writeArray(this.normals,(io,p) -> p.write(io));
        io.writeArray(this.planes,(io,p) -> p.write(io));
        io.writeArray(this.points,(io,p)->p.write(io));
        if (version.interiorVersion != 4) {
            io.writeArray(this.pointVisibilities,(io,p) -> io.writeByte(p));
        }
        io.writeArray(this.texGenEQs,(io,p) -> p.write(io));
        io.writeArray(this.bspNodes,(io,p) -> p.write(io,version));
        io.writeArray(this.bspSolidLeaves,(io,p) -> p.write(io));
        io.writeByte(this.materialListVersion);
        io.writeArray(this.materialList, (io,p) -> io.writeStr(p));
        io.writeArray(this.windings,(io,p) -> io.writeInt32(p));
        io.writeArray(this.windingIndices,(io,p)->p.write(io));
        if (version.interiorVersion >= 12)
            io.writeArray(this.edges,(io,p) -> p.write(io,version));
        io.writeArray(this.zones,(io,p) -> p.write(io,version));
        io.writeArray(this.zoneSurfaces,(io,p) -> io.writeUInt16(p));
        if (version.interiorVersion >= 12)
            io.writeArray(this.zoneStaticMeshes,(io,p)->io.writeInt32(p));
        io.writeArray(this.zonePortalList,(io,p) -> io.writeUInt16(p));
        io.writeArray(this.portals,(io,p)->p.write(io));
        io.writeArray(this.surfaces,(io,p)->p.write(io,version));
        if (version.interiorVersion >=2 && version.interiorVersion <= 5) {
            io.writeArray(this.edges2,(io,p)->p.write(io,version));
            if (version.interiorVersion >= 4 && version.interiorVersion <= 5) {
                io.writeArray(this.normals2,(io,p)->p.write(io));
                io.writeArray(this.normalIndices,(io,p)->io.writeUInt16(p));
            }
        }
        if (version.interiorVersion == 4) {
            io.writeArray(this.normalLMapIndices,(io,p)->io.writeByte(p));
        } else if (version.interiorVersion >= 13) {
            io.writeArray(this.normalLMapIndices,(io,p)->io.writeInt32(p));
            io.writeArray(this.normalLMapIndices,(io,p)->io.writeInt32(p));
        } else {
            io.writeArray(this.normalLMapIndices,(io,p)->io.writeByte(p));
            io.writeArray(this.normalLMapIndices,(io,p)->io.writeByte(p));
        }

        io.writeArray(this.nullSurfaces,(io,p) -> p.write(io,version));
        if (version.interiorVersion != 4) {
            io.writeArray(this.lightMaps,(io,p) -> p.writeLightMap(io,version));
        }
        io.writeArray(this.solidLeafSurfaces,(io,p) -> io.writeInt32(p));
        io.writeArray(this.animatedLights,(io,p) -> p.write(io));
        io.writeArray(this.lightStates,(io,p) -> p.write(io));
        if (version.interiorVersion != 4) {
            io.writeArray(this.stateDatas,(io,p) -> p.write(io));
            io.writeArrayFlags(this.stateDataBuffers,this.stateDataFlags,(io,p) -> io.writeByte(p));
            io.writeArray(this.nameBuffer,(io,p) -> io.writeByte(p));
            io.writeInt32(this.numSubObjects);
        }

        io.writeArray(this.convexHulls,(io,p) -> p.write(io));
        io.writeArray(this.convexHullEmitStrings,(io,p) -> io.writeByte(p));
        io.writeArray(this.hullIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.hullPlaneIndices,(io,p) -> io.writeInt16(p));
        io.writeArray(this.hullEmitStringIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.hullSurfaceIndices,(io,p) -> io.writeInt32(p));
        io.writeArray(this.polyListPlanes, (io,p) -> io.writeInt16(p));
        io.writeArray(this.polyListPoints,(io,p) -> io.writeInt32(p));
        io.writeArray(this.polyListStrings,(io,p) -> io.writeByte(p));

        for (i in 0...256) {
            this.coordBins[i].write(io);
        }

        io.writeArray(this.coordBinIndices,(io,p) -> io.writeInt16(p));
        io.writeInt32(this.coordBinMode);

        if (version.interiorVersion != 4) {
            io.writeColorF(this.baseAmbientColor);
            io.writeColorF(this.alarmAmbientColor);
            if (version.interiorVersion >= 10)
                io.writeInt32(this.numStaticMeshes);
            if (version.interiorVersion >= 11) {
                io.writeArray(this.texNormals,(io,p) -> p.write(io));
                io.writeArray(this.texNormals,(io,p) -> p.write(io));
                io.writeArray(this.texMatIndices,(io,p) -> io.writeInt32(p));
            } else {
                io.writeInt32(0);
                io.writeInt32(0);
                io.writeInt32(0);
            }
            io.writeInt32(this.extendedLightMapData);
            if (this.extendedLightMapData > 0) {
                io.writeInt32(this.lightMapBorderSize);
                io.writeInt32(0);
            }
        }


    }
}

