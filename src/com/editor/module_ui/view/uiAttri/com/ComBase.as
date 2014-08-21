package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UILabel;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class ComBase extends UIHBox implements IComBase
	{
		public function ComBase()
		{
			super();
			create_init();
		}
				
		private var _item:ComAttriItemVO;
		public function set item(value:ComAttriItemVO):void
		{
			_item = value;
			reflash_init();
		}
		//db里的组件属性
		public function get item():ComAttriItemVO
		{
			return _item;
		}
		
		private var _compItem:ComponentData;
		public function set compItem(value:ComponentData):void
		{
			_compItem = value;
		}
		public function get compItem():ComponentData
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
		
		public function get css_data():CSSComponentData
		{
			return CSSShowContainerMediator.currEditFile;
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
			if(UIEditManager.currEditShowContainer.selectedUI.data.item.isExpandComp()){
				if(!AppComponentProxy.instance.attri_ls.checkIsDefaultAttri(key)){
					UIEditManager.getInstance().openAttriCellRightMenu(this);
				}
			}
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
		
		public function getValue():IComBaseVO
		{
			return null;
		}
		
		public function checkIsDel():Boolean
		{
			return false;
		}
		
		protected function initVO(d:IComBaseVO):void
		{
			d.key = item.key;
			d.target = this;
		}
		
		public function setValue(obj:IComBaseVO):void
		{
			visible = true;
			includeInLayout = true;
			resetCom();
		}
		
		protected function resetCom():void{}
		
		protected function get openPopupwin():Function
		{
			return SandyManagerBase.getInstance().openPopupwin;
		}
	}
}