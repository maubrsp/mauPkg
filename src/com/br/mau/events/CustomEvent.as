package com.br.mau.events{
	import flash.events.Event;

	public dynamic class CustomEvent extends Event{
		
		public var params:Object;
		
		public function CustomEvent(p_type:String, p_params:Object=null, p_bubbles:Boolean=false, p_cancelable:Boolean=false){
			super(p_type, p_bubbles, p_cancelable);
			
			params = p_params;
		}
		
		public override function clone():Event{
            return new CustomEvent(type, params, bubbles, cancelable);
        }
		
        public override function toString():String{
            return formatToString("CustomEvent", "type", "params", "bubbles", "cancelable");
        }
		
	}
}