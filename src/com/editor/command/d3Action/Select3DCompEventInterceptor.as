package com.editor.command.d3Action
{
	import com.editor.command.interceptor.AppAbstractInterceptor;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.app.manager.Stack3DManager;
	import com.editor.d3.app.mediator.App3DMainUIContainerMediator;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.manager.D3ViewManager;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessTexture;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.d3.view.attri.preview.TexturePreview;
	import com.editor.model.AppMainModel;
	
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class Select3DCompEventInterceptor extends AppAbstractInterceptor
	{
		override public function intercept():void 
		{			
			super.intercept();
			
			var c:D3ObjectBase;
			
			if(notification.getBody() == null){
				D3SceneManager.getInstance().currScene.noSelected();
			}
			
			if(notification.getBody() is File){
				if(D3ReadImage.checkIsImage(notification.getBody() as File)){
					var f:File = (notification.getBody() as File).clone()
					setTimeout(function():void{openPreviewTexture(f);},210);
					notification.setBody(null);
				}
			}
			
			c = notification.getBody() as D3ObjectBase;
			if(c!=null){
				
				if(D3SceneManager.getInstance().displayList.selectedComp!=null){
					if(notification.getType() != "3"){
						if(D3SceneManager.getInstance().displayList.selectedComp.uid == c.uid && c.proccess.mapItem != null){
							if(D3SceneManager.getInstance().currScene.selectedObject!=null){
								if(D3SceneManager.getInstance().currScene.selectedObject == c.proccess.mapItem.getObject()){
									return ;
								}
							}
						}
					}
				}
				
				Stack3DManager.getInstance().changeStack(D3ComponentConst.stack3d_scene);
				c.selected()
			}else{
				AppMainModel.getInstance().applicationStorageFile.putKey_3dOutlineUID("");
			}
			
			trace("select3DComp , " + notification.getBody())
			
			proceed();
		}
		
		private function openPreviewTexture(f:File):void
		{
			D3ViewManager.getInstance().openView_texture2(f);
		}
		
		protected function get_App3DMainUIContainerMediator():App3DMainUIContainerMediator
		{
			return retrieveMediator(App3DMainUIContainerMediator.NAME) as App3DMainUIContainerMediator;
		}
	}
}