package io;

import haxe.io.Bytes;

class BytesReader {
	var bytes:Bytes;
	var position:Int;

	public function new(bytes:Bytes) {
		this.bytes = bytes;
		this.position = 0;
	}

	public function readInt32() {
		if (position + 4 > bytes.length) {
			throw new haxe.io.Eof();
		}
		var b = bytes.getInt32(position);
		position += 4;
		return b;
	}

	public function readInt16() {
		if (position + 2 > bytes.length) {
			throw new haxe.io.Eof();
		}
		var b = bytes.getUInt16(position);
		position += 2;
		return b;
	}

	public function readUInt16() {
		if (position + 2 > bytes.length) {
			throw new haxe.io.Eof();
		}
		var b = bytes.getUInt16(position);
		position += 2;
		return b;
	}

	public function readByte() {
		if (position + 1 > bytes.length) {
			throw new haxe.io.Eof();
		}
		var b = bytes.get(position);
		position += 1;
		return b;
	}

	public function readStr() {
		var len = this.readByte();
		if (position + len > bytes.length) {
			throw new haxe.io.Eof();
		}
		var str = "";
		var reading = true;
		for (i in 0...len) {
			var ch = this.readByte();
			if (ch == 0) {
				reading = false;
			}
			if (reading) {
				str += String.fromCharCode(ch);
			}
		}
		return str;
	}

	public function readFloat() {
		if (position + 4 > bytes.length) {
			throw new haxe.io.Eof();
		}
		var b = bytes.getFloat(position);
		position += 4;
		return b;
	}

	public function tell() {
		return position;
	}

	public function seek(pos) {
		position = pos;
	}
}
