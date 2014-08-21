package com.editor.d3.pop.curveEditor
{
	import com.sandy.math.ArrayCollection;
	import com.sandy.math.QueueList;
	import com.sandy.math.QueueNode;

	public class CurveEditorData
	{
		public function CurveEditorData()
		{
		}
		
		public static var queue:QueueList = new QueueList();
		
		public static function addPoint(d:CurveEditorPointData):QueueNode
		{
			var n:QueueNode = queue.append(d);
			sort();
			return n
		}
		
		public static function sort():void
		{
			var out:Array = [];
			var a:ArrayCollection = queue.getList();
			for(var i:int=0;i<a.length;i++){
				out.push(QueueNode(a.getItemAt(i)).data as CurveEditorPointData);
			}
			out = out.sortOn("x",Array.NUMERIC);
			queue.clear();
			for(i=0;i<out.length;i++){
				queue.append(out[i]);
			}
		}
	}
}