extends Node2D

var just_entered = false

var char_power_info = []
var index = 0

onready var bg = [$bg/rect8, $bg/rect3, $bg/rect9, $bg/rect2, $bg/rect, $bg/rect7, $bg/rect5, $bg/rect6, $bg/title,$bg/stripes, $bg/stripes2]
var bg_pos = []
var count = []

var count_1 = []
var original_visual_pos = []
onready var visual = [$visual/stat_name, $visual/spell_title, $visual/magic,$visual/magic, $visual/magic/ColorRect5, $visual/magic/ColorRect6, $visual/magic/ColorRect, $visual/spell_desc, $visual/spell_desc/title, $visual/spell_desc/desc, $visual/magic/Label, $visual/defense, $visual/defense/ColorRect5, $visual/defense/ColorRect6, $visual/defense/ColorRect, $visual/defense/Label, $visual/attack, $visual/attack/ColorRect5, $visual/attack/ColorRect6, $visual/attack/ColorRect, $visual/attack/Label, $visual/spell, $visual/info, $visual/bg/ColorRect, $visual/bg/ColorRect2, $visual/bg/ColorRect3]

var spell_index = 0
var spell_ui = []
var available_spell_ui = []
var selected_spell = self

var last_spell_index = 0

var click_classic = preload("res://Sound/UI_sfx/click_classic.wav")
var select_classic = preload("res://Sound/UI_sfx/select_classic.wav")

var select_sfx = preload("res://Sound/UI_sfx/click_light.wav")

enum states {
	MAIN,
	SPELL_CHECK
}

var current_state = states.MAIN

func reposition():
	$bg.position.y = -155
#	$bg.position.x = 1555
	
	for i in range(bg.size()):
#		bg[i].rect_position.y = sin(i * 0.3) * 5000 / 19
#		bg[i].rect_position.x = sin(i * 0.3) * 3000 / 19
#		bg[i].rect_position.x = 500 * i
		bg[i].rect_position.x -= (320 - bg[i].rect_position.x) * 5 + i
		bg[i].self_modulate = Color.transparent
		count[i] = i * 0.02
		
	for i in range(visual.size()):
		visual[i].rect_position.x += 50 * 3 * (i + 1)
		visual[i].rect_scale = Vector2(2,0.6)
		count_1[i] = i * 0.015
		
	for i in range(spell_ui.size()):
		spell_ui[i].position.x += 250 * i
	
func _ready() -> void:
	for i in bg:
		bg_pos.append(i.rect_position)
		count.append(0)
		
	for i in visual:
		original_visual_pos.append(i.rect_position)
		count_1.append(0)
		
	reposition()
	
	for i in gamesystem.party:
		var char_inst = $char_select/char.duplicate()
		char_inst.get_node("icon").texture = i.ui_icon_small
		
		char_inst.modulate = i.color_theme.lightened(15)
		$char_select.add_child(char_inst)
		chars.append(char_inst)
		
	$char_select/char.queue_free()
	
	for i in range(8):
		var spell_ui_inst = $visual/spell/spell.duplicate()
		spell_ui.append(spell_ui_inst)
		$visual/spell.add_child(spell_ui_inst)
		
	$visual/spell/spell.queue_free()
	apply_data(gamesystem.party[index])
	
var last_char_index = 0
	
