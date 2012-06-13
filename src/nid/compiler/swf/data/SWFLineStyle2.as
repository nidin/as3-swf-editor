﻿package nid.compiler.swf.data
{
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.data.consts.LineCapsStyle;
	import nid.compiler.swf.data.consts.LineJointStyle;
	
	public class SWFLineStyle2 extends SWFLineStyle
	{
		public function SWFLineStyle2(data:SWFData = null, level:uint = 1) {
			super(data, level);
		}
		
		override public function parse(data:SWFData, level:uint = 1):void {
			width = data.readUI16();
			startCapsStyle = data.readUB(2);
			jointStyle = data.readUB(2);
			hasFillFlag = (data.readUB(1) == 1);
			noHScaleFlag = (data.readUB(1) == 1);
			noVScaleFlag = (data.readUB(1) == 1);
			pixelHintingFlag = (data.readUB(1) == 1);
			data.readUB(5);
			noClose = (data.readUB(1) == 1);
			endCapsStyle = data.readUB(2);
			if (jointStyle == LineJointStyle.MITER) {
				miterLimitFactor = data.readFIXED8();
			}
			if (hasFillFlag) {
				fillType = data.readFILLSTYLE(level);
			} else {
				color = data.readRGBA();
			}
		}
		
		override public function publish(data:SWFData, level:uint = 1):void {
			data.writeUI16(width);
			data.writeUB(2, startCapsStyle);
			data.writeUB(2, jointStyle);
			data.writeUB(1, hasFillFlag ? 1 : 0);
			data.writeUB(1, noHScaleFlag ? 1 : 0);
			data.writeUB(1, noVScaleFlag ? 1 : 0);
			data.writeUB(1, pixelHintingFlag ? 1 : 0);
			data.writeUB(5, 0);
			data.writeUB(1, noClose ? 1 : 0);
			data.writeUB(2, endCapsStyle);
			if (jointStyle == LineJointStyle.MITER) {
				data.writeFIXED8(miterLimitFactor);
			}
			if (hasFillFlag) {
				data.writeFILLSTYLE(fillType, level);
			} else {
				data.writeRGBA(color);
			}
		}
		
		override public function toString():String {
			var str:String = "[SWFLineStyle2] Width: " + width + ", " +
				"StartCaps: " + LineCapsStyle.toString(startCapsStyle) + ", " +
				"EndCaps: " + LineCapsStyle.toString(endCapsStyle) + ", " +
				"Joint: " + LineJointStyle.toString(jointStyle);
			if (hasFillFlag) {
				str += ", Fill: " + fillType.toString();
			} else {
				str += ", Color: " + color.toString(16);
			}
			return str;
		}
	}
}
