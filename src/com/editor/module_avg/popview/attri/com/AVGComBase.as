package com.editor.module_avg.popview.attri.com
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_avg.popview.attri.AVGAttriComBaseVO;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.attri.AVGComAttriItemVO;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class AVGComBase extends UIHBox 
	{
		public function AVGComBase()
		{
			super();
			create_init();
		}
		
		private var _item:AVGComAttriItemVO;
		public function set item(value:AVGComAttriItemVO):void
		{
			_item = value;
			reflash_init();
		}
		//db里的组件属性
		public function get item():AVGComAttriItemVO
		{
			return _item;
		}
		
		private var _compItem:AVGResData;
		public function set compItem(value:AVGResData):void
		{
			_compItem = value;
		}
		public function get compItem():AVGResData
		{
			return _compItem;
		}
		
		private var _reflashFun:Function;
		public function set reflashFun(value:Function):void
		{
			_reflashFun = value;
		}
		public function get reflashFun():Function
		{
			return _reflashFun;
		}
		
		public function get key():String
		{
			return item.key;
		}
		
		
		protected var leftTxt:UILabel;
		
		protected function create_init():void
		{
			width = 260;
			height = 25;
			verticalAlign = ASComponentConst.verticalAlign_middle;
			horizontalGap = 2;
			createLeftTxt();
			mouseChildren = true;
			mouseEnabled = true
			
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
		
		protected function reflash_init():void
		{
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
			reflashFun(this);
		}
		
		public function getValue():AVGAttriComBaseVO
		{
			return null;
		}
		
		protected function initVO(d:AVGAttriComBaseVO):void
		{
			d.key = item.key;
			d.target = this;
		}
		
		public function setValue(obj:AVGAttriComBaseVO):void
		{
			visible = true;
			includeInLayout = true;
			resetCom();
		}
		
		protected function createComBaseVO():AVGAttriComBaseVO
		{
			var d:AVGAttriComBaseVO = new AVGAttriComBaseVO();
			d.target = this;
			return d;
		}
		
		public var getCompValue_f:Function;
		
		public function getCompValue():*
		{
			if(getCompValue_f != null) {
				return getCompValue_f(this);
			}
			return null;
		}
		
		protected function resetCom():void{}
		
		protected function get openPopupwin():Function
		{
			return SandyManagerBase.getInstance().openPopupwin;
		}
		
	}
}