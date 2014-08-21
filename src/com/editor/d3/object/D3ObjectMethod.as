package com.editor.d3.object
{
	import away3d.materials.methods.EffectMethodBase;
	import away3d.materials.methods.FogMethod;
	
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessMethod;
	import com.editor.d3.view.attri.cell.renderer.D3ComMethodItemRenderer;
	import com.editor.d3.vo.comp.ID3CompItem;
	import com.editor.d3.vo.method.D3MethodItemVO;
	
	public class D3ObjectMethod extends D3ObjectBase
	{
		public function D3ObjectMethod(from:int)
		{
			super(from);
			proccess = new D3ProccessMethod(this);
		}
				
		override public function set compItem(value:ID3CompItem):void
		{
			super.compItem = value;
			if(value){
				name = compItem.name;
				configData.putAttri("name",compItem.name);
				configData.putAttri("compId",compItem.id);
			}else{
				name = "";
				configData.removeAttri("name");
				configData.removeAttri("compId");
			}
		}
		
		public function get medthodProccess():D3ProccessMethod
		{
			return proccess as D3ProccessMethod;
		}
		
		override public function get isMethod():Boolean
		{
			return true;
		}
		
		override public function getGroups():Array
		{
			var a:Array = [];
			if(compItem!=null){
				var b:Array = compItem.outline_attri.split(",");
				for(var i:int=0;i<b.length;i++){
					if(a.indexOf(b[i])==-1){
						a.push(b[i]);
					}
				}
			}
			if(configData!=null){
				b = a.concat(configData.getGroups());
				for(i=0;i<b.length;i++){
					if(a.indexOf(b[i])==-1){
						a.push(b[i]);
					}
				}
			}
			return a;
		}
		
		public var itemRenderer:D3ComMethodItemRenderer;
		
		public function addMethodToMaterial():void
		{
			if(parentObject.proccess == null) return ;
			if(parentObject.proccess.mapItem == null) return ;
			parentObject.proccess.mapItem.addMethod(this);
		}
		
		public function removeMethodToMaterial():void
		{
			if(parentObject.proccess == null) return ;
			if(parentObject.proccess.mapItem == null) return ;
			parentObject.proccess.mapItem.removeMethod(this);
		}
		
		
		
	}
}