func apply_data(data = preload("res://Game/Character/data/ralsei_data.tres")):
	available_spell_ui = []
	spell_index = 0

	
	$visual/magic/Label.text = str(data.mag)
	$visual/defense/Label.text = str(data.def)
	$visual/attack/Label.text = str(data.atk)
	
	var char_name_striped = ""
	for i in range(11):
		char_name_striped += str(" - ", data.name)
	
	$bg/Node2D/char_name.text = char_name_striped
	$bg/Node2D2/char_name.text = char_name_striped
	

	
	$visual/info.text = data.magic_description[0]
	
	$char_select/Node2D.modulate = Color(4,4,4,0)
	for i in spell_ui:
		i.hide()
		
	for i in range(data.magic.size()):
		spell_ui[i].show()
		var inst_data = data.magic[i].instance()
		spell_ui[i].get_node("name").text = str(inst_data.magic_name)
		spell_ui[i].get_node("tp_cost").text = str(inst_data.tp_cost)
		spell_ui[i].get_node("icon").texture = inst_data.texture
		available_spell_ui.append(spell_ui[i])
	
	if index == 0:
		spell_ui[0].show()
		spell_ui[0].get_node("name").text = str("ACT")
		spell_ui[0].get_node("tp_cost").text = str("0")
		spell_ui[0].get_node("icon").texture = preload("res://Art/UI_art/magic_icons/act.png")
		available_spell_ui.append(spell_ui[0])
	
	fx.sfx(click_classic)
	$visual/stat_name.text = str(data.name, " - stat")
	
	var input = (Input.get_action_strength("LEFT") - Input.get_action_strength("RIGHT")) 
	for i in range(bg.size()):
		bg[i].rect_position.x += input * i
		
	$visual/info.rect_size.x += 999
	$visual/info.rect_position.x -= 999
	fx.sfx_non_positional(select_sfx, 10, 1)
	

var delay = 0

func bg_anim(delta):
	$bg/Node2D/char_name.margin_left -= 0.3
	if $bg/Node2D/char_name.margin_left < -110:
		$bg/Node2D/char_name.margin_left = 0
		
	$bg/Node2D2/char_name.margin_left -= 0.3
	if $bg/Node2D2/char_name.margin_left < -110:
		$bg/Node2D2/char_name.margin_left = 0

var chars = []
var dist = 44

func char_anim(delta):
	for i in range(chars.size()):
		var p = chars[i]
		if i != index:
			p.modulate = p.modulate.linear_interpolate(Color.white,delta * 10)
		p.position = p.position.linear_interpolate(($char_select/anchor.position - Vector2((dist / 2) * gamesystem.party.size() ,0)) + Vector2(i * dist,0) ,delta * 10)

		
	$char_select/Node2D.scale = $char_select/Node2D.scale.linear_interpolate(Vector2.ONE,delta * 15)
	
	chars[index].modulate = chars[index].modulate.linear_interpolate(Color.black,delta * 10) 
	$char_select/Node2D.position = $char_select/Node2D.position.linear_interpolate(chars[index].position,delta * 10)
	$char_select/Node2D.modulate = $char_select/Node2D.modulate.linear_interpolate(gamesystem.party[index].color_theme,delta * 10)
	
	
func _physics_process(delta: float) -> void:
	if get_parent().current_section == get_parent().section.POWER:
		position.x /= 1.2
		$visual/focus.position /= 1.36
#		position.x -= 2
		$bg.position /= 1.1
		
		$bg.modulate = $bg.modulate.linear_interpolate(gamesystem.party[index].color_theme,delta * 4)
		$visual.modulate = $visual.modulate.linear_interpolate(gamesystem.party[index].color_theme,delta * 15)
		
		$visual/spell_desc/desc.rect_scale.x += (1 - $visual/spell_desc/desc.rect_scale.x) * 0.6
		$visual/spell_desc/desc.percent_visible += (1.1 - $visual/spell_desc/desc.percent_visible) * 0.2
		
		$visual/info.rect_size = $visual/info.rect_size.linear_interpolate(Vector2(308,13),delta * 15)
		
		if just_entered == false:
			fx.sfx_non_positional(preload("res://Sound/UI_sfx/back_ethereal.wav"),-20,1)
