package com.editor.module_avg.vo.sec
{
	import com.editor.module_avg.manager.AVGManager;
	import com.editor.module_avg.vo.AVGConfigVO;

	public class AVGSectionListVO
	{
		public function AVGSectionListVO()
		{
		}
		
		public var section_ls:Array = [];
		
		public function create():void
		{
			var d:AVGSectionItemVO = new AVGSectionItemVO();
			d.index = section_ls.length+1; 
			d.name = "剧情"+d.index;
			section_ls.push(d);
		}
		
		public function copy(d:AVGSectionItemVO):void
		{
			var d:AVGSectionItemVO = d.cloneObject() as AVGSectionItemVO;
			d.index = section_ls.length+1; 
			d.name = "剧情"+d.index;
			section_ls.push(d);
		}
		
		public function removeSection(d:AVGSectionItemVO):void
		{
			for(var i:int=0;i<section_ls.length;i++){
				if(AVGSectionItemVO(section_ls[i]).index == d.index){
					section_ls.splice(i,1);
					reflashAllSectionIndex()
					break;
				}
			}
		}
		
		public function getSection(n:String):AVGSectionItemVO
		{
			for(var i:int=0;i<section_ls.length;i++){
				if(AVGSectionItemVO(section_ls[i]).name == n){
					return section_ls[i] as AVGSectionItemVO
				}
			}
			return null;
		}
		
		public function getSectionIndex(n:String):int
		{
			for(var i:int=0;i<section_ls.length;i++){
				if(AVGSectionItemVO(section_ls[i]).name == n){
					return i
				}
			}
			return -1;
		}
		
		public function reflashAllSectionIndex():void
		{
			for(var i:int=0;i<section_ls.length;i++){
				AVGSectionItemVO(section_ls[i]).index = i+1;
			}
		}
		
		public function setXML(x:XML):void
		{
			AVGConfigVO.instance.width = int(x.@w);
			AVGConfigVO.instance.height = int(x.@h);
			for each(var iX:XML in x.s)
			{
				var note:AVGSectionItemVO = new AVGSectionItemVO(iX);
				section_ls.push(note);
			}		
		}
		
		public function getXML():String
		{
			var x:String = '<?xml version="1.0" encoding="UTF-8"?>'
			x += '<l ';
			x += 'w="'+AVGConfigVO.instance.width+'" '
			x += 'h="'+AVGConfigVO.instance.height+'" '
			x += '>';
			for(var i:int=0;i<section_ls.length;i++){
				x += AVGSectionItemVO(section_ls[i]).getXML();
			}
			x += "</l>"
			return x;
		}
		
		
	}
}