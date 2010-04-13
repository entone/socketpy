package ent.utils
{
	public class numbers{
		
		static public function parse_seconds(seconds:Number):String{
			var s:* = Math.round(seconds % 60) < 10 ? "0" + Math.round((seconds % 60)) : Math.round(seconds % 60);
			var m:* = Math.round((seconds / 60)) < 10 ? "0"+ Math.round((seconds / 60)) : Math.round(seconds / 60);
			var h:* = Math.round(m / 60) < 10 ? "0" + Math.round((m / 60)) : Math.round(m / 60);
			return h+":"+m+":"+s;
		}
	}
}