#			fx.sfx_non_positional(preload("res://Sound/UI_sfx/back_ethereal.wav"),-25,3)
#			fx.sfx_non_positional(preload("res://Sound/UI_sfx/back_ethereal.wav"),-25,0.3)
#			fx.sfx_non_positional(preload("res://Sound/UI_sfx/back_ethereal.wav"),-25,0.5)
			just_entered = true
		
		$visual.position = $visual.position.linear_interpolate(Vector2(276,65),delta * 10)
		
		for i in range(spell_ui.size()):
			var p = spell_ui[i]
			var pos = $visual/spell/anchor.position + Vector2((158 * (i % 2)) , 24 * floor(i * 0.5)) 
			p.position = p.position.linear_interpolate(pos - Vector2(5 * floor(i * 0.5),   0), delta * 20)
			p.scale = p.scale.linear_interpolate(Vector2.ONE,delta * 20)
			p.original_pos = pos
		
		
				
		for i in range(bg_pos.size()):
			count[i] -= delta
			if count[i] < 0:
				bg[i].self_modulate.a += (1 - bg[i].self_modulate.a) * 0.6
				bg[i].rect_position = bg[i].rect_position.linear_interpolate(bg_pos[i],delta * 18)
		
		for i in range(original_visual_pos.size()):
			count_1[i] -= delta
			if count_1[i] < 0:
				visual[i].rect_position = visual[i].rect_position.linear_interpolate(original_visual_pos[i],delta * 20)
				visual[i].rect_scale = visual[i].rect_scale.linear_interpolate(Vector2.ONE,delta * 20)
		
		bg_anim(delta)
		
		if current_state == states.MAIN:
			char_anim(delta)
			
			if Input.is_action_just_pressed("RIGHT"):
				if index < gamesystem.party.size() - 1:
					index += 1
				else:
					index = 0
				apply_data(gamesystem.party[index])
	#			$visual.position += Vector2(-0.5, 2) * 40
				$visual.position.x += 15
				for i in range(visual.size()):
					visual[i].rect_position.x += 10 * 3 * (i + 1)
	#				visual[i].rect_scale = Vector2(2,0.6)
	#				count_1[i] = i * 0.01
					
				for i in range(spell_ui.size()):
					spell_ui[i].position.x += 250 * i
					
			if Input.is_action_just_pressed("LEFT"):
				if index > 0:
					index -= 1
				else:
					index = gamesystem.party.size() - 1
					
				apply_data(gamesystem.party[index])
	#			$visual.position += Vector2(-0.5, 2) * -40
				$visual.position.x += -15
				for i in range(visual.size()):
					visual[i].rect_position.x += 10 * -3 * (i + 1)
	#				visual[i].rect_scale = Vector2(2,0.6)
					
	#				count_1[i] = i * 0.01
				for i in range(spell_ui.size()):
					spell_ui[i].position.x -= 250 * i 

			if Input.is_action_just_pressed("back"):
				get_parent().current_section = get_parent().section.MAIN
				reposition()
			delay -= delta
			if Input.is_action_just_pressed("CONFIRM") and delay < 0:
				current_state = states.SPELL_CHECK
				fx.sfx(select_classic)
				for i in spell_ui:
					i.scale = Vector2.ONE * 1.1
				
			$visual/magic_select_fx.hide()
			$visual/spell_desc.rect_position += Vector2(-20, 55)
		elif current_state == states.SPELL_CHECK:
			$visual/focus.position.y += 30
			$char_select/Node2D.global_position = $char_select/Node2D.global_position.linear_interpolate($visual/magic_select_fx.global_position + Vector2(42, 18),delta * 25)
			$char_select/Node2D.modulate = $char_select/Node2D.modulate.linear_interpolate(Color.transparent,delta * 10)
			$char_select/Node2D.scale = $char_select/Node2D.scale.linear_interpolate(Vector2(5, 1),delta * 15)
			
			$visual/magic_select_fx.show()
			
			if index == 0 and spell_index == 0:
				$visual/spell_desc/title.text = str("ACT")
				$visual/spell_desc/desc.text = "Perform various ACT's. Dont confuse it with magic"
			
			for i in spell_ui:
				i.selected = false
				i.get_node("rect_black").modulate = Color.white
				i.get_node("rect_color").modulate = Color.black
				i.get_node("name").modulate = Color.white
				i.get_node("icon").modulate = Color.white
				
