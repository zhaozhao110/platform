package com.editor.d3.view.attri.com
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.group.D3AttriGroupCell;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.group.D3GroupItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class D3ComBase extends UIHBox implements ID3ComBase
	{
		public function D3ComBase()
		{
			super();
			create_init();
		}
		
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
				
		//属性
		public function get key():String
		{
			return item.key;
		}
		public function get attriId():int
		{
			return item.id;
		}
				
		protected var leftTxt:UILabel;
		
		protected function create_init():void
		{
			width = 260;
			height = 22;
			verticalAlign = ASComponentConst.verticalAlign_middle;
			horizontalGap = 2;
			createLeftTxt();
			mouseChildren = true;
			mouseEnabled = true;
			
			this.addEventListener(MouseEvent.RIGHT_CLICK , onRightClick);
		}
		
		private function onRightClick(e:MouseEvent):void
		{
			
		}
		
		protected function createLeftTxt(ui:ASComponent=null):void
		{
			if(leftTxt != null) return ;
			leftTxt = new UILabel();
			leftTxt.width = 100;
			leftTxt.backgroundColor = ColorUtils.white;
			if(ui!=null){
				ui.addChild(leftTxt);
			}else{
				addChild(leftTxt);
			}
		}
		
		private function reflash_init():void
		{
			if(leftTxt == null) return ;
			leftTxt.text = item.key;
			leftTxt.toolTip = item.toolTip;
			if(leftTxt.measuredWidth > leftTxt.width){
				if(StringTWLUtil.isWhitespace(item.toolTip)){
					leftTxt.toolTip = item.key;
				}else{
					leftTxt.toolTip = item.key + "<br>" + item.toolTip;
				}
			}
		}
		
		//刷新编辑的组件的样式
		protected function callUIRender():void
		{
			D3ProjectCache.disabledDataChange = false;
			reflashFun(this);
		}
		
		public function setValue():void
		{
			visible = true;
			includeInLayout = true;
			reflash_init();
			resetCom();
		}
		
		public function getValue():D3ComBaseVO
		{
			return createComBaseVO();
		}
		
		public var getCompValue_f:Function;
		
		public function getCompValue():*
		{
			if(getCompValue_f != null) {
				return getCompValue_f(this);
			}
			if(comp.configData.checkAttri(key)){
				return comp.configData.getAttri(key);
			}
			return item.defaultValue;
		}
		
		protected function createComBaseVO():D3ComBaseVO
		{
			var d:D3ComBaseVO = new D3ComBaseVO();
			d.target = this;
			return d;
		}
				
		protected function resetCom():void{};
		
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