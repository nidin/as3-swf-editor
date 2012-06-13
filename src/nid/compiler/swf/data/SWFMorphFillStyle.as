﻿package nid.compiler.swf.data
{
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.utils.ColorUtils;
	import nid.compiler.swf.utils.MatrixUtils;
	
	public class SWFMorphFillStyle
	{
		public var type:uint;

		public var startColor:uint;
		public var endColor:uint;
		public var startGradientMatrix:SWFMatrix;
		public var endGradientMatrix:SWFMatrix;
		public var gradient:SWFMorphGradient;
		public var bitmapId:uint;
		public var startBitmapMatrix:SWFMatrix;
		public var endBitmapMatrix:SWFMatrix;
		
		public function SWFMorphFillStyle(data:SWFData = null, level:uint = 1) {
			if (data != null) {
				parse(data, level);
			}
		}
		
		public function parse(data:SWFData, level:uint = 1):void {
			type = data.readUI8();
			switch(type) {
				case 0x00:
					startColor = data.readRGBA();
					endColor = data.readRGBA();
					break;
				case 0x10:
				case 0x12:
					startGradientMatrix = data.readMATRIX();
					endGradientMatrix = data.readMATRIX();
					gradient = data.readMORPHGRADIENT(level);
					break;
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
					bitmapId = data.readUI16();
					startBitmapMatrix = data.readMATRIX();
					endBitmapMatrix = data.readMATRIX();
					break;
				default:
					throw(new Error("Unknown fill style type: 0x" + type.toString(16)));
			}
		}
		
		public function publish(data:SWFData, level:uint = 1):void {
			data.writeUI8(type);
			switch(type) {
				case 0x00:
					data.writeRGBA(startColor);
					data.writeRGBA(endColor);
					break;
				case 0x10:
				case 0x12:
					data.writeMATRIX(startGradientMatrix);
					data.writeMATRIX(endGradientMatrix);
					data.writeMORPHGRADIENT(gradient, level);
					break;
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
					data.writeUI16(bitmapId);
					data.writeMATRIX(startBitmapMatrix);
					data.writeMATRIX(endBitmapMatrix);
					break;
				default:
					throw(new Error("Unknown fill style type: 0x" + type.toString(16)));
			}
		}
		
		public function getMorphedFillStyle(ratio:Number = 0):SWFFillStyle {
			var fillStyle:SWFFillStyle = new SWFFillStyle();
			fillStyle.type = type;
			switch(type) {
				case 0x00:
					fillStyle.rgb = ColorUtils.interpolate(startColor, endColor, ratio);
					break;
				case 0x10:
				case 0x12:
					fillStyle.gradientMatrix = MatrixUtils.interpolate(startGradientMatrix, endGradientMatrix, ratio);
					fillStyle.gradient = gradient.getMorphedGradient(ratio);
					break;
				case 0x40:
				case 0x41:
				case 0x42:
				case 0x43:
					fillStyle.bitmapId = bitmapId;
					fillStyle.bitmapMatrix = MatrixUtils.interpolate(startBitmapMatrix, endBitmapMatrix, ratio);
					break;
			}
			return fillStyle;
		}
		
		public function toString():String {
			var str:String = "[SWFMorphFillStyle] Type: " + type.toString(16);
			switch(type) {
				case 0x00: str += " (solid), StartColor: " + startColor.toString(16) + ", EndColor: " + endColor.toString(16); break;
				case 0x10: str += " (linear gradient), Gradient: " + gradient; break;
				case 0x12: str += " (radial gradient), Gradient: " + gradient; break;
				case 0x40: str += " (repeating bitmap), BitmapID: " + bitmapId; break;
				case 0x41: str += " (clipped bitmap), BitmapID: " + bitmapId; break;
				case 0x42: str += " (non-smoothed repeating bitmap), BitmapID: " + bitmapId; break;
				case 0x43: str += " (non-smoothed clipped bitmap), BitmapID: " + bitmapId; break;
			}
			return str;
		}
	}
}
