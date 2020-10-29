package builder;

import math.Point3F;
import math.PlaneF;

class BBSPNode
{
    public var isLeaf: Bool = false;
    public var plane: PlaneF = new PlaneF();
    public var front: BBSPNode;
    public var back: BBSPNode;
    public var polygon: Polygon;
    public var center: Point3F;

    public function new() {
        
    }

    public function calculateCenter() {
        if (this.isLeaf) {
            var centroid = new Point3F();
            for (index => value in this.polygon.vertices) {
                centroid = centroid.add(value);
            }
            centroid = centroid.scalarDiv(this.polygon.vertices.length);

            this.center = centroid;
        } else {
            var c = 0;
            var avgcenter = new Point3F();
            if (this.back != null) {
                if (this.back.center == null)
                    this.back.calculateCenter();

                avgcenter = avgcenter.add(this.back.center);
                c++;
            }
            if (this.front != null) {
                if (this.front.center == null)
                    this.front.calculateCenter();

                avgcenter = avgcenter.add(this.front.center);
                c++;
            }

            avgcenter = avgcenter.scalarDiv(c);
            this.center = avgcenter;
        }
    }

    public function gatherPolygons() {
        var ret = [];
        if (this.isLeaf)
            ret.push(this.polygon)
        else {
            if (this.front != null)
                ret = ret.concat(this.front.gatherPolygons());
            if (this.back != null)
                ret = ret.concat(this.back.gatherPolygons());
        }
        return ret;
    }
}