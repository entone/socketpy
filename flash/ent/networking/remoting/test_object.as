package ent.networking.remoting
{
	public class test_object extends Object{
		public var my_var:String;
		public var ar:Array;
		public function test_object(a:String):void{
			my_var = a;
			ar = ['test', 1.234, "test", new Date()];
		}
	}
}