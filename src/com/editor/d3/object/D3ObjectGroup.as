package com.editor.d3.object
{
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessGroup;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.sandy.math.TreeNode;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIDUtil;
	
	import flash.filesystem.File;

	public class D3ObjectGroup extends D3ObjectBase
	{
		public function D3ObjectGroup(from:int)
		{
			super(from);
			proccess = new D3ProccessGroup(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group)
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group5;
		}
		
		override public function selected():void
		{
			D3SceneManager.getInstance().currScene.selectObject(null);
		}
		
		override public function readObject():void
		{
			if(file == null) return ;
			if(!D3ResChangeProxy.getInstance().checkFile(file)){
				D3ResChangeProxy.getInstance().addFile(file,"");
			}
			configData = D3ResChangeProxy.getInstance().getFile(file.nativePath,true);
			configData.comp = this;
			if(!StringTWLUtil.isWhitespace(name))configData.putAttri("name",name);
			configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(file))
			configData.readObject();
		}
		
		public function readObject2():void
		{
			super.readObject();
		}
	}
}