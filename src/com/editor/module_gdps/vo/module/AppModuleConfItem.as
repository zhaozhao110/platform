package com.editor.module_gdps.vo.module
{

    public class AppModuleConfItem extends AppModuleConfBase
    {

        private var _view:String; //存放请求controller

        private var _extend:Object; //存放菜单的拓展信息

        public function get view():String
        {
            return _view;
        }

        public function set view(value:String):void
        {
            _view = value;
        }

        public function get extend():Object
        {
            return _extend;
        }

        public function set extend(value:Object):void
        {
            _extend = value;
        }


        public function AppModuleConfItem(obj:Object)
        {
            parser(obj)
        }

        public function parser(obj:Object):void
        {
            flashId = int(obj.flashId);
            menuId = obj.menuid;
            swfPath = obj.swfPath;
            if (obj.extend != null)
            {
                _extend = obj.extend;
            }
            if (obj.view != null)
            {
                _view = obj.view;
            }
        }


    }
}
