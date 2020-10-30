package builder;

import math.SphereF.Spheref;
import math.Box3F;
import haxe.crypto.Adler32;
import io.BytesWriter;
import math.PlaneF;
import math.Point2F;
import math.Point3F;

class DifBuilder
{
    var FlipNormals: Bool = false;
    var polygons: Array<Polygon>;
    var interior: Interior;
    var planehashes: Map<Int,Int>;
    var pointhashes: Map<Int,Int>;

    var materialList: Array<String>;

    var orderedPolys: Array<Polygon>;

    public function new() {
        this.polygons = new Array<Polygon>();
        this.interior = new Interior();
        this.materialList = new Array<String>();
        this.orderedPolys = new Array<Polygon>();
    }

    function hashPt(p: Point3F) {
        var b = new BytesWriter();
        b.writeFloat(p.x);
        b.writeFloat(p.y);
        b.writeFloat(p.z);
        return Adler32.make(b.getBuffer());
    }

    function hashPlane(p: PlaneF) {
        var b = new BytesWriter();
        b.writeFloat(p.x);
        b.writeFloat(p.y);
        b.writeFloat(p.z);
        b.writeFloat(p.d);
        return Adler32.make(b.getBuffer());
    }

    public function AddTriangle(p1: Point3F,p2: Point3F, p3: Point3F, uv1: Point2F, uv2: Point2F, uv3: Point2F) {
        var poly = new Polygon();
        poly.vertices = this.FlipNormals ? [p3, p2, p1] : [p1, p2, p3];
        poly.indices = [0, 1 ,2];
        poly.uv = this.FlipNormals ? [uv3, uv2, uv1] : [uv1, uv2, uv3];
        poly.material = "None";
        poly.normal = p2.sub(p1).cross(p3.sub(p1)).normalized().scalar(this.FlipNormals ? -1 : 1);
        this.polygons.push(poly);
    }

    public function AddTriangleNormalMaterial(p1: Point3F,p2: Point3F, p3: Point3F, uv1: Point2F, uv2: Point2F, uv3: Point2F, normal: Point3F, material: String) {
        var poly = new Polygon();
        poly.vertices = this.FlipNormals ? [p3, p2, p1] : [p1, p2, p3];
        poly.indices = [0, 1 ,2];
        poly.uv = this.FlipNormals ? [uv3, uv2, uv1] : [uv1, uv2, uv3];
        poly.material = material;
        poly.normal = normal.scalar(this.FlipNormals ? -1 : 1);
        if (!this.materialList.contains(poly.material))
            materialList.push(material);
        this.polygons.push(poly);
    }

    public function AddTriangleMaterial(p1: Point3F,p2: Point3F, p3: Point3F, uv1: Point2F, uv2: Point2F, uv3: Point2F, material: String) {
        var poly = new Polygon();
        poly.vertices = this.FlipNormals ? [p3, p2, p1] : [p1, p2, p3];
        poly.indices = [0, 1 ,2];
        poly.uv = this.FlipNormals ? [uv3, uv2, uv1] : [uv1, uv2, uv3];
        poly.material = material;
        poly.normal = p2.sub(p1).cross(p3.sub(p1)).normalized().scalar(this.FlipNormals ? -1 : 1);
        if (!this.materialList.contains(poly.material))
            materialList.push(material);
        this.polygons.push(poly);
    }

    public function AddPolygon(poly: Polygon) {
        this.polygons.push(poly);
        if (!this.materialList.contains(poly.material))
            materialList.push(poly.material);
    }

    function ExportPlanePolygon(poly: Polygon) {
        if (interior.planes == null)
            interior.planes = new Array<Plane>();

        if (interior.normals == null)
            interior.normals = new Array<Point3F>();

        if (this.planehashes == null)
            this.planehashes = new Map<Int,Int>();

        var plane = PlaneF.PointNormal(poly.vertices[0],poly.normal);
        var hash = hashPlane(plane);

        if (planehashes.exists(hash)) {
            return planehashes.get(hash);
        }

        var index = interior.planes.length;

        var p = new Plane(0,0);
        p.normalIndex = interior.normals.length;
        p.planeDistance = plane.d;
        interior.planes.push(p);
        interior.normals.push(poly.normal);
        return index;
    }