#				i.modulate = Color.darkgray
			

			
			selected_spell = spell_ui[spell_index]
			
			if last_spell_index != spell_index:
				fx.sfx_non_positional(click_classic)
				fx.sfx_non_positional(select_sfx, 0, 1)
				$visual/spell_desc/desc.rect_scale.x = 0
				$visual/spell_desc/desc.percent_visible = 0
				$visual/spell_desc/title.text = gamesystem.party[index].magic[spell_index].instance().magic_name
				$visual/spell_desc/desc.text = gamesystem.party[index].magic[spell_index].instance().desc
				$visual/spell_desc/title.rect_position.x = 109
				
				last_spell_index = spell_index
			
			if Input.is_action_just_pressed("RIGHT"):
				cycle_button_right()
			if Input.is_action_just_pressed("LEFT"):
				cycle_button_left()
			if Input.is_action_just_pressed("DOWN"):
				cycle_button_down()
			if Input.is_action_just_pressed("UP"):
				cycle_button_up()
			
			selected_spell.selected = true
			selected_spell.modulate = Color.white
			selected_spell.position.x += 1
			selected_spell.get_node("rect_black").modulate = Color.black
			selected_spell.get_node("rect_color").modulate = Color.white
			selected_spell.get_node("name").modulate = Color.black
			selected_spell.get_node("icon").modulate = Color.black
			
			if Input.is_action_just_pressed("back"):
				current_state = states.MAIN
				for i in spell_ui:
					i.modulate = Color.white
					i.get_node("rect_black").modulate = Color.white
					i.get_node("rect_color").modulate = Color.black
					i.get_node("icon").modulate = Color.white
					i.get_node("name").modulate = Color.white
			$visual/magic_select_fx.global_position = $visual/magic_select_fx.global_position.linear_interpolate(selected_spell.global_position,delta * 40)
		show()
	else:
		hide()
		delay = 0.06
		just_entered = false
		position = position.linear_interpolate(Vector2(500,0),delta * 10)

var closest_btn_dist = INF


func cycle_button_right():
	closest_btn_dist = INF
	var closest_btn = null
	for i in range(available_spell_ui.size()):
		var dist = available_spell_ui[i].original_pos.distance_squared_to(selected_spell.original_pos)
		if dist < closest_btn_dist and available_spell_ui[i].original_pos.x > selected_spell.original_pos.x:
			
			spell_index = i
			closest_btn_dist = dist
			
func cycle_button_left():
	closest_btn_dist = INF
	
	for i in range(available_spell_ui.size()):
		var dist = available_spell_ui[i].original_pos.distance_squared_to(selected_spell.original_pos)
		if dist < closest_btn_dist and available_spell_ui[i].original_pos.x < selected_spell.original_pos.x:
			spell_index = i
			closest_btn_dist = dist
			
func cycle_button_up():
	closest_btn_dist = INF
	
	for i in range(available_spell_ui.size()):
		var dist = available_spell_ui[i].original_pos.distance_squared_to(selected_spell.original_pos)
		if dist < closest_btn_dist and available_spell_ui[i].original_pos.y < selected_spell.original_pos.y:
			spell_index = i
			closest_btn_dist = dist
			
func cycle_button_down():
	closest_btn_dist = INF
	
	for i in range(available_spell_ui.size()):
		
		var dist = available_spell_ui[i].original_pos.distance_squared_to(selected_spell.original_pos)
		
		if dist < closest_btn_dist and available_spell_ui[i].original_pos.y > selected_spell.original_pos.y:
			spell_index = i
			closest_btn_dist = dist












