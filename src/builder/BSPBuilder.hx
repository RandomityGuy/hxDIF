package builder;

import builder.KDTree.Pair;
import math.PlaneF;
import builder.KDTree.KdPoint;
import builder.KDTree.KdTree;
import haxe.crypto.Adler32;
import io.BytesWriter;
import math.Point3F;

class BSPBuilder {

    static function hashPt(p: Point3F) {
        var b = new BytesWriter();
        b.writeFloat(p.x);
        b.writeFloat(p.y);
        b.writeFloat(p.z);
        return Adler32.make(b.getBuffer());
    }

    static function distance(p1: Point3F,p2: Point3F)
        return (p1.sub(p2)).length();

    static function chooseNonZeroDistance(res: Array<Pair<KdPoint<BBSPNode>,Float>>) {
        for (index => value in res) {
            if (value.item1 != 0) return value;
        }
        return null;
    }

    static function BuildBSP(nodes: Array<BBSPNode>) {

        var pts = new Array<KdPoint<BBSPNode>>();

        for (index => value in nodes) {
            value.calculateCenter();
        }

        for (index => value in nodes) {
            var pt = new KdPoint(value.center,value);
            pts.push(pt);
        }

        var kdtree = new KdTree(pts,distance);

        var newnodes = [];

        var containednodelist = new Map<Int,Bool>();

        var previousnode = null;

        for (i in 0...nodes.length) {
            if (containednodelist.exists(hashPt(nodes[i].center)))
                continue;

            if (i == nodes.length - 1) {
                newnodes.push(nodes[i]);
                break;
            }

            var node = nodes[i];
            var pt = node.center;

            var nn = kdtree.nearest(pt,2,1e08);
            
            var nb: BBSPNode;

            if (nn.length == 0) {
                nb = previousnode;
            } else {
                var nearest = chooseNonZeroDistance(nn);
                if (nearest == null) {
                    nb = previousnode;                  
                } else {
                    previousnode = nearest.item0.obj;
                    nb = nearest.item0.obj;
                    containednodelist.set(hashPt(nb.center),true);
                }
            }

            var center = pt.add(nb.center).scalarDiv(2);

            var p = PlaneF.PointNormal(center,nb.center.sub(pt));

            var newnode = new BBSPNode();
            newnode.center = center;
            newnode.front = nb;
            newnode.back = node;
            newnode.plane = p;

            newnodes.push(newnode);
        }

        return newnodes;
    }

    public static function BuildBSPRecursive(nodes: Array<BBSPNode>) {
        while (nodes.length > 1)
            nodes = BuildBSP(nodes);
        return nodes[0];
    }
}