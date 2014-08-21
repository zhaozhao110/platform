package com.editor.d3.view.attri.group.comp
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.group.D3AttriGroupCell;
	import com.editor.d3.view.attri.group.ID3AttriGroup;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.math.HashMap;

	public class D3AttriGroup extends UIVBox implements ID3AttriGroup
	{
		public function D3AttriGroup()
		{
			super();
			name = "D3AttriGroupViewBase"
			percentWidth = 100;
			height = 200;
			padding = 2;
			paddingLeft = 5;
			styleName = "uicanvas";
		}
		
		private var _comp:D3ObjectBase;
		public function get comp():D3ObjectBase
		{
			return _comp;
		}
		public function set comp(value:D3ObjectBase):void
		{
			_comp = value;
		}
		
		//全部
		private var _attri_ls:Array = [];
		public function get attri_ls():Array
		{
			return _attri_ls;
		}
		public function set attri_ls(value:Array):void
		{
			_attri_ls = value;
		}
		
		//当前显示的
		private var _curr_attri_map:HashMap = new HashMap();
		public function get curr_attri_map():HashMap
		{
			return _curr_attri_map;
		}
		public function set curr_attri_map(value:HashMap):void
		{
			_curr_attri_map = value;
		}
		
		public var curr_group_map:HashMap = new HashMap();
		public var group_map:HashMap = new HashMap();
		
		private var cont:UIVBox;
		
		private function _createCont():void
		{
			if(cont == null){
				cont = new UIVBox();
				cont.percentWidth = 100;
				cont.verticalGap = 1;
				cont.name = "D3AttriGroupViewBase_cont"
				addChild(cont);
			}
		}
		
		//创建组
		public function createGroupView(g:D3GroupItemVO):void
		{
			_createCont()
			
			var gv:D3AttriGroupCell = group_map.find(g.id.toString());
			if(gv == null){
				gv = new D3AttriGroupCell();
				gv.target = this;
				group_map.put(g.id.toString(),gv);
			}
			if(!cont.contains(gv)) cont.addChild(gv);
			gv.createAttris(g)
			curr_group_map.put(g.id.toString(),gv);
		}
		
		public function reflashAllAttri():void
		{
			for(var key:String in curr_attri_map.getContent()){
				var d:ID3ComBase = curr_attri_map.find(key) as ID3ComBase;
				d.comp = comp;
				d.setValue();
			}
		}
		
		public function comReflash(d:ID3ComBase):void
		{
			comp.proccess.comReflash(d);
		}
		
		public function maxGroupCell(g:D3AttriGroupCell):void
		{
			
		}
		
		public function findGroupCell(d:D3GroupItemVO):D3AttriGroupCell
		{
			return curr_group_map.find(d.id.toString()) as D3AttriGroupCell;
		}
		
		public function removeGroup(d:D3AttriGroupCell):void
		{
			
		}
		
	}
}