    function ExportPlane(plane: PlaneF) {
        if (interior.planes == null)
            interior.planes = new Array<Plane>();

        if (interior.normals == null)
            interior.normals = new Array<Point3F>();

        if (this.planehashes == null)
            this.planehashes = new Map<Int,Int>();

        var hash = hashPlane(plane);

        if (planehashes.exists(hash)) {
            return planehashes.get(hash);
        }

        var index = interior.planes.length;

        var p = new Plane(0,0);
        p.normalIndex = interior.normals.length;
        p.planeDistance = plane.d;
        interior.planes.push(p);
        interior.normals.push(new Point3F(plane.x,plane.y,plane.z));
        return index;
    }

    function ExportTexture(texture: String) {
        if (interior.materialList == null)
            interior.materialList = new Array<String>();

        if (interior.materialList.contains(texture))
            return interior.materialList.indexOf(texture);

        var index = interior.materialList.length;
        interior.materialList.push(texture);
        return index;
    }

    function ExportPoint(p: Point3F) {
        if (interior.points == null)
            interior.points = new Array<Point3F>();

        if (interior.pointVisibilities == null)
            interior.pointVisibilities = new Array<Int>();

        if (pointhashes == null)
            pointhashes = new Map<Int,Int>();

        var hash = hashPt(p);
        if (pointhashes.exists(hash)) {
            return pointhashes.get(hash);
        }

        var index = interior.points.length;
        interior.points.push(p);
        interior.pointVisibilities.push(255);
        return index;
    }

    function ExportTexGen(poly: Polygon) {
        if (interior.texGenEQs == null)
            interior.texGenEQs = new Array<TexGenEQ>();

        var v1 = poly.vertices[poly.indices[0]];
        var v2 = poly.vertices[poly.indices[1]];
        var v3 = poly.vertices[poly.indices[2]];

        var uv1 = poly.uv[poly.indices[0]];
        var uv2 = poly.uv[poly.indices[1]];
        var uv3 = poly.uv[poly.indices[2]];

        var texgen = this.solveTexGen(v1, v2, v3, uv1, uv2, uv3);  
        
        var index = interior.texGenEQs.length;
        interior.texGenEQs.push(texgen);

        return index;
    }

    function ExportWinding(poly: Polygon) {
        if (interior.windingIndices == null)
            interior.windingIndices = new Array<WindingIndex>();

        if (interior.windings == null)
            interior.windings = new Array<Int>();

        var finalwinding = [];
        for (index => value in poly.vertices) {
            finalwinding.push(this.ExportPoint(value));
        }

        var windingindex = new WindingIndex(interior.windings.length,finalwinding.length);

        interior.windingIndices.push(windingindex);
        interior.windings = interior.windings.concat(finalwinding);
    }

    function ExportSurface(poly: Polygon) {
        if (interior.surfaces == null)
            interior.surfaces = new Array<Surface>();
        if (interior.normalLMapIndices == null)
            interior.normalLMapIndices = new Array<Int>();
        if (interior.alarmLMapIndices == null)
            interior.alarmLMapIndices = new Array<Int>();

        var index = interior.surfaces.length;
        var surf = new Surface();

        surf.planeIndex = this.ExportPlanePolygon(poly);
        surf.textureIndex = this.ExportTexture(poly.material);
        surf.texGenIndex = this.ExportTexGen(poly);
        surf.surfaceFlags = 16;
        surf.fanMask = 15;
        ExportWinding(poly);
        var last = this.interior.windingIndices.pop();
        surf.windingStart = last.windingStart;
        surf.windingCount = last.windingCount;
        surf.lightCount = 0;
        surf.lightStateInfoStart = 0;
        surf.mapSizeX = 0;
        surf.mapSizeY = 0;
        surf.mapOffsetX = 0;
        surf.mapOffsetY = 0;
        interior.surfaces.push(surf);
        interior.normalLMapIndices.push(0);
        interior.alarmLMapIndices.push(0);

        return index;
    }

    function CreateLeafIndex(baseIndex: Int,isSolid: Bool) {
        if (isSolid) {
            return 0xC000 | baseIndex;
        } else {
            return 0x8000 | baseIndex;
        }
    }

