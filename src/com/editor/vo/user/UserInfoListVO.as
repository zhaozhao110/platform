package com.editor.vo.user
{
	public class UserInfoListVO
	{
		public function UserInfoListVO(a:Array)
		{
			for(var i:int=0;i<a.length;i++){
				var obj:Object = a[i];
				var d:UserInfoVO = new UserInfoVO(obj);
				all_ls.push(d);
				hash_ls[d.name] = d;
				hash_ls2[d.shortName] = d;
			}
		}
		
		private var hash_ls:Array = [];
		private var hash_ls2:Array = [];
		public var all_ls:Array = [];
		
		public function getUser(name:String):UserInfoVO
		{
			if(hash_ls[name]!=null){
				return hash_ls[name] as UserInfoVO;
			}
			if(hash_ls2[name]!=null){
				return hash_ls2[name] as UserInfoVO;
			}
			return null;
		}
		
		public function getUser2(name:String):UserInfoVO
		{
			return hash_ls2[name] as UserInfoVO;
		}
		
		
	}
}