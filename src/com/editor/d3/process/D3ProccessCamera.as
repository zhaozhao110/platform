package com.editor.d3.process
{
	import away3d.cameras.lenses.LensBase;
	import away3d.cameras.lenses.OrthographicLens;
	import away3d.cameras.lenses.PerspectiveLens;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.editor.group.D3MapItemCamera;
	import com.editor.d3.object.D3ObjectCamera;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.editor.d3.vo.method.D3MethodItemVO;

	public class D3ProccessCamera extends D3ProccessObject
	{
		public function D3ProccessCamera(d:D3ObjectCamera)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group14;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			var dd:D3ComBaseVO = d.getValue();
			var v:* = dd.data;
			if(d.item.expand == "method"){
				var md:D3ObjectMethod = new D3ObjectMethod(comp.fromUI);
				md.parentObject = comp;
				md.readObject();
				md.compItem = Object(dd.data).cloneObject();
				comp.configData.putAttri(d.key,md);
				checkHaveLens()
				return ;
			}
			
			super.comReflash(d);
		}
		
		public function addControls(key:String,d:D3MethodItemVO):void
		{
			var md:D3ObjectMethod = comp.configData.getAttri(key) as D3ObjectMethod;
			if(md!=null){
				if(md.compItem.id == d.id){
					return ;
				}
			}
			
			md = new D3ObjectMethod(comp.fromUI);
			md.parentObject = comp;
			md.readObject();
			md.compItem = d
			comp.configData.putAttri(key,md);
		}
		
		override public function afterCreateComp():void
		{
			super.afterCreateComp();
			checkHaveLens()			
			mapItem.createCamera();
		}
		
		public function checkHaveLens():void
		{
			if(!comp.configData.checkAttri("lens")){
				var md:D3ObjectMethod = new D3ObjectMethod(comp.fromUI);
				md.parentObject = comp;
				md.readObject();
				md.compItem = D3ComponentProxy.getInstance().method_ls.getItemById(11).cloneObject();
				comp.configData.putAttri("lens",md);
			}
				
			if(D3ObjectCamera(comp).isGlobalCamera){
				md = comp.configData.getAttri("lens") as D3ObjectMethod;
				if(!md.configData.checkAttri("near")){
					md.configData.putAttri("near",D3SceneManager.getInstance().currCamera.lens.near);
					md.configData.putAttri("far",D3SceneManager.getInstance().currCamera.lens.far);
					
					if(D3SceneManager.getInstance().currCamera.lens is PerspectiveLens){
						md.configData.putAttri("fieldOfView",PerspectiveLens(D3SceneManager.getInstance().currCamera.lens).fieldOfView)
						md.configData.putAttri("focalLength",PerspectiveLens(D3SceneManager.getInstance().currCamera.lens).focalLength)
					}else if(D3SceneManager.getInstance().currCamera.lens is OrthographicLens){
						md.configData.putAttri("projectionHeight",OrthographicLens(D3SceneManager.getInstance().currCamera.lens).projectionHeight)
					}
				}
			}
			
			reflashObjectAttri();
		}
		
		override protected function _createMapItem_cls():Class
		{
			return D3MapItemCamera;
		}
		
		override public function reflashMethod(k:String, v:D3ProccessMethod=null):void
		{
			reflashObjectAttri();
		}
		
		
	}
}