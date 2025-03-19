extends Node

class_name PlayerActionQueue

enum ActionEnum { IDLE, RUN, JUMP, ATTACK, RECEIVE_DAMAGE, DIE, PARRY, DASH }
var queue: Array[Dictionary] = []

func enqueue(action: ActionEnum, args: Array, avoid_duplicated_entry = false):
	if avoid_duplicated_entry:
		for item in queue:
			if item["action"] == action:
				return
	queue.append({
		"action": action,
		"args": args
	})

func dequeue() -> Dictionary:
	if queue.size() > 0:
		return queue.pop_front()
	return {}
