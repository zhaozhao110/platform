package com.editor.module_gdps.vo.login
{
	public class LoginServerAddressConst
	{
		public function LoginServerAddressConst()
		{
		}
		
		public static var address_ls:Array = [];
		
		public static function init():void
		{
//			address_ls.push("192.168.20.157:8089|臧龙涛");
//			address_ls.push("192.168.0.18:92|测试更新");
			address_ls.push("192.168.0.9:82|正式更新");
		}
	}
}