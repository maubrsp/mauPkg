package com.br.mau.events{
	
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    
    public class CustomListener{
        private static var targetMap : Dictionary = new Dictionary(true);
		
        /**
         * @USAGE:
         * 
         * CustomEvent.addListener(someButton, MouseEvent.CLICK, onClick, "test", 22, 45);
		 * 
		 * public function onClick( evt:Event, p_name:String, p_rand1:int, p_rand2:int ) : void{
		 * 	trace( p_name );
		 * 	trace( p_rand1, p_rand2 );
		 * }
		 * 
		 * CustomEvent.dispatch(someButton, MouseEvent.CLICK);
		 * 
         */
        public static function addListener(p_target:IEventDispatcher, p_type:String, listener:Function, ...args):void{
            var targetEventMap : Dictionary;
            targetEventMap = targetMap[p_target] == undefined ? new Dictionary : targetMap[p_target];
            targetEventMap[p_type] = {listener:listener, args:args};
			
            targetMap[p_target] = targetEventMap;
            
            p_target.addEventListener(p_type, onEvent);
        }
        
        public static function dispatch(p_target:IEventDispatcher, p_type:String, p_params:Object=null) : void{
            var targetEventMap : Dictionary = targetMap[p_target];
            
            p_target.dispatchEvent(new CustomEvent(p_type, p_params));
        }
        
        public static function removeListener(p_target:IEventDispatcher, p_type:String) : void{
            var targetEventMap : Dictionary = targetMap[p_target];
            delete targetEventMap[p_type];
            
            p_target.removeEventListener(p_type, onEvent);
        }
        
        private static function onEvent (evt:Event):void{
            var target : IEventDispatcher = evt.currentTarget as IEventDispatcher;
            var targetEventMap : Dictionary = targetMap[target];
            var eventType : String = evt.type;
            
            var listener : Function = targetEventMap[eventType].listener;
            var args:Array = targetEventMap[eventType].args;
            
            if (args[0] is Event) args.shift();
            
            args.unshift(evt);

            listener.apply(target, args);
        }

    }
}
