package com.editor.d3.view.particle
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.object.D3ObjectParticle;
	import com.editor.d3.view.attri.D3ComTypeManager;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.particle.ParticleAnimationObj;
	import com.sandy.math.HashMap;

	public class ParticleAttriCellBase extends UIVBox
	{
		public function ParticleAttriCellBase()
		{
			super();
			create_init()
		}
		
		public function get attriId():String
		{
			return "";
		}
		
		protected function create_init():void
		{
			enabledPercentSize = true;
			paddingLeft = 5;
			styleName = "uicanvas"
		}
		
		protected var attri_ls:Array = [];
		
		protected function createCompByGroup(a:Array):void
		{
			for(var i:int=0;i<a.length;i++){
				var d:D3ComAttriItemVO = a[i] as D3ComAttriItemVO;
				_createItemRenderer(d);
			}
		}
		
		private function _createItemRenderer(d:D3ComAttriItemVO):void
		{
			var db:D3ComBase = D3ComTypeManager.getComByType(d.value) as D3ComBase;
			addChild(db);
			db.item = d;
			db.reflashFun = comReflash;
			db.getCompValue_f = getCompValue;
			attri_ls[d.key] = db;
		}
		
		public function getAttri(k:String):D3ComBase
		{
			return attri_ls[k] as D3ComBase;
		}
		
		protected function getCompValue(d:D3ComBase):*
		{
			return null;
		}
		
		protected function comReflash(b:D3ComBase):void
		{
			
		}
		
		public var comp:D3ObjectParticle;
		
		public function changeComp(c:D3ObjectParticle):void
		{
			comp = c;
		}
		
		public function changeAnim():void
		{
			reflashAllAttri()	
		}
		
		protected function reflashAllAttri():void
		{
			for each(var d:D3ComBase in attri_ls){
				d.comp = comp;
				d.setValue();
			}
		}
		
		protected function enabledAllAttri(v:Boolean):void
		{
			for each(var d:D3ComBase in attri_ls){
				d.mouseChildren = v
				d.mouseEnabled = v
			}
		}
		
		protected function get currAnimationData():ParticleAnimationObj
		{
			if(comp == null) return null;
			return comp.configData.particleObj.currAnimationData;
		}
		
		
	}
}