    function ExportBSP(n: BBSPNode) {
        if (interior.bspNodes == null)
            interior.bspNodes = new Array<BSPNode>();
        if (interior.bspSolidLeaves == null)
            interior.bspSolidLeaves = new Array<BSPSolidLeaf>();
        if (interior.solidLeafSurfaces == null)
            interior.solidLeafSurfaces = new Array<Int>();

        if (n.isLeaf) {
            var leafindex = interior.bspSolidLeaves.length;

            var leaf = new BSPSolidLeaf(interior.solidLeafSurfaces.length,0);

            var leafPolyIndices = [];

            leafPolyIndices.push(ExportSurface(n.polygon));
            orderedPolys.push(n.polygon);

            for (i in 0...leafPolyIndices.length) {
                interior.solidLeafSurfaces.push(leafPolyIndices[i]);
                leaf.surfaceCount++;
            }

            interior.bspSolidLeaves.push(leaf);
            return CreateLeafIndex(leafindex,true);
        }
        else {
            var bspnode = new BSPNode(0,0,0,false,false,false,false);
            var nodeindex = interior.bspNodes.length;
            interior.bspNodes.push(bspnode);
            bspnode.planeIndex = ExportPlane(n.plane);
            if (n.front != null)
                bspnode.frontIndex = ExportBSP(n.front);
            else
                bspnode.frontIndex = CreateLeafIndex(0, false);
            if (n.back != null)
                bspnode.backIndex = ExportBSP(n.back);
            else 
                bspnode.backIndex = CreateLeafIndex(0, false);
            return nodeindex;
        }
    }

    function ExportConvexHulls(polys: Array<Array<Polygon>>) {
        if (interior.convexHulls == null)
            interior.convexHulls = new Array<ConvexHull>();
        if (interior.convexHullEmitStrings == null)
            interior.convexHullEmitStrings = new Array<Int>();
        if (interior.hullIndices == null)
            interior.hullIndices = new Array<Int>();
        if (interior.hullPlaneIndices == null)
            interior.hullPlaneIndices = new Array<Int>();
        if (interior.hullSurfaceIndices == null)
            interior.hullSurfaceIndices = new Array<Int>();
        if (interior.polyListPlanes == null)
            interior.polyListPlanes = new Array<Int>();
        if (interior.polyListPoints == null)
            interior.polyListPoints = new Array<Int>();
        if (interior.polyListStrings == null)
            interior.polyListStrings = new Array<Int>();
        if (interior.hullEmitStringIndices == null)
            interior.hullEmitStringIndices = new Array<Int>();

        for (polyIndex in 0...polys.length) {
            var hull = new ConvexHull();
            hull.surfaceStart = interior.hullSurfaceIndices.length;
            hull.surfaceCount = polys[polyIndex].length;

            for (i in 0...hull.surfaceCount) {
                interior.hullSurfaceIndices.push(hull.surfaceStart + i);
            }

            hull.hullStart = interior.hullIndices.length;
            hull.hullCount = 0;

            var inthullcount = 0;
            for (i in 0...polys[polyIndex].length)
                inthullcount += polys[polyIndex][i].vertices.length;

            hull.hullCount = inthullcount;

            var hullPoints = [];
            var hullpolys = [];

            hull.polyListPointStart = interior.polyListPoints.length;

            for (i in 0...polys[polyIndex].length){
                var hp = new HullPoly();
                hp.points = [];
                for (j in 0...polys[polyIndex][i].indices.length)
                {
                    var pt = this.ExportPoint(polys[polyIndex][i].vertices[polys[polyIndex][i].indices[j]]);
                    interior.hullIndices.push(pt);
                    interior.polyListPoints.push(pt);
                    hp.points.push(pt);
                    hullPoints.push(pt);
                }
                hp.planeIndex = this.ExportPlanePolygon(polys[polyIndex][i]);
                hullpolys.push(hp);
            }

            hull.polyListPlaneStart = interior.polyListPlanes.length;
            hull.planeStart = interior.hullPlaneIndices.length;

            for (i in 0...polys[polyIndex].length) {
                var planeindex = ExportPlanePolygon(polys[polyIndex][i]);
                interior.polyListPlanes.push(planeindex);
                interior.hullPlaneIndices.push(planeindex);
            }

            var minx = 1e8;
            var miny = 1e8;
            var minz = 1e8;
            var maxx = -1e8;
            var maxy = -1e8;
            var maxz = -1e8;

            for (i in 0...polys[polyIndex].length)
            {
                for (j in 0...polys[polyIndex][i].vertices.length)
                {
                    var v = polys[polyIndex][i].vertices[j];
                    if (v.x < minx)
                        minx = v.x;
                    if (v.y < miny)
                        miny = v.y;
                    if (v.z < minz)
                        minz = v.z;
                    if (v.x > maxx)
                        maxx = v.x;
                    if (v.y > maxy)
                        maxy = v.y;
                    if (v.z > maxz)
                        maxz = v.z;
                }
            }

            hull.minX = minx;
            hull.minY = miny;
            hull.minZ = minz;
            hull.maxX = maxx;
            hull.maxY = maxy;
            hull.maxZ = maxz;

            interior.hullEmitStringIndices.push(0);

            interior.convexHulls.push(hull);

        }
        interior.polyListStrings.push(0);
        interior.convexHullEmitStrings.push(0);
    }

