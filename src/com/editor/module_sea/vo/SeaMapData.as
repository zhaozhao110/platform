package com.editor.module_sea.vo
{
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.vo.res.SeaMapResInfoItemVO;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;

	public class SeaMapData
	{
		public function SeaMapData()
		{
		}
		
		public var mapWidth:Number;//地图宽度
		public var mapHeight:Number;//地图高度
		public var xml:XML;
		
		public var backImage_file:String = "1.jpg";
		
		
		
		public function parserXML(x:XML):void
		{
			mapWidth = int(x.@mapW);
			mapHeight = int(x.@mapH);
			backImage_file = x.@backImg;
			if(StringTWLUtil.isWhitespace(backImage_file)) backImage_file = "1.jpg"
			
			var libs:String = x.@libs;
			if(!StringTWLUtil.isWhitespace(libs)){
				var lib_a:Array = libs.split(",");
				for(var i:int=0;i<lib_a.length;i++){
					addLibSource(SeaMapModuleProxy.instance.resInfo_ls.getCloneResInfoItemById(int(lib_a[i])));
				}
			}
				
			var levl:XML = XML(x.child("l")[0])
			for each(var p:XML in levl.i){
				var d:SeaMapLevelVO = new SeaMapLevelVO(p);
				level_ls.push(d);
			}
			
			addBackImgLevel()
			
			var items:XML = XML(x.child("i")[0]);
			for each(p in items.i){
				var dd:SeaMapItemVO = new SeaMapItemVO(p);
				getLevel(dd.group).addItem(dd);
			}
		}
		
		public function addBackImgLevel():void
		{
			if(level_ls.length == 0){
				var d:SeaMapLevelVO = new SeaMapLevelVO();
				d.name = "地图"
				d.index = 0;
				level_ls.push(d);
			}
		}
		
		public function sortLevel():void
		{
			level_ls = level_ls.sortOn("container_index",Array.NUMERIC);
		}
		
		public var level_ls:Array = [];
		public var libs_ls:Array = [];
		
		
		
		public function getLevel(g:int):SeaMapLevelVO
		{
			for(var i:int=0;i<level_ls.length;i++){
				if(SeaMapLevelVO(level_ls[i]).index == g){
					return SeaMapLevelVO(level_ls[i]);
				}
			}
			return null;
		}
		
		public function createItem(d:SeaMapItemVO):void
		{
			getLevel(d.group).addItem(d);
		}
		
		public function getArrayByRedId(g:int):Array
		{
			var a:Array = [];
			for(var i:int=0;i<level_ls.length;i++){
				var b:Array = SeaMapLevelVO(level_ls[i]).getArrayByRedId(g);
				if(b.length > 0){
					a = a.concat(b);
				}
			}
			return a;
		}
		
		public function createNewLevel():SeaMapLevelVO
		{
			var d:SeaMapLevelVO = new SeaMapLevelVO();
			d.name = "层次"
			d.index = level_ls.length;
			level_ls.push(d);
			return d;
		}
		
		public function removeLevel(d:SeaMapLevelVO):void
		{
			var a:SeaMapLevelVO = getLevel(d.index);
			if(a!=null){
				a.removeItems();
			}
			level_ls.splice(d.index,1);
		}
		
		public function addLibSource(d:SeaMapResInfoItemVO):void
		{
			if(d == null) return ;
			if(getLibSource(d.id)==null){
				var dd:SeaMapItemVO = new SeaMapItemVO();
				dd.resItem = d;
				dd.id = d.id;
				libs_ls.push(dd);
			}
		}
		
		private function getLibSource(i:int):SeaMapItemVO
		{
			for(var i:int=0;i<libs_ls.length;i++)
			{
				if(SeaMapItemVO(libs_ls[i]).id == i){
					return libs_ls[i] as SeaMapItemVO;
				}
			}
			return null;
		}
		
		private function getLibs():String
		{
			var a:Array = [];
			for(var i:int=0;i<libs_ls.length;i++)
			{
				a.push(SeaMapItemVO(libs_ls[i]).id);
			}
			return a.join(",");
		}
		
		public function getItemList():Array
		{
			var a:Array = [];
			for(var i:int=0;i<level_ls.length;i++){
				a = a.concat(SeaMapLevelVO(level_ls[i]).item_ls)
			}
			a = a.sortOn("id",Array.NUMERIC)
			return a;
		}
		
		public function save():String
		{
			var x:String = '<m i="1" mapW="'+ mapWidth + '" '; 
			x += 'mapH="'+mapHeight + '" '
			x += 'libs="'+getLibs()+'" >'
			x += '<l>'
			for(var i:int=0;i<level_ls.length;i++){
				x += SeaMapLevelVO(level_ls[i]).save();
			}
			x += '</l>'
			x += '<i>'
			for(i=0;i<level_ls.length;i++){
				x += SeaMapLevelVO(level_ls[i]).saveItems();
			}
			x += '</i>'
			x += '</m>'
			return x;
		}
		
	}
}