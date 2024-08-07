extends Node2D

var unfiltered_buttons = []

var buttons = []
onready var selected = self



var size = 7

onready var buttons_sort = [$sort/Node2D, $sort/Node2D2,$sort/Node2D5, $sort/Node2D3, $sort/Node2D4]

var last_select = self
var descend = false
var count = []

func select_filter(delta):
	for i in range(buttons_sort.size()):
		buttons_sort[i].position = buttons_sort[i].position.linear_interpolate($sort/anchor.position + Vector2(0, 25 * i),delta * 30)
		
		if get_global_mouse_position().x < 160:
			if get_global_mouse_position().y < buttons_sort[i].position.y + 12 and get_global_mouse_position().y > buttons_sort[i].position.y - 12:
				buttons_sort[i].position.x += 6
				if Input.is_action_just_pressed("CLICK"):
					if i == 0:
						sort_by_amount(descend)
					elif i == 1:
						sort_by_type(descend)
					elif i == 2:
						sort_random()
					elif i == 3:
						if size > 1:
							size -= 1
					elif i == 4:
						if size < buttons.size() :
							size += 1
					descend = !descend
					buttons_sort[i].position.x = 55
					$sort2.play()
					
					for o in range(count.size()):
						count[o] = 0.005 * o
					reorganize()
		
		
		
func _ready() -> void:
	for i in range(1006):
		var button_inst = $container/button.duplicate()
		buttons.append(button_inst)
		unfiltered_buttons.append(button_inst)
		$container.add_child(button_inst)
		count.append(i * 0.06)
		
	$container/button.queue_free()
	
	
var size_x = 118
var size_y = 48

var scroll = 0
var scroll_val = 0

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("scroll_down"):
		scroll -= 155
	if Input.is_action_pressed("scroll_up"):
		scroll += 155

func _physics_process(delta: float) -> void:
	select_filter(delta)
	
	$fps.text = str(Engine.get_frames_per_second())
	scroll_val += (scroll - scroll_val) * 0.1
	
	$container.position.y = scroll_val
	
	for i in range(buttons.size()):
		var pos = Vector2(168,25) + Vector2((size_x * (i % size)) , size_y * floor((i) / size)) 
		buttons[i].original_pos = pos
		
#		p.vel += (pos - p.position) * 2
#		if count[i] < 0:
#			buttons[i].position = buttons[i].position.linear_interpolate(pos,delta * 10)
#		count[i] -= delta

	if Input.is_action_pressed("CLICK"):
		if Input.is_action_just_pressed("ui_accept"):
			sort_by_amount(true)
	elif Input.is_action_just_pressed("ui_accept"):
			sort_by_amount()
		
	if Input.is_action_just_pressed("ui_cancel"):
		sort_by_type()
		
	if Input.is_action_just_pressed("ui_down"):
		size -= 1
	if Input.is_action_just_pressed("ui_up"):
		size += 1
		
	
	$info.position /= 1.3
	if selected != self:
		
		selected.get_node("rect/bg").modulate = selected.get_node("rect/bg").modulate.linear_interpolate(Color.orangered,delta * 10)
		
#		p.position = p.position.linear_interpolate(, delta * 10)

		$info/name.text = str(selected.current_name, " x", selected.elements["Amount"])
		if Input.is_action_just_pressed("CLICK"):
			$click2.play()
		if Input.is_action_pressed("CLICK"):
			selected.get_node("rect/bg").modulate = Color(0,-0,-0)
		if Input.is_action_just_released("CLICK"):
			selected.get_node("rect/bg").modulate = Color.orange.lightened(15.5)
			$click.play()
	
		selected.get_node("rect").margin_right += 4
		selected.get_node("rect").margin_bottom += 4
		selected.get_node("rect").margin_top -= 4
		selected.get_node("rect").margin_left -= 4
		selected.z_index = 2
		
	if last_select != selected:
		$cycle.play()
		$info.position.x = 55
		selected.get_node("rect/bg").modulate = Color.orange.lightened(55.3)
		selected.get_node("rect").margin_right = 0
		selected.get_node("rect").margin_left = 44
		selected.position.y -= 1
		last_select = selected
	

	
func sort_random():
	reorganize()
	
	var buttons_sorted = []
	var indexes = []
	for i in range(buttons.size()):
		indexes.append(i)
		
	indexes.shuffle()
		
	print(indexes)
	for i in indexes:
		
		buttons_sorted.append(buttons[i])
		
	buttons = buttons_sorted
	

var amount_distance = 0


func sort_by_type(descending = false):
	reorganize()

	var buttons_sorted = []

	var types = buttons[0].types
	var current_type = 0
	
	for o in range(types.size()):
		for i in range(buttons.size()):
			if buttons[i].current_type == o:
				if descending:
					buttons_sorted.push_front(buttons[i])
				else:
					buttons_sorted.append(buttons[i])
	
	buttons = buttons_sorted
	
func sort_by_amount(descending = false):
	reorganize()
	
	var buttons_sorted = []

	var amount_max = 100
	var current_amount = 0
	
	for o in range(amount_max):
		for i in range(buttons.size()):
			if buttons[i].elements["Amount"] == o:
				if descending:
					buttons_sorted.push_front(buttons[i])
				else:
					buttons_sorted.append(buttons[i])
	
	buttons = buttons_sorted
	

func reorganize():
	for i in range(buttons.size()):
		var p = buttons[i]
		p.get_node("rect").margin_right = -55
#		p.get_node("rect").margin_bottom = -100
#		p.get_node("rect").margin_top = 1000
		p.get_node("rect").margin_left = 55 	  	
		p.count = rand_range(0, 0.3)
	
	
#	for i in range(buttons.size()):
#		var sort = buttons[i].elements["Amount"] 
#		if amount_distance > buttons[i].elements["Amount"]:
#			buttons_sorted.append(buttons[i])
#			distance = sort
#
#
#	amount_distance = 0
#
#	buttons = buttons_sorted
	
		
		