    function ExportCoordBins() {
        if (interior.coordBins == null)
            interior.coordBins = new Array<CoordBin>();

        if (interior.coordBinIndices == null)
            interior.coordBinIndices = new Array<Int>();

        for (i in 0...256)
            interior.coordBins.push(new CoordBin());

        for (i in 0...16)
        {
            var minX = interior.boundingBox.minX;
            var maxX = interior.boundingBox.minX;
            minX += i * ((interior.boundingBox.maxX - interior.boundingBox.minX) / 16);
            maxX += (i + 1) * ((interior.boundingBox.maxX - interior.boundingBox.minX) / 16);
            for (j in 0...16)
            {
                var minY = interior.boundingBox.minY;
                var maxY = interior.boundingBox.minY;
                minY += j * ((interior.boundingBox.maxY - interior.boundingBox.minY) / 16);
                maxY += (j + 1) * ((interior.boundingBox.maxY - interior.boundingBox.minY) / 16);

                var binIndex = (i * 16) + j;
                var cb = interior.coordBins[binIndex];
                cb.binStart = interior.coordBinIndices.length;                   

                for (k in 0...interior.convexHulls.length)
                {
                    var hull = interior.convexHulls[k];

                    if (!(minX > hull.maxX || maxX < hull.minX || maxY < hull.minY || minY > hull.maxY))
                    {
                        interior.coordBinIndices.push(k);
                    }
                }
                cb.binCount = interior.coordBinIndices.length - cb.binStart;

                interior.coordBins[binIndex] = cb;
            }
        }
        
    }

    public function Build() {
        var bspnodes = [];
        for (index => poly in polygons) {
            var leafnode = new BBSPNode();
            leafnode.isLeaf = true;
            leafnode.polygon = poly;
            var n = new BBSPNode();
            n.front = leafnode;
            n.plane = PlaneF.PointNormal(poly.vertices[0],poly.normal);
            bspnodes.push(n);
        }

        // TODO BSPBUILDER
        // var BSPBuilder = new BSPBuilder();
        // var root = BSPBuilder.BuildBSPRecursive(bspnodes);

        var root = BSPBuilder.BuildBSPRecursive(bspnodes);

        var interior = new Interior();

        orderedPolys = new Array<Polygon>();
        ExportBSP(root);

        var groupedPolys = new Array<Array<Polygon>>();

        var fullpolycount = Math.floor(orderedPolys.length / 8);
        var rem = orderedPolys.length % 8;

        var i = 0;
        // Can't find a for loop with variable step so bruh
        while (i < orderedPolys.length - rem) {
            var polylist = new Array<Polygon>();
            for (j in 0...8)
                polylist.push(orderedPolys[i + j]);

            groupedPolys.push(polylist);
            i += 8;
        }
        var lastpolys = new Array<Polygon>();
        for (i in (orderedPolys.length - rem)...orderedPolys.length) {
            lastpolys.push(orderedPolys[i]);
        }
        if (lastpolys.length != 0)
            groupedPolys.push(lastpolys);

        ExportConvexHulls(groupedPolys);

        if (interior.zones == null)
            interior.zones = new Array<Zone>();
        var z = new Zone();
        z.portalStart = 0;
        z.portalCount = 0;
        z.surfaceStart = 0;
        z.surfaceCount = interior.surfaces.length;

        interior.zones.push(z);

        if (interior.zoneSurfaces == null)
            interior.zoneSurfaces = new Array<Int>();

        for (i in 0...interior.surfaces.length)
            interior.zoneSurfaces.push(i);

        interior.boundingBox = GetBoundingBox();
        interior.boundingSphere = GetBoundingSphere();

        ExportCoordBins();

        interior.materialListVersion = 1;
        interior.coordBinMode = 0;
        interior.baseAmbientColor = [1,1,1,1];
        interior.alarmAmbientColor = [1,1,1,1];
        interior.detailLevel = 0;
        interior.minPixels = 250;
        interior.hasAlarmState = 0;
        interior.numLightStateEntries = 0;
        interior.animatedLights = new Array<AnimatedLight>();
        interior.lightMaps = new Array<LightMap>();
        interior.lightStates = new Array<LightState>();
        interior.nameBuffer = new Array<Int>();
        interior.nullSurfaces = new Array<NullSurface>();
        interior.portals = new Array<Portal>();
        interior.stateDataBuffers = new Array<Int>();
        interior.stateDataFlags = 0;
        interior.stateDatas = new Array<StateData>();
        interior.texMatIndices = new Array<Int>();
        interior.texMatrices = new Array<TexMatrix>();
        interior.texNormals = new Array<Point3F>();
        interior.zonePortalList = new Array<Int>();
        interior.extendedLightMapData = 0;

        return interior;
    }

