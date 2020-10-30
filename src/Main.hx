package;

import builder.kdtree.KdTree;
import math.Point3F;

class Main
{
    public static function main() {
        #if sys

        var kdtree = new KdTree<Int>(3);   
        
        for (i in 0...5) {
            kdtree.Add([0,0,(100 - (10 * i))],1);
        }

        var pts = kdtree.GetNearestNeighbours([0, 0, 100],2);
        for (index => value in pts) {
            trace(value.point[0], value.point[1], value.point[2]);
            kdtree.RemoveAt(value.point);
        }

        trace("a");

        var pts = kdtree.GetNearestNeighbours([0, 0, 101],2);
        for (index => value in pts) {
            trace(value.point[0], value.point[1], value.point[2]);
        }

        #end

    }
}