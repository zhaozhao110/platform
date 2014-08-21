package com.editor.d3.view.particle.anim
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.particle.ParticleAttriViewBase;
	import com.editor.d3.view.particle.ParticleAttriViewMediator;
	import com.editor.d3.view.particle.anim.itemRenderer.ParticleAttriAnimItemRenderer;
	import com.editor.d3.vo.particle.ParticleAnimationObj;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.MouseEvent;

	public class ParticleAttri_anim extends ParticleAttriViewBase
	{
		public function ParticleAttri_anim()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		public static var instance:ParticleAttri_anim;
		public var addBtn:UIButton;
		public var delBtn:UIButton;
		public var animVBox:UIVBox;
		public var infoLB:UILabel;
		
		override protected function create_init():void
		{
			super.create_init(); 
			
			var h:UIHBox = new UIHBox();
			h.height = 25;
			h.percentWidth = 100;
			h.horizontalGap = 10;
			h.paddingLeft = 10;
			addChild(h);
						
			addBtn = new UIButton();
			addBtn.label = "添加"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			h.addChild(addBtn);
			
			/*delBtn = new UIButton();
			delBtn.label = "删除"
			h.addChild(delBtn);*/
			
			infoLB = new UILabel();
			infoLB.color = ColorUtils.red;
			h.addChild(infoLB);
			
			h = new UIHBox();
			h.percentWidth = 100;
			h.height = 25;
			h.verticalAlignMiddle = true
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "启用"
			lb.textAlign = "center"
			lb.width = 40;
			h.addChild(lb);
			
			lb = new UILabel();
			lb.text = "名字"
			lb.textAlign = "center"
			lb.width = 80
			h.addChild(lb);
			
			lb = new UILabel();
			lb.text = "粒子数"
			lb.textAlign = "center"
			lb.width = 50;
			h.addChild(lb);
			
			lb = new UILabel();
			lb.text = "动作数"
			lb.textAlign = "center"
			lb.width = 50;
			h.addChild(lb);
			
			animVBox = new UIVBox();
			animVBox.verticalGap = 5
			animVBox.itemRenderer = ParticleAttriAnimItemRenderer;
			animVBox.enabeldSelect = true
			animVBox.styleName = "list"
			animVBox.enabledPercentSize = true;
			animVBox.addEventListener(ASEvent.CHANGE , onAnimChange);
			addChild(animVBox);
			
		}
		
		override public function changeComp(c:D3ObjectParticle):void
		{
			super.changeComp(c);
			reflashAnimVBox();
		}
		
		public function selectedFirst():void
		{
			reflashAnimVBox();
			animVBox.selectedIndex = -1;
			animVBox.selectedIndex = 0;
		}
		
		private function onAdd(e:MouseEvent):void
		{
			if(comp == null) return ;
			var obj:ParticleAnimationObj = comp.configData.particleObj.createAnimationData();
			reflashAnimVBox2()
		}
		
		public function reflashAnimVBox2():void
		{
			reflashAnimVBox()
			animVBox.selectedIndex = -1;
			animVBox.selectedIndex = comp.configData.particleObj.animationDatas.length-1;
		}
		
		public function reflashAnimVBox():void
		{
			if(comp == null){
				animVBox.dataProvider = null;
				return ;
			}
			animVBox.dataProvider = comp.configData.particleObj.animationDatas;
			if(comp.configData.particleObj.animationDatas.length == 0){
				get_ParticleAttriViewMediator().setPropMouse(false);
			}
		}
		
		private function onAnimChange(e:ASEvent):void
		{
			var obj:ParticleAnimationObj = animVBox.selectedItem as ParticleAnimationObj;
			if(obj == null) return ;
			comp.configData.particleObj.currAnimationData = obj;
			D3SceneManager.getInstance().displayList.selectedParticleAttri.infoTxt.htmlText = "当前选中的," + ColorUtils.addColorTool(obj.name,ColorUtils.red);
			D3SceneManager.getInstance().displayList.selectedParticleAttri.changeAnim();
			get_ParticleAttriViewMediator().setPropMouse(obj.enabled);
		}
		
		private function get_ParticleAttriViewMediator():ParticleAttriViewMediator
		{
			return iManager.retrieveMediator(ParticleAttriViewMediator.NAME) as ParticleAttriViewMediator;
		}
		
	}
}