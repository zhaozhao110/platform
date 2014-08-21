package com.editor.module_gdps.vo.user
{

    /**
     * 登陆用户信息
     */
    public class GDPSUserInfoVO
    {
        private var nuid:int;

        private var loginCode:String;

        private var name:String;

        private var resTime:String;

        private var loginIp:String;

        private var oprId:int;

        private var jsid:String;
		
		private var projectid:int;
		
		private var projectName:String;
		
		private var projectType:String;

        public function GDPSUserInfoVO(obj:Object = null)
        {
			if(obj != null)
			{
				parser(obj);
			}
        }

        private function parser(obj:Object):void
        {
            this.nuid = obj.nuid;
            this.loginCode = obj.loginCode;
            this.name = obj.name;
            this.loginIp = obj.loginIp;
            this.jsid = obj.jsid;
        }
		
		public function set setProjectId(projectid:int):void
		{
			this.projectid = projectid;
		}
		
		public function get getProjectId():int
		{
			return this.projectid;
		}

		public function set setProjectName(projectName:String):void
		{
			this.projectName = projectName;
		}
		
		public function get getProjectName():String
		{
			return this.projectName;
		}
		
		public function set setProjectType(projectType:String):void
		{
			this.projectType = projectType;
		}
		
		public function get getProjectType():String
		{
			return this.projectType;
		}
		
		public function get jsessionid():String
		{
			return this.jsid;
		}
		
		public function get uid():int
		{
			return this.nuid;
		}
		
		public function get getLoginCode():String
		{
			return this.loginCode;
		}
		
		public function get getUsername():String{
			return this.name; 
		}
		
		public function get getLoginIP():String
		{
			return this.loginIp;
		}
    }
}