    function GetBoundingBox()
    {
        var minx = 1e08;
        var miny = 1e08;
        var minz = 1e08;
        var maxx = -1e08;
        var maxy = -1e08;
        var maxz = -1e08;

        for (i => poly in polygons)
        {
            for (j => v in poly.vertices)
            {
                if (v.x < minx)
                    minx = v.x;
                if (v.y < miny)
                    miny = v.y;
                if (v.z < minz)
                    minz = v.z;
                if (v.x > maxx)
                    maxx = v.x;
                if (v.y > maxy)
                    maxy = v.y;
                if (v.z > maxz)
                    maxz = v.z;
            }
        }

        var box = new Box3F();
        box.minX = minx;
        box.minY = miny;
        box.minZ = minz;
        box.maxX = maxx;
        box.maxY = maxy;
        box.maxZ = maxz;

        return box;

    }

    function GetBoundingSphere()
    {
        var box = interior.boundingBox;
        var center = new Point3F(box.maxX + box.minX,box.maxY + box.minY, box.minZ + box.maxZ);
        center = center.scalarDiv(2);

        var r = new Point3F(box.maxX - center.x,box.maxY - center.y,box.minZ - center.z);

        var sphere = new Spheref();
        sphere.originX = center.x;
        sphere.originY = center.y;
        sphere.originZ = center.z;
        sphere.radius = r.length();

        return sphere;
    }

    function solveTexGen(p1: Point3F,p2: Point3F,p3: Point3F,uv1: Point2F, uv2: Point2F,uv3: Point2F) {
        var m = [[p1.x,p1.y,p1.z],[p2.x,p2.y,p2.z],[p3.x,p3.y,p3.z]];
        var determinant = p1.x * (p2.y * p3.z - p3.y * p2.z) + p1.y * (p2.z * p3.x - p3.z * p2.x) + p1.z * (p2.y * p3.z - p2.z * p3.y);

        var adj = [[(m[1][1] * m[2][2] - m[2][1] * m[1][2]), (m[2][1] * m[0][2] - m[2][2] * m[0][1]), (m[0][1] * m[1][2] - m[1][1] * m[0][2])],
                   [(m[1][2] * m[2][0] - m[2][2] * m[1][0]), (m[0][0] * m[2][2] - m[0][2] * m[2][0]), (m[0][2] * m[1][0] - m[1][2] * m[0][0])],
                   [(m[1][0] * m[2][1] - m[2][0] * m[1][1]), (m[2][0] * m[0][1] - m[2][1] * m[0][0]), (m[0][0] * m[1][1] - m[1][0] * m[0][1])]];

        var xsolution = new Point3F(adj[0][0] * uv1.x + adj[0][1] * uv2.x + adj[1][2] * uv3.x,adj[1][0] * uv1.x + adj[1][1] * uv2.x + adj[1][2] * uv3.x,adj[2][0] * uv1.x + adj[2][1] * uv2.x + adj[2][2] * uv3.x);
        var ysolution = new Point3F(adj[0][0] * uv1.y + adj[0][1] * uv2.y + adj[1][2] * uv3.y,adj[1][0] * uv1.y + adj[1][1] * uv2.y + adj[1][2] * uv3.y,adj[2][0] * uv1.y + adj[2][1] * uv2.y + adj[2][2] * uv3.y);

        if (determinant != 0) {
            xsolution = xsolution.scalarDiv(determinant);
            ysolution = ysolution.scalarDiv(determinant);
        }

        var texgen = new TexGenEQ();
        texgen.planeX = new PlaneF(xsolution.x,xsolution.y,xsolution.z,0);
        texgen.planeY = new PlaneF(ysolution.x,ysolution.y,ysolution.z,0);
        return texgen;

    }


}