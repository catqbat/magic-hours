//
//  Event.swift
//  magic-hours
//
//  Created by Agata on 17/04/2017.
//  Copyright © 2017 Agata. All rights reserved.
//

import Foundation
public class Event<T> {
	
	public typealias EventHandler = (T) -> ()
	
	 var eventHandlers = [Invocable]()
	
	public func raise(data: T) {
  for handler in self.eventHandlers {
	handler.invoke(data: data)
		}
	}
	
	public func addHandler<U: AnyObject>(target: U,
	                       handler: @escaping (U) -> EventHandler) -> Disposable {
		let wrapper = EventHandlerWrapper(target: target,
		                                  handler: handler, event: self)
		eventHandlers.append(wrapper as! Invocable)
		return wrapper
	}
}

private protocol Invocable: class {
	func invoke(data: Any)
}
