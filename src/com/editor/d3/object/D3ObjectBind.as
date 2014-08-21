package com.editor.d3.object
{
	import away3d.entities.BindingTag;
	
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.process.D3ProccessBindBone;
	import com.editor.d3.process.D3ProccessObject;
	import com.editor.d3.view.attri.cell.renderer.D3ComBonesItemRenderer;
	import com.sandy.utils.StringTWLUtil;

	public class D3ObjectBind extends D3Object
	{
		public function D3ObjectBind(from:int)
		{
			super(from);
			proccess = new D3ProccessBindBone(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group9;
		}
		
		public var itemRenderer:D3ComBonesItemRenderer;
		public var bindingTag:BindingTag;
		
		public var pre_bindObject:D3Object;
		public var pre_boneName:String;
		
		public function get bindObject():D3Object
		{
			var path:String = configData.getAttri("bindObject");
			if(StringTWLUtil.isWhitespace(path)) return null;
			var _nd:D3TreeNode = D3SceneManager.getInstance().displayList.rootNode.getAllChild(path) as D3TreeNode;
			if(_nd==null) return null;
			return _nd.object as D3Object;
		}
		
		public function get bindObjectPath():String
		{
			var path:String = configData.getAttri("bindObject");
			return path;
		}
		
		public function get boneName():String
		{
			return configData.getAttri("boneName");
		}
		
		public function checkCanBind():void
		{
			if(bindObject != null && boneName != null){
				if(pre_boneName != boneName || pre_bindObject != bindObject){
					D3Object(parentObject).unPreBindObject(this);
				}
				D3Object(parentObject).bindBoneToObject(this);
			}
		}
		
		public function readAnim2():void
		{
			readObject();
			configData.putAttri("path",D3Object(parentObject).node.path+"."+name)
		}
		
		override public function dispose():void
		{
			_unBindObject();	
			super.dispose()
		}
		
		private function _unBindObject():void
		{
			if(bindingTag == null) return ;
			var obj:D3Object = bindObject;
			if(obj == null) return ;
			D3Object(parentObject).unBindObject(this);
		}
		
		
	}
}