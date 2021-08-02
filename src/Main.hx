package;

import builder.octree.OctreePoint;
import builder.octree.Octree;
import haxe.crypto.Adler32;
import io.BytesWriter;
import math.Point3F;

class Main {
	static function hashPt(p:Point3F) {
		var b = new BytesWriter();
		b.writeFloat(p.x);
		b.writeFloat(p.y);
		b.writeFloat(p.z);
		return Adler32.make(b.getBuffer());
	}

	public static function main() {
		#if sys
		var dif = Dif.Load("D:\\repos\\Dif.Net\\DifTools\\bin\\Debug\\netcoreapp3.1\\escher.dif");
		trace(dif);
		// var l = [];

		// for (i in 0...10000) {
		//     l.push(new OctreePoint(new Point3F(Math.random() * 100,Math.random() * 100, Math.random() * 100),true));
		// }

		// var oc = new Octree(l);

		// var pairs = new Array<Array<Point3F>>();
		// var containedlist = new Map<Int,Bool>();
		// for (pt in l) {
		//     if (containedlist.exists(hashPt(pt.point))) continue;

		//     oc.remove(pt.point);

		//     var nn = oc.knn(pt.point,1);

		//     if (nn.length > 0) {
		//         oc.remove(nn[0].point);
		//         containedlist.set(hashPt(nn[0].point),true);
		//         pairs.push([pt.point, nn[0].point]);
		//     }

		//     containedlist.set(hashPt(pt.point),true);
		// }
		#end
	}
}
