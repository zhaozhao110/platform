package com.editor.d3.view.particle.behaviors
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.view.particle.anim.ParticleAttri_anim;
	import com.editor.d3.vo.particle.sub.InstanceDataObj;
	import com.sandy.asComponent.controls.ASButton;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.MouseEvent;
	
	public class ParticleAttriPlugBase extends ParticleAttriCellBase
	{
		public function ParticleAttriPlugBase()
		{
			super();
		}
		
		private var _enabled2:Boolean=true
		public function get enabled2():Boolean
		{
			return _enabled2;
		}
		public function set enabled2(value:Boolean):void
		{
			if(value == enabled2) return ;
			_enabled2 = value;
			if(plusObj!=null) plusObj.enabled = value;
			if(enabledCB!=null) enabledCB.selected = value;
		}
				
		public var plusObj:ParticleAttriPlugVO;
		public var save_f:Function;
		public var headerButton:ASComponent;
		private var titleH:UIHBox;
		public var behContainer:ParticleAttri_beh;
		
		override protected function create_init():void
		{
			height = 220;
			percentWidth =100;
			styleName = "uicanvas"
			padding = 5;
			
			titleH = new UIHBox();
			titleH.horizontalGap = 10;
			titleH.height = 22;
			titleH.percentWidth = 100;
			addChild(titleH);
			titleH.verticalAlignMiddle = true
			
			addEnabledButton();
			addDelButton();
		}
		
		protected var delBtn:UIButton
		protected function addDelButton():void
		{
			if(delBtn == null){
				delBtn = new UIButton();
				delBtn.label = "删除"
				delBtn.addEventListener(MouseEvent.CLICK , onDel22);
				titleH.addChild(delBtn);
			}
		}
		
		private function onDel22(e:MouseEvent=null):void
		{
			enabled2 = false
			includeInLayout = false;
			visible = false;
			headerButton.includeInLayout = false;
			headerButton.visible = false;
			
			if(currAnimationData != null){
				currAnimationData.data.delBehObj(plusObj.id)
			}
			
			behContainer.reflashCB();
			ParticleAttri_anim.instance.reflashAnimVBox();
		}
		
		protected var enabledCB:UICheckBox;
		protected function addEnabledButton():void
		{
			if(enabledCB == null){
				enabledCB = new UICheckBox();
				enabledCB.label = "启用"
				enabledCB.selected = true;
				enabledCB.addEventListener(ASEvent.CHANGE,onCBChange11);
				titleH.addChild(enabledCB);
			}
			onCBChange22();
		}
		
		private function onCBChange22():void
		{
			if(enabledCB!=null)enabled2 = enabledCB.selected;
			
			if(headerButton!=null&&enabledCB!=null){
				if(enabledCB.selected){
					headerButton.label = plusObj.name + "(启用)"
				}else{
					headerButton.label = plusObj.name + "(失效)"
				}
			}
		}
		
		private function onCBChange11(e:ASEvent):void
		{
			var en:Boolean = enabled2;
			onCBChange22()
			//if(en!=enabled2)saveAllBeh()
			currAnimationData.data.enabledChange = true;
		}
		
		public function getObject():Object
		{
			return null;
		}
		
		public function saveObject():void
		{
			
		}
		
		//再次打开的时候刷新数据，已经有数据的
		public function parserObject(obj:Object):void
		{			
			if(obj!=null){
				plusObj.clear();
				plusObj.parser(obj);
				plusObj.name = this.label;
			}
			
			enabled2 = plusObj.enabled;
			
			headerButton.includeInLayout = true;
			headerButton.visible = true;
			includeInLayout = true;
			visible = true;
		}
		
		//创建的时候调用,没有数据的
		override public function changeAnim():void
		{
			super.changeAnim();
			onCBChange22();
		}
				
		public var isReseting:Boolean;
				
		public function saveBeh():void
		{
			if(isReseting ) return ;
			if(currAnimationData == null) return ;
			if(InstanceDataObj.isReseting) return ;
			saveObject();
			currAnimationData.data.reflashBehObj(plusObj.id,plusObj.getObject());
		}
		
		public function saveAllBeh():void
		{
			if(isReseting ) return ;
			if(currAnimationData == null) return ;
			currAnimationData.data.saveAllBeh();
		}
		
	}
}