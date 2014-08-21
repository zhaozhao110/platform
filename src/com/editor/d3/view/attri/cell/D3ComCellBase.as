package com.editor.d3.view.attri.cell
{
	import com.editor.component.containers.UIVBox;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.D3ComTypeManager;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.group.D3AttriGroupCell;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;

	public class D3ComCellBase extends UIVBox implements ID3ComBase
	{
		public function D3ComCellBase()
		{
			super();
			create_init();
		}
		
		////////////////////////////// attri ///////////////////////////////
		
		private var _target:D3AttriGroupCell;
		public function get target():D3AttriGroupCell
		{
			return _target;
		}
		public function set target(value:D3AttriGroupCell):void
		{
			_target = value;
		}
		
		private var _item:D3ComAttriItemVO;
		public function get item():D3ComAttriItemVO
		{
			return _item;
		}
		public function set item(value:D3ComAttriItemVO):void
		{
			_item = value;
		}

		private var _group:D3GroupItemVO;
		public function get group():D3GroupItemVO
		{
			return _group;
		}
		public function set group(value:D3GroupItemVO):void
		{
			_group = value;
			getAttris()
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
		
		private var _reflashFun:Function;
		public function get reflashFun():Function
		{
			return _reflashFun;
		}
		public function set reflashFun(value:Function):void
		{
			_reflashFun = value;
		}

		public var getCompValue_f:Function;

		public function get key():String
		{
			return item.key;
		}
		public function get attriId():int
		{
			return item.id;
		}

		protected var att_ls:Array;
		protected var att_vls:Array = [];
		
		
		
		//////////////////////////////// function //////////////////////////////
		
		protected function create_init():void
		{
			width = 260;
			height = 50;
			styleName = "uicanvas"
			mouseChildren = true;
			mouseEnabled = true;
		}
		
		private function getAttris():void
		{
			if(group == null) return ;
			if(StringTWLUtil.isWhitespace(group.attri)) return; 
			var a:Array = group.attri.split(",");
			att_ls = [];
			for(var i:int;i<a.length;i++){
				var attid:int = int(a[i]);
				if(attid > 0){
					var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemById(attid.toString());
					att_ls.push(d);
				}
			}
			att_ls.sortOn("key");
		}
		
		protected function createAttris():void
		{
			for(var i:int=0;i<att_ls.length;i++){
				_createItemRenderer(att_ls[i] as D3ComAttriItemVO)
			}
		}
		
		protected function _createItemRenderer(d:D3ComAttriItemVO):void
		{
			var db:ID3ComBase = att_ls[d.key] as ID3ComBase;
			if(db==null){
				db = D3ComTypeManager.getComByType(d.value);
				addChild(db as DisplayObject);
			}
			db.item = d;
			db.group = group;
			db.reflashFun = comReflash;
			att_vls[d.key] = db;
		}
		
		protected function comReflash(d:ID3ComBase):void
		{
			target.target.comReflash(d);
		}
		
		//刷新编辑的组件的样式
		protected function callUIRender():void
		{
			reflashFun(this);
		}
		
		public function setValue():void
		{
			visible = true;
			includeInLayout = true;
			resetCom();
		}
		
		public function getValue():D3ComBaseVO
		{
			return createComBaseVO();
		}
		
		public function getCompValue():*
		{
			if(getCompValue_f != null) {
				return getCompValue_f(this);
			}
			return comp.configData.getAttri(key);
		}
		
		protected function createComBaseVO():D3ComBaseVO
		{
			var d:D3ComBaseVO = new D3ComBaseVO();
			d.target = this;
			return d;
		}
		
		protected function resetCom():void{};
		
		
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////
		
		protected function get openPopupwin():Function
		{
			return SandyManagerBase.getInstance().openPopupwin;
		}
		
		protected function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
		
	}
}
