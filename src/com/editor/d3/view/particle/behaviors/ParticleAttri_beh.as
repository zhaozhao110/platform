package com.editor.d3.view.particle.behaviors
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAccordion;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.view.particle.ParticleAttriViewBase;
	import com.editor.d3.view.particle.anim.ParticleAttri_anim;
	import com.editor.d3.vo.particle.sub.InstanceDataObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.error.SandyError;
	
	import flash.events.MouseEvent;

	public class ParticleAttri_beh extends ParticleAttriViewBase
	{
		public function ParticleAttri_beh()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		public static var instance:ParticleAttri_beh
		public var cb:UICombobox;
		public var acc:UIAccordion;
		public var editLua_cb:UICheckBox;
		public var editLauBtn:UIButton;
		
		override protected function create_init():void
		{
			super.create_init(); 
			verticalGap = 5;
						
			var h:UIHBox = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 22;
			h.percentWidth = 100;
			addChild(h);
			
			editLua_cb = new UICheckBox();
			editLua_cb.width = 120;
			editLua_cb.label = "enabled lua"
			h.addChild(editLua_cb);
			editLua_cb.addEventListener(ASEvent.CHANGE,onEditCBChange);
			
			editLauBtn = new UIButton();
			editLauBtn.label = "edit code"
			editLauBtn.enabled = false;
			h.addChild(editLauBtn);
			editLauBtn.addEventListener(MouseEvent.CLICK , onEditLauClick);
			
			h = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 22;
			h.percentWidth = 100;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "添加动作";
			lb.width = 100;
			h.addChild(lb);
			
			cb = new UICombobox();
			cb.height = 22;
			cb.width =150;
			//cb.labelField = "label"
			cb.addEventListener(ASEvent.CHANGE, onCBChange);
			h.addChild(cb);
			
			var v:UIVBox = new UIVBox();
			v.paddingTop = 5;
			v.paddingLeft = 2;
			v.enabledPercentSize = true;
			v.styleName = "uicanvas"
			addChild(v);
			
			acc = new UIAccordion();
			acc.width = 270;
			acc.percentHeight = 100;
			v.addChild(acc);
			
			//createPlus(1);
		}
		
		private function onCBChange(e:ASEvent):void
		{
			var d:ParticleAttriPlugVO = cb.selectedItem as ParticleAttriPlugVO;
			if(d == null) return 
			createPlus(d.index);
			
			cb.selectedIndex = -1;
			acc.selectedIndex = -1;
			acc.hideAllContainer();
		}
		
		public function createPlus(ind:int):void
		{
			var b:Boolean = behaviors_obj.createPlus(ind);
			if(b){
				var base:ParticleAttriPlugBase = acc.addChild(behaviors_obj.getPlusBase(ind)) as ParticleAttriPlugBase;
				base.behContainer = this;
				base.comp = comp;
				base.headerButton = acc.getHeadBtnByContainer(base);
			}
			behaviors_obj.getPlusBase(ind).changeComp(comp);
			behaviors_obj.getPlusBase(ind).parserObject(null);
			reflashCB()
			currAnimationData.data.saveAllBeh();
			ParticleAttri_anim.instance.reflashAnimVBox();
		}
		
		private function reflashPlusInfo(ind:int,obj:Object=null):void
		{
			var b:Boolean = behaviors_obj.createPlus(ind);
			if(b){
				var base:ParticleAttriPlugBase = acc.addChild(behaviors_obj.getPlusBase(ind)) as ParticleAttriPlugBase;
				base.behContainer = this;
				base.comp = comp;
				base.headerButton = acc.getHeadBtnByContainer(base);
				base.parserObject(obj);
			}else{
				base = behaviors_obj.getPlusBase(ind)
				base.changeComp(comp);
				base.parserObject(obj);
			}
		}
				
		override public function changeAnim():void
		{
			super.changeAnim();
			
			InstanceDataObj.isReseting = true;
			acc.selectedIndex = -1;
			acc.hideAllHeadAndContainer();
			
			var haveIndex1:Boolean=false;
			var a:Array = currAnimationData.data.behaviors_ls;
			if(a!=null){
				for(var i:int=0;i<a.length;i++){
					var obj:Object = a[i];
					var ind:int = behaviors_obj.getIndexByData(obj.id);
					if(ind>=0){
						if(ind == 1){
							haveIndex1 = true;
						}
						reflashPlusInfo(ind,obj);
					}
				}
			}
			
			if(!haveIndex1){
				if(behaviors_obj.getPlusBase(1) == null){
					createPlus(1);
				}else{
					SandyError.error("particle time beh error");
				}
			}
			
			reflashCB();
			InstanceDataObj.isReseting = false
			if(a == null){
				currAnimationData.data.saveAllBeh();
			}
			
			acc.hideAllContainer();
		}
		
		public function reflashCB():void
		{
			cb.dataProvider = behaviors_obj.getLastArray();
			editLua_cb.selected = currAnimationData.data.globalValues.enabled;
				
		}
		
		private function onEditCBChange(e:ASEvent):void
		{
			if(editLua_cb.selected){
				currAnimationData.data.globalValues.enabled = true;
			}else{
				currAnimationData.data.globalValues.enabled = false;
			}
			editLauBtn.enabled = editLua_cb.selected; 
		}
		
		private function onEditLauClick(e:MouseEvent):void
		{
			get_App3DMainUIContainerMediator().showLuaEditor(currAnimationData.data.globalValues.getAttri("code"),saveLua_f);
		}
		
		private function saveLua_f(b:String):void
		{
			currAnimationData.data.globalValues.putAttri("code",b);
		}
		
		
		private function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return iManager.retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
		
	}
}