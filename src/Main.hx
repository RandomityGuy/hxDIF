package;

import builder.KDTree.KdPoint;
import builder.KDTree.KdTree;
import math.Point3F;

class Main
{
    public static function main() {
        #if sys
        var kdpts = new Array<KdPoint<Int>>();
        for (i in 0...5) {
            var obj = new KdPoint(new Point3F(0,0,100 - (10 * i)),1);
            kdpts.push(obj);
        }

        var kdtree = new KdTree(kdpts,(p1,p2) -> (p2.sub(p1).length()));      

        var pts = kdtree.nearest(new Point3F(0,0,100),2,1e08);
        for (index => value in pts) {
            trace(value.item0.point.x,value.item0.point.y,value.item0.point.z);
        }

        trace("a");

        var pts = kdtree.nearest(new Point3F(0,0,101),3,1e08);
        for (index => value in pts) {
            trace(value.item0.point.x,value.item0.point.y,value.item0.point.z);
        }

        #end
    }
}