package com.editor.d3.view.particle.anim.itemRenderer
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.view.particle.anim.ParticleAttri_anim;
	import com.editor.d3.vo.particle.ParticleAnimationObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	
	public class ParticleAttriAnimItemRenderer extends ASHListItemRenderer
	{
		public function ParticleAttriAnimItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		public var cb:UICheckBox;
		public var nameTI:UITextInput;
		public var numTI:UILabel
		public var behTI:UILabel;
		public var delBtn:UIAssetsSymbol;
		public var copyBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
						
			width = 270
			height = 25;
			paddingLeft = 5
			
			cb = new UICheckBox();
			cb.label = " "
			cb.width = 40;
			cb.height = 25;
			cb.addEventListener(ASEvent.CHANGE , onCB);
			addChild(cb);
			
			nameTI = new UITextInput();
			nameTI.textAlign = "center"
			nameTI.enterKeyDown_proxy = onChangeName
			nameTI.text = ""
			nameTI.width = 80
			addChild(nameTI);
			
			numTI = new UILabel();
			numTI.text = ""
			numTI.textAlign = "center"
			numTI.width = 50;
			numTI.mouseEnabled = false;
			numTI.mouseChildren = false;
			addChild(numTI);
			
			behTI = new UILabel();
			behTI.text = ""
			behTI.textAlign = "center"
			behTI.width = 50;
			behTI.mouseEnabled = false;
			behTI.mouseChildren = false;
			addChild(behTI);
			
			delBtn = new UIAssetsSymbol();
			delBtn.source = "closeBtn_a"
			delBtn.buttonMode = true;
			delBtn.toolTip = "删除"
			delBtn.addEventListener(MouseEvent.CLICK , onDel);
			addChild(delBtn);
			
			copyBtn = new UIAssetsSymbol();
			copyBtn.source = "add_a"
			copyBtn.toolTip = "复制"
			copyBtn.buttonMode = true;
			copyBtn.addEventListener(MouseEvent.CLICK , onCopy);
			addChild(copyBtn);
		}
		
		private function onCopy(e:MouseEvent):void
		{
			var obj2:ParticleAnimationObj = ParticleAttri_anim.instance.comp.configData.particleObj.createAnimationData();
			var n:String = obj2.name;
			obj2.parser(obj.orginiObj);
			obj2.name = n;
			ParticleAttri_anim.instance.reflashAnimVBox2();
		}
		
		private function onChangeName():void
		{
			if(StringTWLUtil.isWhitespace(nameTI.text)){
				nameTI.text = obj.name;
			}else{
				if(D3SceneManager.getInstance().displayList.selectedParticle.configData.particleObj.getAnim(nameTI.text) == null){
					obj.name = nameTI.text;
					D3SceneManager.getInstance().displayList.selectedParticleAttri.infoTxt.htmlText = "当前选中的," + ColorUtils.addColorTool(obj.name,ColorUtils.red);
				}else{
					nameTI.text = obj.name;
				}
			}
		}
		
		public var obj:ParticleAnimationObj;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			obj = value as ParticleAnimationObj;
			cb.setSelect(obj.enabled,false);
			nameTI.text = obj.name;
			numTI.text = obj.particles.toString();
			behTI.text = obj.behaviors.toString();
		}
		
		private function onCB(e:ASEvent):void
		{
			obj.enabled = cb.selected;
			ParticleAttri_anim.instance.reflashAnimVBox();
		}
		
		private function onDel(e:MouseEvent):void
		{
			D3SceneManager.getInstance().displayList.selectedParticle.configData.particleObj.removeAnim(obj.name);
			ParticleAttri_anim.instance.selectedFirst()
		}
		
	}
}