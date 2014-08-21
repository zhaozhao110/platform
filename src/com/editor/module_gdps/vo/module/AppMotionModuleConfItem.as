package com.editor.module_gdps.vo.module
{
	import com.editor.module_gdps.services.GDPSServices;

    public class AppMotionModuleConfItem extends AppModuleConfBase
    {
        private var _view:String; //存放请求controller

        private var _extend:Object; //存放菜单的拓展信息

        public function get view():String
        {
            return _view;
        }

        public function get extend():Object
        {
            return _extend;
        }

        public function AppMotionModuleConfItem(obj:Object)
        {
            parser(obj)
        }

        public var dict_xml_url:String;

        public var motion_xml_url:String;

        public var resource_xml_url:String;

        public function parser(obj:Object):void
        {
            dict_xml_url = GDPSServices.cilentDomain() + obj.extend.dict;
            motion_xml_url = GDPSServices.cilentDomain() + obj.extend.motion;
            resource_xml_url = GDPSServices.cilentDomain() + obj.extend.resource;

            menuId = obj.menuid;
            swfPath = obj.swfPath;
			flashId = int(obj.flashId);
			
            _extend = obj.extend;
            _view = obj.view;
        }


    }
}
