extends Control

const SAVE_FILE_NAME := "idle_factory_save.json"
const SAVE_PATH := "user://" + SAVE_FILE_NAME
const MAX_OFFLINE_SECONDS := 8 * 60 * 60
const OFFLINE_UPGRADE_SECONDS := 2 * 60 * 60
const OFFLINE_MAX_UPGRADE_SECONDS := 24 * 60 * 60
const OFFLINE_UPGRADE_BASE_COST := 100000.0
const OFFLINE_INITIAL_EFFICIENCY_PERCENT := 30
const OFFLINE_EFFICIENCY_STEP_PERCENT := 10
const OFFLINE_MAX_EFFICIENCY_PERCENT := 200
const OFFLINE_EFFICIENCY_UPGRADE_BASE_COST := 12000.0
const OFFLINE_EFFICIENCY_UPGRADE_GROWTH := 1.45
const CLICK_INCOME_BASE := 1.0
const CLICK_UPGRADE_BASE_COST := 80.0
const CLICK_UPGRADE_GROWTH := 2.0
const BGM_MIX_RATE := 22050
const BGM_LOOP_SECONDS := 16.0
const BUTTON_SFX_SECONDS := 0.18
const SAVE_DIALOG_SIZE := Vector2i(420, 180)
const REGION_DIALOG_SIZE := Vector2i(560, 220)
const REGION_COST_SCALING := 2.0
const REGION_INCOME_SCALING := 3.0
const REGION_STARTING_CLICK_SCALING := 2.0
const AUTOSAVE_SECONDS := 8.0
const GAME_UI_RESOLUTION := Vector2i(1280, 720)
const MAIN_MENU_LOGO_PATH := "res://art/logo/main_menu_logo_v3.png"
const MAIN_MENU_BACKGROUND_PATH := "res://art/backgrounds/main_menu_overview_background.png"
const FALLBACK_MENU_BACKGROUND_PATH := "res://art/backgrounds/factory_game_background.png"
const FACTORY_BACKGROUND_PATHS := [
	"res://art/backgrounds/factory_workshop_background.png",
	"res://art/backgrounds/factory_lumber_background.png",
	"res://art/backgrounds/factory_food_background.png",
	"res://art/backgrounds/factory_steel_background.png",
	"res://art/backgrounds/factory_electronics_background.png",
	"res://art/backgrounds/factory_robotics_background.png"
]
const PANEL_FACTORY_LIST_PATH := "res://art/ui/panels/panel_factory_list_9slice_256.png"
const PANEL_DETAIL_PATH := "res://art/ui/panels/panel_detail_9slice_256.png"
const PANEL_GOAL_PATH := "res://art/ui/panels/panel_goal_9slice_256.png"
const PANEL_SETTINGS_MODAL_PATH := "res://art/ui/panels/panel_settings_modal_9slice_256.png"
const PANEL_SLICE_MARGIN := 64.0
const GAME_BACKGROUND_DIM_ALPHA := 0.40
const GAME_PANEL_TEXTURE_ALPHA := 0.86
const WINDOW_SIZE_OPTIONS := [
	{"label": "960 × 540", "size": Vector2i(960, 540)},
	{"label": "1280 × 720", "size": Vector2i(1280, 720)},
	{"label": "1600 × 900", "size": Vector2i(1600, 900)},
	{"label": "1920 × 1080", "size": Vector2i(1920, 1080)}
]
const LANGUAGE_OPTIONS := [
	{"label": "简体中文", "locale": "zh_CN"},
	{"label": "English", "locale": "en"}
]

const FACTORY_DATA := [
	{
		"id": "workshop",
		"name": "小作坊",
		"name_en": "Workshop",
		"unlock_cost": 0.0,
		"base_income": 1.0,
		"worker_base_cost": 10.0,
		"worker_income": 1.0,
		"worker_upgrade_base_cost": 80.0,
		"factory_upgrade_base_cost": 180.0,
		"accent": Color(0.93, 0.71, 0.29)
	},
	{
		"id": "lumber",
		"name": "木材加工厂",
		"name_en": "Lumber Mill",
		"unlock_cost": 500.0,
		"base_income": 10.0,
		"worker_base_cost": 110.0,
		"worker_income": 9.0,
		"worker_upgrade_base_cost": 850.0,
		"factory_upgrade_base_cost": 1800.0,
		"accent": Color(0.35, 0.69, 0.45)
	},
	{
		"id": "food",
		"name": "食品加工厂",
		"name_en": "Food Factory",
		"unlock_cost": 5000.0,
		"base_income": 80.0,
		"worker_base_cost": 850.0,
		"worker_income": 70.0,
		"worker_upgrade_base_cost": 7500.0,
		"factory_upgrade_base_cost": 16000.0,
		"accent": Color(0.88, 0.42, 0.36)
	},
	{
		"id": "steel",
		"name": "钢铁冶炼厂",
		"name_en": "Steel Foundry",
		"unlock_cost": 50000.0,
		"base_income": 650.0,
		"worker_base_cost": 6500.0,
		"worker_income": 550.0,
		"worker_upgrade_base_cost": 62000.0,
		"factory_upgrade_base_cost": 140000.0,
		"accent": Color(0.56, 0.64, 0.72)
	},
	{
		"id": "electronics",
		"name": "电子制造厂",
		"name_en": "Electronics Plant",
		"unlock_cost": 500000.0,
		"base_income": 5200.0,
		"worker_base_cost": 52000.0,
		"worker_income": 4300.0,
		"worker_upgrade_base_cost": 520000.0,
		"factory_upgrade_base_cost": 1100000.0,
		"accent": Color(0.40, 0.67, 0.96)
	},
	{
		"id": "robotics",
		"name": "机器人装配厂",
		"name_en": "Robotics Plant",
		"unlock_cost": 10000000.0,
		"base_income": 85000.0,
		"worker_base_cost": 820000.0,
		"worker_income": 72000.0,
		"worker_upgrade_base_cost": 9000000.0,
		"factory_upgrade_base_cost": 22000000.0,
		"accent": Color(0.72, 0.48, 0.93)
	}
]

const ACHIEVEMENTS := [
	{"title": "第一枚金币", "title_en": "First Coin", "desc": "累计获得 100 金币", "desc_en": "Earn 100 coins total", "type": "coins", "target": 100.0},
	{"title": "小金库", "title_en": "Coin Pouch", "desc": "累计获得 1万 金币", "desc_en": "Earn 10,000 coins total", "type": "coins", "target": 10000.0},
	{"title": "稳定账本", "title_en": "Steady Ledger", "desc": "累计获得 10万 金币", "desc_en": "Earn 100,000 coins total", "type": "coins", "target": 100000.0},
	{"title": "百万订单", "title_en": "Million-Coin Order", "desc": "累计获得 100万 金币", "desc_en": "Earn 1,000,000 coins total", "type": "coins", "target": 1000000.0},
	{"title": "千万合同", "title_en": "Ten-Million Contract", "desc": "累计获得 1000万 金币", "desc_en": "Earn 10,000,000 coins total", "type": "coins", "target": 10000000.0},
	{"title": "金库满仓", "title_en": "Full Vault", "desc": "累计获得 1亿 金币", "desc_en": "Earn 100,000,000 coins total", "type": "coins", "target": 100000000.0},
	{"title": "地区金主", "title_en": "Regional Backer", "desc": "累计获得 10亿 金币", "desc_en": "Earn 1,000,000,000 coins total", "type": "coins", "target": 1000000000.0},
	{"title": "稳定出货", "title_en": "Steady Output", "desc": "总产能达到 10 / 秒", "desc_en": "Reach 10 coins per second", "type": "income", "target": 10.0},
	{"title": "忙碌传送带", "title_en": "Busy Conveyor", "desc": "总产能达到 100 / 秒", "desc_en": "Reach 100 coins per second", "type": "income", "target": 100.0},
	{"title": "流水线启动", "title_en": "Line Started", "desc": "总产能达到 1000 / 秒", "desc_en": "Reach 1,000 coins per second", "type": "income", "target": 1000.0},
	{"title": "昼夜订单", "title_en": "Round-the-Clock Orders", "desc": "总产能达到 1万 / 秒", "desc_en": "Reach 10,000 coins per second", "type": "income", "target": 10000.0},
	{"title": "工厂轰鸣", "title_en": "Factory Roar", "desc": "总产能达到 10万 / 秒", "desc_en": "Reach 100,000 coins per second", "type": "income", "target": 100000.0},
	{"title": "城市供货商", "title_en": "City Supplier", "desc": "总产能达到 100万 / 秒", "desc_en": "Reach 1,000,000 coins per second", "type": "income", "target": 1000000.0},
	{"title": "第一名员工", "title_en": "First Hire", "desc": "累计拥有 1 名工人", "desc_en": "Own 1 worker", "type": "workers", "target": 1},
	{"title": "小班组", "title_en": "Small Crew", "desc": "累计拥有 10 名工人", "desc_en": "Own 10 workers total", "type": "workers", "target": 10},
	{"title": "热闹车间", "title_en": "Lively Workshop", "desc": "累计拥有 25 名工人", "desc_en": "Own 25 workers total", "type": "workers", "target": 25},
	{"title": "工人大队", "title_en": "Big Crew", "desc": "累计拥有 50 名工人", "desc_en": "Own 50 workers total", "type": "workers", "target": 50},
	{"title": "百人车间", "title_en": "Hundred-Worker Shop", "desc": "累计拥有 100 名工人", "desc_en": "Own 100 workers total", "type": "workers", "target": 100},
	{"title": "人手充足", "title_en": "Fully Staffed", "desc": "累计拥有 200 名工人", "desc_en": "Own 200 workers total", "type": "workers", "target": 200},
	{"title": "木材订单", "title_en": "Lumber Contract", "desc": "解锁 2 座工厂", "desc_en": "Unlock 2 factories", "type": "unlocked", "target": 2},
	{"title": "三厂联动", "title_en": "Three-Factory Chain", "desc": "解锁 3 座工厂", "desc_en": "Unlock 3 factories", "type": "unlocked", "target": 3},
	{"title": "产业扩张", "title_en": "Industry Expansion", "desc": "解锁 4 座工厂", "desc_en": "Unlock 4 factories", "type": "unlocked", "target": 4},
	{"title": "制造网络", "title_en": "Manufacturing Network", "desc": "解锁 5 座工厂", "desc_en": "Unlock 5 factories", "type": "unlocked", "target": 5},
	{"title": "工业版图", "title_en": "Industrial Map", "desc": "解锁全部 6 座工厂", "desc_en": "Unlock all 6 factories", "type": "unlocked", "target": 6},
	{"title": "小幅扩建", "title_en": "First Expansion", "desc": "任意工厂等级达到 3", "desc_en": "Reach factory level 3 on any factory", "type": "factory_level", "target": 3},
	{"title": "加盖厂房", "title_en": "Bigger Building", "desc": "任意工厂等级达到 5", "desc_en": "Reach factory level 5 on any factory", "type": "factory_level", "target": 5},
	{"title": "成熟产线", "title_en": "Mature Line", "desc": "任意工厂等级达到 10", "desc_en": "Reach factory level 10 on any factory", "type": "factory_level", "target": 10},
	{"title": "大型厂区", "title_en": "Large Facility", "desc": "任意工厂等级达到 15", "desc_en": "Reach factory level 15 on any factory", "type": "factory_level", "target": 15},
	{"title": "超级厂房", "title_en": "Mega Facility", "desc": "任意工厂等级达到 25", "desc_en": "Reach factory level 25 on any factory", "type": "factory_level", "target": 25},
	{"title": "地标工厂", "title_en": "Landmark Factory", "desc": "任意工厂等级达到 50", "desc_en": "Reach factory level 50 on any factory", "type": "factory_level", "target": 50},
	{"title": "技能培训", "title_en": "Skill Training", "desc": "任意工人等级达到 3", "desc_en": "Reach worker level 3 on any factory", "type": "worker_level", "target": 3},
	{"title": "经验班长", "title_en": "Experienced Foreman", "desc": "任意工人等级达到 5", "desc_en": "Reach worker level 5 on any factory", "type": "worker_level", "target": 5},
	{"title": "熟练工队", "title_en": "Skilled Team", "desc": "任意工人等级达到 10", "desc_en": "Reach worker level 10 on any factory", "type": "worker_level", "target": 10},
	{"title": "专家团队", "title_en": "Expert Team", "desc": "任意工人等级达到 20", "desc_en": "Reach worker level 20 on any factory", "type": "worker_level", "target": 20},
	{"title": "点金手", "title_en": "Golden Finger", "desc": "点击收益达到 16", "desc_en": "Reach 16 coins per click", "type": "click_income", "target": 16.0},
	{"title": "一指小老板", "title_en": "One-Tap Boss", "desc": "点击收益达到 32", "desc_en": "Reach 32 coins per click", "type": "click_income", "target": 32.0},
	{"title": "高速点击", "title_en": "Fast Tapper", "desc": "点击收益达到 128", "desc_en": "Reach 128 coins per click", "type": "click_income", "target": 128.0},
	{"title": "手动订单王", "title_en": "Manual Order King", "desc": "点击收益达到 512", "desc_en": "Reach 512 coins per click", "type": "click_income", "target": 512.0},
	{"title": "黄金按钮", "title_en": "Golden Button", "desc": "点击收益达到 2048", "desc_en": "Reach 2,048 coins per click", "type": "click_income", "target": 2048.0},
	{"title": "离线小队", "title_en": "Offline Crew", "desc": "离线效率达到 50%", "desc_en": "Reach 50% offline efficiency", "type": "offline_efficiency", "target": 50},
	{"title": "无人值守", "title_en": "Unattended Shift", "desc": "离线效率达到 100%", "desc_en": "Reach 100% offline efficiency", "type": "offline_efficiency", "target": 100},
	{"title": "远程主管", "title_en": "Remote Supervisor", "desc": "离线效率达到 150%", "desc_en": "Reach 150% offline efficiency", "type": "offline_efficiency", "target": 150},
	{"title": "自动化神话", "title_en": "Automation Legend", "desc": "离线效率达到 200%", "desc_en": "Reach 200% offline efficiency", "type": "offline_efficiency", "target": 200},
	{"title": "延长班", "title_en": "Longer Shift", "desc": "离线上限达到 12 小时", "desc_en": "Reach a 12-hour offline limit", "type": "offline_limit", "target": 43200.0},
	{"title": "全天生产", "title_en": "All-Day Production", "desc": "离线上限达到 24 小时", "desc_en": "Reach a 24-hour offline limit", "type": "offline_limit", "target": 86400.0},
	{"title": "换个地区！", "title_en": "New District!", "desc": "完成 1 次换地区", "desc_en": "Change districts once", "type": "region", "target": 1},
	{"title": "再开新版图", "title_en": "Another Fresh Map", "desc": "完成 2 次换地区", "desc_en": "Change districts twice", "type": "region", "target": 2},
	{"title": "商业巡演", "title_en": "Business Tour", "desc": "完成 3 次换地区", "desc_en": "Change districts three times", "type": "region", "target": 3}
]

var coins := 0.0
var total_earned := 0.0
var selected_factory := 0
var factory_state: Array = []
var save_clock := 0.0
var has_loaded_save := false
var selected_window_size_index := 1
var effects_volume := 0.8
var music_volume := 0.55
var region_level := 0
var offline_enabled := true
var max_offline_seconds := float(MAX_OFFLINE_SECONDS)
var offline_efficiency_percent := OFFLINE_INITIAL_EFFICIENCY_PERCENT
var click_income := CLICK_INCOME_BASE
var selected_language_index := 0

var coins_label: Label
var income_label: Label
var next_goal_label: Label
var progress_bar: ProgressBar
var factory_list: VBoxContainer
var change_region_button: Button
var detail_title: Label
var detail_stats: Label
var hire_button: Button
var worker_upgrade_button: Button
var factory_upgrade_button: Button
var unlock_button: Button
var offline_upgrade_button: Button
var offline_efficiency_upgrade_button: Button
var click_upgrade_button: Button
var milestone_box: VBoxContainer
var offline_dialog: Control
var offline_message_label: Label
var factory_buttons: Array = []
var achievement_labels: Array[RichTextLabel] = []
var menu_background: TextureRect
var game_background: Control
var menu_root: Control
var game_root: Control
var menu_subtitle_label: Label
var menu_summary_label: Label
var menu_enter_button: Button
var menu_settings_button: Button
var menu_quit_button: Button
var game_title_label: Label
var game_settings_button: Button
var exit_factory_button: Button
var factories_title_label: Label
var milestone_title_label: Label
var milestone_summary_button: Button
var achievements_dialog: Control
var achievements_title_label: Label
var close_achievements_button: Button
var achievements_list: VBoxContainer
var cheat_dialog: Control
var cheat_title_label: Label
var cheat_add_coins_button: Button
var cheat_unlock_all_button: Button
var cheat_boost_factory_button: Button
var cheat_complete_region_button: Button
var cheat_close_button: Button
var settings_dialog: Control
var settings_title_label: Label
var close_settings_button: Button
var resolution_title_label: Label
var window_size_option: OptionButton
var offline_enabled_check: CheckBox
var offline_status_label: Label
var language_title_label: Label
var language_option: OptionButton
var volume_title_label: Label
var effects_volume_slider: HSlider
var effects_volume_label: Label
var music_volume_title_label: Label
var music_volume_slider: HSlider
var music_volume_label: Label
var delete_save_button: Button
var delete_save_dialog: ConfirmationDialog
var region_change_dialog: ConfirmationDialog
var farewell_dialog: AcceptDialog
var offline_title_label: Label
var offline_confirm_button: Button
var gameplay_click_blockers: Array[Control] = []
var bgm_player: AudioStreamPlayer
var button_sfx_player: AudioStreamPlayer
var game_background_image: TextureRect
var current_game_background_index := -1


func _ready() -> void:
	_initialize_state()
	_build_ui()
	_build_music_player()
	_load_game()
	_apply_settings()
	_apply_offline_income()
	_update_ui()


func _process(delta: float) -> void:
	var income: float = get_total_income_per_second()
	if income > 0.0:
		coins += income * delta
		total_earned += income * delta
	save_clock += delta
	if save_clock >= AUTOSAVE_SECONDS:
		save_clock = 0.0
		_save_game()
	_update_ui()


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key_event := event as InputEventKey
		var is_cheat_key := key_event.keycode == KEY_G or key_event.physical_keycode == KEY_G or key_event.unicode == 71 or key_event.unicode == 103
		if key_event.pressed and not key_event.echo and is_cheat_key and game_root.visible:
			if cheat_dialog.visible or not _is_blocking_dialog_open():
				_toggle_cheat_mode()
				get_viewport().set_input_as_handled()
			return
	if not game_root.visible or settings_dialog.visible or offline_dialog.visible or achievements_dialog.visible or cheat_dialog.visible or region_change_dialog.visible:
		return
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_collect_click_income(mouse_event.position)


func _is_blocking_dialog_open() -> bool:
	return settings_dialog.visible or offline_dialog.visible or achievements_dialog.visible or region_change_dialog.visible


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		_save_game()


func _initialize_state() -> void:
	factory_state.clear()
	for i in range(FACTORY_DATA.size()):
		factory_state.append({
			"unlocked": i == 0,
			"workers": 0,
			"worker_level": 1,
			"factory_level": 1
		})


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.07, 0.10, 0.16)
	background.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(background)

	_build_main_menu_background()
	_build_game_background()
	_build_main_menu()
	_build_factory_screen()
	_build_settings_dialog()
	_build_offline_dialog()
	_build_achievements_dialog()
	_build_cheat_dialog()
	_build_save_delete_dialogs()
	_show_main_menu()


func _build_main_menu_background() -> void:
	menu_background = TextureRect.new()
	menu_background.texture = _load_menu_background_texture()
	menu_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_background.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	menu_background.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(menu_background)


func _build_game_background() -> void:
	game_background = Control.new()
	game_background.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_background.visible = false
	add_child(game_background)

	game_background_image = TextureRect.new()
	game_background_image.texture = _load_fallback_background_texture()
	game_background_image.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_background_image.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	game_background_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	game_background.add_child(game_background_image)

	var dim := ColorRect.new()
	dim.color = Color(0.03, 0.06, 0.10, GAME_BACKGROUND_DIM_ALPHA)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_background.add_child(dim)


func _load_menu_background_texture() -> Texture2D:
	var texture := _load_texture_or_null(MAIN_MENU_BACKGROUND_PATH)
	if texture != null:
		return texture
	return _load_fallback_background_texture()


func _load_texture_or_null(path: String) -> Texture2D:
	if ResourceLoader.exists(path):
		var texture := load(path)
		if texture is Texture2D:
			return texture
	var image := Image.new()
	if image.load(path) == OK:
		return ImageTexture.create_from_image(image)
	return null


func _load_texture_from_png(path: String) -> Texture2D:
	var image := Image.new()
	if image.load(path) == OK:
		return ImageTexture.create_from_image(image)
	return _load_texture_or_null(path)


func _build_music_player() -> void:
	_ensure_audio_bus("SFX")
	_ensure_audio_bus("Music")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0.0)
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), false)

	bgm_player = AudioStreamPlayer.new()
	bgm_player.bus = "Music"
	bgm_player.stream = _create_bgm_loop_stream()
	add_child(bgm_player)
	bgm_player.play()

	button_sfx_player = AudioStreamPlayer.new()
	button_sfx_player.bus = "SFX"
	button_sfx_player.stream = _create_button_sfx_stream()
	add_child(button_sfx_player)


func _ensure_audio_bus(bus_name: String) -> void:
	if AudioServer.get_bus_index(bus_name) != -1:
		return
	AudioServer.add_bus()
	AudioServer.set_bus_name(AudioServer.get_bus_count() - 1, bus_name)


func _create_bgm_loop_stream() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	var frame_count := int(BGM_MIX_RATE * BGM_LOOP_SECONDS)
	var audio_data := PackedByteArray()
	audio_data.resize(frame_count * 4)

	var melody := PackedFloat64Array([262.0, 330.0, 392.0, 330.0, 294.0, 349.0, 440.0, 392.0])
	var roots := PackedFloat64Array([131.0, 175.0, 196.0, 165.0])

	for frame in range(frame_count):
		var t := float(frame) / float(BGM_MIX_RATE)
		var beat_time := fmod(t, 0.5)
		var beat := int(floor(t / 0.5)) % melody.size()
		var bar := int(floor(t / 4.0)) % roots.size()
		var note_env: float = exp(-beat_time * 5.8)
		var slow_pulse: float = 0.65 + 0.35 * sin(TAU * 0.25 * t)
		var lead: float = sin(TAU * melody[beat] * t) * 0.16 * note_env
		var bell: float = sin(TAU * melody[beat] * 2.0 * t) * 0.045 * note_env
		var pad: float = (
			sin(TAU * roots[bar] * t) +
			sin(TAU * roots[bar] * 1.5 * t) * 0.55 +
			sin(TAU * roots[bar] * 2.0 * t) * 0.38
		) * 0.055 * slow_pulse
		var bass: float = sin(TAU * roots[bar] * 0.5 * t) * 0.055
		var sample: float = clamp(lead + bell + pad + bass, -0.85, 0.85)
		var left := int(sample * 32767.0)
		var right := int((sample * 0.92 + bell * 0.18) * 32767.0)
		var offset := frame * 4
		audio_data.encode_s16(offset, left)
		audio_data.encode_s16(offset + 2, right)

	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = BGM_MIX_RATE
	stream.stereo = true
	stream.data = audio_data
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = frame_count
	return stream


func _create_button_sfx_stream() -> AudioStreamWAV:
	var stream := AudioStreamWAV.new()
	var frame_count := int(BGM_MIX_RATE * BUTTON_SFX_SECONDS)
	var audio_data := PackedByteArray()
	audio_data.resize(frame_count * 4)

	for frame in range(frame_count):
		var t := float(frame) / float(BGM_MIX_RATE)
		var normalized := t / BUTTON_SFX_SECONDS
		var attack: float = clamp(t / 0.018, 0.0, 1.0)
		var release: float = pow(max(1.0 - normalized, 0.0), 2.8)
		var pitch_slide: float = lerp(560.0, 420.0, normalized)
		var tone: float = sin(TAU * pitch_slide * t) * 0.22
		var warm_body: float = sin(TAU * 210.0 * t) * 0.10
		var sparkle: float = sin(TAU * 840.0 * t) * 0.035
		var sample: float = clamp((tone + warm_body + sparkle) * attack * release, -0.75, 0.75)
		var stereo_width: float = sin(TAU * 6.0 * t) * 0.04
		var left := int(sample * (1.0 - stereo_width) * 32767.0)
		var right := int(sample * (1.0 + stereo_width) * 32767.0)
		var offset := frame * 4
		audio_data.encode_s16(offset, left)
		audio_data.encode_s16(offset + 2, right)

	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = BGM_MIX_RATE
	stream.stereo = true
	stream.data = audio_data
	return stream


func _build_main_menu() -> void:
	menu_root = MarginContainer.new()
	menu_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_root.add_theme_constant_override("margin_left", 36)
	menu_root.add_theme_constant_override("margin_right", 36)
	menu_root.add_theme_constant_override("margin_top", 36)
	menu_root.add_theme_constant_override("margin_bottom", 36)
	add_child(menu_root)

	var menu_center := CenterContainer.new()
	menu_center.set_anchors_preset(Control.PRESET_FULL_RECT)
	menu_root.add_child(menu_center)

	var menu_page := VBoxContainer.new()
	menu_page.custom_minimum_size = Vector2(980, 0)
	menu_page.alignment = BoxContainer.ALIGNMENT_CENTER
	menu_page.add_theme_constant_override("separation", 14)
	menu_center.add_child(menu_page)

	var title_center := CenterContainer.new()
	title_center.custom_minimum_size = Vector2(980, 280)
	menu_page.add_child(title_center)

	var title_logo := TextureRect.new()
	title_logo.texture = _load_texture_or_null(MAIN_MENU_LOGO_PATH)
	title_logo.custom_minimum_size = Vector2(920, 300)
	title_logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	title_logo.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	title_logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	title_center.add_child(title_logo)

	var menu_panel := PanelContainer.new()
	menu_panel.custom_minimum_size = Vector2(540, 0)
	menu_panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu_panel.add_theme_stylebox_override("panel", _make_main_menu_fallback_style())
	menu_page.add_child(menu_panel)

	var menu_panel_margin := MarginContainer.new()
	menu_panel_margin.add_theme_constant_override("margin_left", 24)
	menu_panel_margin.add_theme_constant_override("margin_right", 24)
	menu_panel_margin.add_theme_constant_override("margin_top", 18)
	menu_panel_margin.add_theme_constant_override("margin_bottom", 22)
	menu_panel.add_child(menu_panel_margin)

	var menu_panel_content := VBoxContainer.new()
	menu_panel_content.add_theme_constant_override("separation", 12)
	menu_panel_margin.add_child(menu_panel_content)

	menu_subtitle_label = Label.new()
	menu_subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_subtitle_label.add_theme_font_size_override("font_size", 19)
	menu_subtitle_label.add_theme_color_override("font_color", Color(0.90, 0.95, 1.0))
	_apply_menu_label_shadow(menu_subtitle_label)
	menu_panel_content.add_child(menu_subtitle_label)

	menu_summary_label = Label.new()
	menu_summary_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	menu_summary_label.add_theme_font_size_override("font_size", 20)
	menu_summary_label.add_theme_color_override("font_color", Color(1.0, 0.86, 0.27))
	_apply_menu_label_shadow(menu_summary_label)
	menu_panel_content.add_child(menu_summary_label)

	var menu_buttons := VBoxContainer.new()
	menu_buttons.custom_minimum_size = Vector2(320, 0)
	menu_buttons.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	menu_buttons.add_theme_constant_override("separation", 10)
	menu_panel_content.add_child(menu_buttons)

	menu_enter_button = _make_menu_button("")
	menu_enter_button.pressed.connect(_enter_factory)
	menu_buttons.add_child(menu_enter_button)

	menu_settings_button = _make_menu_button("")
	menu_settings_button.pressed.connect(_open_settings)
	menu_buttons.add_child(menu_settings_button)

	menu_quit_button = _make_menu_button("")
	menu_quit_button.pressed.connect(_quit_game)
	menu_buttons.add_child(menu_quit_button)


func _build_factory_screen() -> void:
	gameplay_click_blockers.clear()

	game_root = MarginContainer.new()
	game_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	game_root.add_theme_constant_override("margin_left", 16)
	game_root.add_theme_constant_override("margin_right", 16)
	game_root.add_theme_constant_override("margin_top", 12)
	game_root.add_theme_constant_override("margin_bottom", 12)
	add_child(game_root)

	var page := VBoxContainer.new()
	page.add_theme_constant_override("separation", 8)
	game_root.add_child(page)

	var top := HBoxContainer.new()
	top.add_theme_constant_override("separation", 12)
	page.add_child(top)
	gameplay_click_blockers.append(top)

	game_title_label = Label.new()
	game_title_label.add_theme_font_size_override("font_size", 28)
	game_title_label.add_theme_color_override("font_color", Color(0.95, 0.96, 0.98))
	top.add_child(game_title_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(spacer)

	coins_label = Label.new()
	coins_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	coins_label.add_theme_font_size_override("font_size", 22)
	coins_label.add_theme_color_override("font_color", Color(0.98, 0.84, 0.36))
	top.add_child(coins_label)

	game_settings_button = Button.new()
	game_settings_button.custom_minimum_size = Vector2(86, 34)
	game_settings_button.pressed.connect(_open_settings)
	_wire_button_sound(game_settings_button)
	top.add_child(game_settings_button)

	exit_factory_button = Button.new()
	exit_factory_button.custom_minimum_size = Vector2(120, 34)
	exit_factory_button.pressed.connect(_exit_factory)
	_wire_button_sound(exit_factory_button)
	top.add_child(exit_factory_button)

	var status_row := HBoxContainer.new()
	status_row.add_theme_constant_override("separation", 12)
	page.add_child(status_row)
	gameplay_click_blockers.append(status_row)

	next_goal_label = Label.new()
	next_goal_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	next_goal_label.add_theme_font_size_override("font_size", 15)
	next_goal_label.add_theme_color_override("font_color", Color(0.86, 0.90, 0.96))
	status_row.add_child(next_goal_label)

	income_label = Label.new()
	income_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	income_label.add_theme_font_size_override("font_size", 15)
	income_label.add_theme_color_override("font_color", Color(0.74, 0.82, 0.92))
	status_row.add_child(income_label)

	progress_bar = ProgressBar.new()
	progress_bar.min_value = 0
	progress_bar.max_value = 1
	progress_bar.value = 0
	progress_bar.custom_minimum_size = Vector2(0, 12)
	progress_bar.show_percentage = false
	progress_bar.add_theme_stylebox_override("background", _make_progress_background_style())
	progress_bar.add_theme_stylebox_override("fill", _make_progress_fill_style())
	page.add_child(progress_bar)
	gameplay_click_blockers.append(progress_bar)

	var content := HBoxContainer.new()
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	content.add_theme_constant_override("separation", 12)
	page.add_child(content)

	var left_panel := _make_textured_panel(PANEL_FACTORY_LIST_PATH)
	left_panel.custom_minimum_size = Vector2(390, 0)
	content.add_child(left_panel)

	var left_margin := MarginContainer.new()
	left_margin.add_theme_constant_override("margin_left", 54)
	left_margin.add_theme_constant_override("margin_right", 54)
	left_margin.add_theme_constant_override("margin_top", 50)
	left_margin.add_theme_constant_override("margin_bottom", 40)
	left_panel.add_child(left_margin)

	var left_content := VBoxContainer.new()
	left_content.add_theme_constant_override("separation", 8)
	left_margin.add_child(left_content)

	factories_title_label = Label.new()
	factories_title_label.add_theme_font_size_override("font_size", 20)
	factories_title_label.add_theme_color_override("font_color", Color.WHITE)
	left_content.add_child(factories_title_label)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	left_content.add_child(scroll)

	factory_list = VBoxContainer.new()
	factory_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	factory_list.add_theme_constant_override("separation", 6)
	scroll.add_child(factory_list)
	_create_factory_buttons()

	change_region_button = _make_action_button("")
	change_region_button.custom_minimum_size = Vector2(0, 46)
	change_region_button.pressed.connect(_request_change_region)
	left_content.add_child(change_region_button)
	gameplay_click_blockers.append(change_region_button)

	var right := VBoxContainer.new()
	right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	right.add_theme_constant_override("separation", 10)
	content.add_child(right)

	var detail_panel := _make_textured_panel(PANEL_DETAIL_PATH)
	detail_panel.custom_minimum_size = Vector2(0, 400)
	right.add_child(detail_panel)

	var detail_margin := MarginContainer.new()
	detail_margin.add_theme_constant_override("margin_left", 76)
	detail_margin.add_theme_constant_override("margin_right", 48)
	detail_margin.add_theme_constant_override("margin_top", 54)
	detail_margin.add_theme_constant_override("margin_bottom", 22)
	detail_panel.add_child(detail_margin)

	var detail_content := VBoxContainer.new()
	detail_content.add_theme_constant_override("separation", 8)
	detail_margin.add_child(detail_content)

	detail_title = Label.new()
	detail_title.add_theme_font_size_override("font_size", 24)
	detail_title.add_theme_color_override("font_color", Color.WHITE)
	detail_content.add_child(detail_title)

	detail_stats = Label.new()
	detail_stats.add_theme_font_size_override("font_size", 15)
	detail_stats.add_theme_color_override("font_color", Color(0.82, 0.88, 0.96))
	detail_stats.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	detail_content.add_child(detail_stats)

	var action_grid := GridContainer.new()
	action_grid.columns = 2
	action_grid.add_theme_constant_override("h_separation", 8)
	action_grid.add_theme_constant_override("v_separation", 8)
	detail_content.add_child(action_grid)

	hire_button = _make_action_button("")
	hire_button.pressed.connect(_on_hire_pressed)
	action_grid.add_child(hire_button)
	gameplay_click_blockers.append(hire_button)

	worker_upgrade_button = _make_action_button("")
	worker_upgrade_button.pressed.connect(_on_worker_upgrade_pressed)
	action_grid.add_child(worker_upgrade_button)
	gameplay_click_blockers.append(worker_upgrade_button)

	factory_upgrade_button = _make_action_button("")
	factory_upgrade_button.pressed.connect(_on_factory_upgrade_pressed)
	action_grid.add_child(factory_upgrade_button)
	gameplay_click_blockers.append(factory_upgrade_button)

	offline_upgrade_button = _make_action_button("")
	offline_upgrade_button.pressed.connect(_on_offline_upgrade_pressed)
	action_grid.add_child(offline_upgrade_button)
	gameplay_click_blockers.append(offline_upgrade_button)

	offline_efficiency_upgrade_button = _make_action_button("")
	offline_efficiency_upgrade_button.pressed.connect(_on_offline_efficiency_upgrade_pressed)
	action_grid.add_child(offline_efficiency_upgrade_button)
	gameplay_click_blockers.append(offline_efficiency_upgrade_button)

	click_upgrade_button = _make_action_button("")
	click_upgrade_button.pressed.connect(_on_click_upgrade_pressed)
	action_grid.add_child(click_upgrade_button)
	gameplay_click_blockers.append(click_upgrade_button)

	unlock_button = _make_action_button("")
	unlock_button.pressed.connect(_on_unlock_pressed)
	unlock_button.custom_minimum_size = Vector2(0, 42)
	detail_content.add_child(unlock_button)
	gameplay_click_blockers.append(unlock_button)

	var milestone_panel := _make_textured_panel(PANEL_GOAL_PATH)
	milestone_panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	milestone_panel.custom_minimum_size = Vector2(0, 160)
	milestone_panel.mouse_filter = Control.MOUSE_FILTER_STOP
	milestone_panel.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	milestone_panel.gui_input.connect(_on_achievement_panel_gui_input)
	right.add_child(milestone_panel)
	gameplay_click_blockers.append(milestone_panel)

	var milestone_margin := MarginContainer.new()
	milestone_margin.add_theme_constant_override("margin_left", 76)
	milestone_margin.add_theme_constant_override("margin_right", 48)
	milestone_margin.add_theme_constant_override("margin_top", 54)
	milestone_margin.add_theme_constant_override("margin_bottom", 18)
	milestone_panel.add_child(milestone_margin)

	var milestone_content := VBoxContainer.new()
	milestone_content.add_theme_constant_override("separation", 6)
	milestone_margin.add_child(milestone_content)

	milestone_title_label = Label.new()
	milestone_title_label.add_theme_font_size_override("font_size", 18)
	milestone_title_label.add_theme_color_override("font_color", Color.WHITE)
	milestone_content.add_child(milestone_title_label)

	milestone_box = VBoxContainer.new()
	milestone_box.add_theme_constant_override("separation", 3)
	milestone_content.add_child(milestone_box)

	milestone_summary_button = _make_action_button("")
	milestone_summary_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	milestone_summary_button.custom_minimum_size = Vector2(0, 64)
	milestone_summary_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_apply_achievement_summary_button_style(milestone_summary_button)
	milestone_box.add_child(milestone_summary_button)

func _build_settings_dialog() -> void:
	settings_dialog = Control.new()
	settings_dialog.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_dialog.mouse_filter = Control.MOUSE_FILTER_STOP
	settings_dialog.visible = false
	add_child(settings_dialog)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.05, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_dialog.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	settings_dialog.add_child(center)

	var panel := _make_textured_panel(PANEL_SETTINGS_MODAL_PATH)
	panel.custom_minimum_size = Vector2(560, 570)
	center.add_child(panel)

	var settings_margin := MarginContainer.new()
	settings_margin.add_theme_constant_override("margin_left", 56)
	settings_margin.add_theme_constant_override("margin_right", 56)
	settings_margin.add_theme_constant_override("margin_top", 50)
	settings_margin.add_theme_constant_override("margin_bottom", 38)
	panel.add_child(settings_margin)

	var settings_content := VBoxContainer.new()
	settings_content.add_theme_constant_override("separation", 12)
	settings_margin.add_child(settings_content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	settings_content.add_child(header)

	settings_title_label = Label.new()
	settings_title_label.add_theme_font_size_override("font_size", 26)
	settings_title_label.add_theme_color_override("font_color", Color.WHITE)
	header.add_child(settings_title_label)

	var header_spacer := Control.new()
	header_spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(header_spacer)

	close_settings_button = Button.new()
	close_settings_button.custom_minimum_size = Vector2(86, 38)
	close_settings_button.pressed.connect(_close_settings)
	_wire_button_sound(close_settings_button)
	header.add_child(close_settings_button)

	resolution_title_label = Label.new()
	_apply_settings_caption_style(resolution_title_label)
	settings_content.add_child(resolution_title_label)

	window_size_option = OptionButton.new()
	window_size_option.custom_minimum_size = Vector2(0, 42)
	for option in WINDOW_SIZE_OPTIONS:
		window_size_option.add_item(option["label"])
	window_size_option.item_selected.connect(_on_window_size_selected)
	_wire_button_sound(window_size_option)
	settings_content.add_child(window_size_option)

	volume_title_label = Label.new()
	_apply_settings_caption_style(volume_title_label)
	settings_content.add_child(volume_title_label)

	var volume_row := HBoxContainer.new()
	volume_row.add_theme_constant_override("separation", 12)
	settings_content.add_child(volume_row)

	effects_volume_slider = HSlider.new()
	effects_volume_slider.min_value = 0
	effects_volume_slider.max_value = 100
	effects_volume_slider.step = 1
	effects_volume_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	effects_volume_slider.value_changed.connect(_on_effects_volume_changed)
	volume_row.add_child(effects_volume_slider)

	effects_volume_label = Label.new()
	effects_volume_label.custom_minimum_size = Vector2(56, 0)
	effects_volume_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	volume_row.add_child(effects_volume_label)

	music_volume_title_label = Label.new()
	_apply_settings_caption_style(music_volume_title_label)
	settings_content.add_child(music_volume_title_label)

	var music_volume_row := HBoxContainer.new()
	music_volume_row.add_theme_constant_override("separation", 12)
	settings_content.add_child(music_volume_row)

	music_volume_slider = HSlider.new()
	music_volume_slider.min_value = 0
	music_volume_slider.max_value = 100
	music_volume_slider.step = 1
	music_volume_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	music_volume_slider.value_changed.connect(_on_music_volume_changed)
	music_volume_row.add_child(music_volume_slider)

	music_volume_label = Label.new()
	music_volume_label.custom_minimum_size = Vector2(56, 0)
	music_volume_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	music_volume_row.add_child(music_volume_label)

	offline_enabled_check = CheckBox.new()
	offline_enabled_check.text = "离线收益"
	offline_enabled_check.toggled.connect(_on_offline_enabled_toggled)
	_wire_button_sound(offline_enabled_check)
	settings_content.add_child(offline_enabled_check)

	offline_status_label = Label.new()
	offline_status_label.add_theme_font_size_override("font_size", 15)
	offline_status_label.add_theme_color_override("font_color", Color(0.78, 0.86, 0.95))
	offline_status_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	settings_content.add_child(offline_status_label)

	language_title_label = Label.new()
	_apply_settings_caption_style(language_title_label)
	settings_content.add_child(language_title_label)

	language_option = OptionButton.new()
	language_option.custom_minimum_size = Vector2(0, 42)
	for option in LANGUAGE_OPTIONS:
		language_option.add_item(option["label"])
	language_option.item_selected.connect(_on_language_selected)
	_wire_button_sound(language_option)
	settings_content.add_child(language_option)

	delete_save_button = Button.new()
	delete_save_button.custom_minimum_size = Vector2(0, 46)
	delete_save_button.pressed.connect(_request_delete_save)
	_wire_button_sound(delete_save_button)
	settings_content.add_child(delete_save_button)


func _build_offline_dialog() -> void:
	offline_dialog = Control.new()
	offline_dialog.set_anchors_preset(Control.PRESET_FULL_RECT)
	offline_dialog.mouse_filter = Control.MOUSE_FILTER_STOP
	offline_dialog.visible = false
	add_child(offline_dialog)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.05, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	offline_dialog.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	offline_dialog.add_child(center)

	var panel := _make_textured_panel(PANEL_SETTINGS_MODAL_PATH)
	panel.custom_minimum_size = Vector2(540, 320)
	center.add_child(panel)

	var offline_margin := MarginContainer.new()
	offline_margin.add_theme_constant_override("margin_left", 70)
	offline_margin.add_theme_constant_override("margin_right", 82)
	offline_margin.add_theme_constant_override("margin_top", 50)
	offline_margin.add_theme_constant_override("margin_bottom", 58)
	panel.add_child(offline_margin)

	var offline_content := VBoxContainer.new()
	offline_content.add_theme_constant_override("separation", 14)
	offline_margin.add_child(offline_content)

	offline_title_label = Label.new()
	offline_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	offline_title_label.add_theme_font_size_override("font_size", 26)
	offline_title_label.add_theme_color_override("font_color", Color.WHITE)
	offline_content.add_child(offline_title_label)

	offline_message_label = Label.new()
	offline_message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	offline_message_label.add_theme_font_size_override("font_size", 17)
	offline_message_label.add_theme_color_override("font_color", Color(0.82, 0.88, 0.96))
	offline_message_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	offline_message_label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	offline_content.add_child(offline_message_label)

	offline_confirm_button = _make_menu_button("")
	offline_confirm_button.custom_minimum_size = Vector2(0, 44)
	offline_confirm_button.pressed.connect(_close_offline_dialog)
	offline_content.add_child(offline_confirm_button)


func _build_achievements_dialog() -> void:
	achievements_dialog = Control.new()
	achievements_dialog.set_anchors_preset(Control.PRESET_FULL_RECT)
	achievements_dialog.mouse_filter = Control.MOUSE_FILTER_STOP
	achievements_dialog.visible = false
	add_child(achievements_dialog)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.05, 0.72)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	achievements_dialog.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	achievements_dialog.add_child(center)

	var panel := _make_textured_panel(PANEL_SETTINGS_MODAL_PATH)
	panel.custom_minimum_size = Vector2(760, 590)
	center.add_child(panel)

	var achievements_margin := MarginContainer.new()
	achievements_margin.add_theme_constant_override("margin_left", 58)
	achievements_margin.add_theme_constant_override("margin_right", 58)
	achievements_margin.add_theme_constant_override("margin_top", 50)
	achievements_margin.add_theme_constant_override("margin_bottom", 38)
	panel.add_child(achievements_margin)

	var achievements_content := VBoxContainer.new()
	achievements_content.add_theme_constant_override("separation", 12)
	achievements_margin.add_child(achievements_content)

	var header := HBoxContainer.new()
	header.add_theme_constant_override("separation", 12)
	achievements_content.add_child(header)

	achievements_title_label = Label.new()
	achievements_title_label.add_theme_font_size_override("font_size", 26)
	achievements_title_label.add_theme_color_override("font_color", Color.WHITE)
	header.add_child(achievements_title_label)

	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(spacer)

	close_achievements_button = Button.new()
	close_achievements_button.custom_minimum_size = Vector2(86, 38)
	close_achievements_button.pressed.connect(_close_achievements)
	_wire_button_sound(close_achievements_button)
	header.add_child(close_achievements_button)

	var scroll := ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	achievements_content.add_child(scroll)

	achievements_list = VBoxContainer.new()
	achievements_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	achievements_list.add_theme_constant_override("separation", 8)
	scroll.add_child(achievements_list)
	_create_achievement_labels()


func _build_cheat_dialog() -> void:
	cheat_dialog = Control.new()
	cheat_dialog.set_anchors_preset(Control.PRESET_FULL_RECT)
	cheat_dialog.mouse_filter = Control.MOUSE_FILTER_STOP
	cheat_dialog.visible = false
	add_child(cheat_dialog)

	var dim := ColorRect.new()
	dim.color = Color(0.02, 0.03, 0.05, 0.62)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	cheat_dialog.add_child(dim)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	cheat_dialog.add_child(center)

	var panel := _make_textured_panel(PANEL_SETTINGS_MODAL_PATH)
	panel.custom_minimum_size = Vector2(460, 430)
	center.add_child(panel)

	var cheat_margin := MarginContainer.new()
	cheat_margin.add_theme_constant_override("margin_left", 54)
	cheat_margin.add_theme_constant_override("margin_right", 54)
	cheat_margin.add_theme_constant_override("margin_top", 46)
	cheat_margin.add_theme_constant_override("margin_bottom", 34)
	panel.add_child(cheat_margin)

	var cheat_content := VBoxContainer.new()
	cheat_content.add_theme_constant_override("separation", 12)
	cheat_margin.add_child(cheat_content)

	cheat_title_label = Label.new()
	cheat_title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cheat_title_label.add_theme_font_size_override("font_size", 26)
	cheat_title_label.add_theme_color_override("font_color", Color.WHITE)
	cheat_content.add_child(cheat_title_label)

	cheat_add_coins_button = _make_menu_button("")
	cheat_add_coins_button.pressed.connect(_cheat_add_coins)
	cheat_content.add_child(cheat_add_coins_button)

	cheat_unlock_all_button = _make_menu_button("")
	cheat_unlock_all_button.pressed.connect(_cheat_unlock_all_factories)
	cheat_content.add_child(cheat_unlock_all_button)

	cheat_boost_factory_button = _make_menu_button("")
	cheat_boost_factory_button.pressed.connect(_cheat_boost_current_factory)
	cheat_content.add_child(cheat_boost_factory_button)

	cheat_complete_region_button = _make_menu_button("")
	cheat_complete_region_button.pressed.connect(_cheat_complete_region)
	cheat_content.add_child(cheat_complete_region_button)

	cheat_close_button = _make_menu_button("")
	cheat_close_button.pressed.connect(_close_cheat_mode)
	cheat_content.add_child(cheat_close_button)


func _build_save_delete_dialogs() -> void:
	delete_save_dialog = ConfirmationDialog.new()
	delete_save_dialog.title = "删除存档"
	delete_save_dialog.dialog_text = "真的要抛弃你的工厂和员工吗？"
	delete_save_dialog.confirmed.connect(_delete_save_confirmed)
	add_child(delete_save_dialog)
	_apply_save_dialog_style(delete_save_dialog)
	_wire_button_sound(delete_save_dialog.get_ok_button())
	_wire_button_sound(delete_save_dialog.get_cancel_button())

	region_change_dialog = ConfirmationDialog.new()
	region_change_dialog.title = "换个地区！"
	region_change_dialog.dialog_text = "确定要换个地区再来展示一次你的商业才能吗？\n你将重新开始，但是收益更高。"
	region_change_dialog.confirmed.connect(_change_region_confirmed)
	add_child(region_change_dialog)
	_apply_save_dialog_style(region_change_dialog)
	_wire_button_sound(region_change_dialog.get_ok_button())
	_wire_button_sound(region_change_dialog.get_cancel_button())

	farewell_dialog = AcceptDialog.new()
	farewell_dialog.title = "存档已删除"
	farewell_dialog.dialog_text = "他们会想你的。"
	add_child(farewell_dialog)
	_apply_save_dialog_style(farewell_dialog)
	_wire_button_sound(farewell_dialog.get_ok_button())


func _make_panel() -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.11, 0.15, 0.23, GAME_PANEL_TEXTURE_ALPHA)
	style.border_color = Color(0.22, 0.29, 0.41, 0.90)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _apply_save_dialog_style(dialog: AcceptDialog) -> void:
	dialog.add_theme_font_size_override("title_font_size", 22)
	dialog.add_theme_color_override("title_color", Color(0.94, 0.97, 1.0))

	var label := dialog.get_label()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("font_size", 21)
	label.add_theme_color_override("font_color", Color(0.95, 0.97, 1.0))

	var ok_button := dialog.get_ok_button()
	ok_button.custom_minimum_size = Vector2(96, 42)
	ok_button.add_theme_font_size_override("font_size", 18)

	if dialog is ConfirmationDialog:
		var cancel_button := (dialog as ConfirmationDialog).get_cancel_button()
		cancel_button.custom_minimum_size = Vector2(96, 42)
		cancel_button.add_theme_font_size_override("font_size", 18)


func _make_textured_panel(texture_path: String) -> PanelContainer:
	var texture := _load_texture_or_null(texture_path)
	if texture == null:
		return _make_panel()

	var panel := PanelContainer.new()
	var style := StyleBoxTexture.new()
	style.texture = texture
	style.modulate_color = Color(1.0, 1.0, 1.0, GAME_PANEL_TEXTURE_ALPHA)
	style.draw_center = true
	style.set_texture_margin(SIDE_LEFT, PANEL_SLICE_MARGIN)
	style.set_texture_margin(SIDE_TOP, PANEL_SLICE_MARGIN)
	style.set_texture_margin(SIDE_RIGHT, PANEL_SLICE_MARGIN)
	style.set_texture_margin(SIDE_BOTTOM, PANEL_SLICE_MARGIN)
	style.set_content_margin(SIDE_LEFT, 0.0)
	style.set_content_margin(SIDE_TOP, 0.0)
	style.set_content_margin(SIDE_RIGHT, 0.0)
	style.set_content_margin(SIDE_BOTTOM, 0.0)
	panel.add_theme_stylebox_override("panel", style)
	return panel


func _make_main_menu_fallback_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.05, 0.08, 0.11, 0.72)
	style.border_color = Color(0.52, 0.78, 1.0, 0.42)
	style.set_border_width_all(2)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style


func _apply_menu_label_shadow(label: Label) -> void:
	label.add_theme_color_override("font_shadow_color", Color(0.01, 0.03, 0.06, 0.95))
	label.add_theme_constant_override("shadow_offset_x", 2)
	label.add_theme_constant_override("shadow_offset_y", 2)
	label.add_theme_constant_override("shadow_outline_size", 3)


func _make_action_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 38)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color(0.95, 0.98, 1.0))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.88, 0.36))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.78, 0.20))
	button.add_theme_stylebox_override("normal", _make_button_style(Color(0.11, 0.18, 0.26, 0.92), Color(0.42, 0.58, 0.74, 0.68), 4))
	button.add_theme_stylebox_override("hover", _make_button_style(Color(0.15, 0.24, 0.34, 0.96), Color(0.96, 0.72, 0.24, 0.88), 4))
	button.add_theme_stylebox_override("pressed", _make_button_style(Color(0.08, 0.13, 0.20, 0.98), Color(1.0, 0.62, 0.16, 0.95), 4))
	button.add_theme_stylebox_override("disabled", _make_button_style(Color(0.07, 0.10, 0.15, 0.78), Color(0.25, 0.33, 0.43, 0.65), 4))
	button.add_theme_color_override("font_disabled_color", Color(0.52, 0.62, 0.72))
	_wire_button_sound(button)
	return button


func _apply_settings_caption_style(label: Label) -> void:
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.92, 0.96, 1.0))
	label.add_theme_color_override("font_shadow_color", Color(0.02, 0.04, 0.07, 0.85))
	label.add_theme_constant_override("shadow_offset_x", 1)
	label.add_theme_constant_override("shadow_offset_y", 1)


func _apply_achievement_summary_button_style(button: Button) -> void:
	button.add_theme_stylebox_override("normal", _make_plain_content_style(Color(0.0, 0.0, 0.0, 0.0)))
	button.add_theme_stylebox_override("hover", _make_plain_content_style(Color(0.15, 0.24, 0.34, 0.28)))
	button.add_theme_stylebox_override("pressed", _make_plain_content_style(Color(0.08, 0.13, 0.20, 0.36)))
	button.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	button.add_theme_color_override("font_color", Color(0.92, 0.96, 1.0))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.88, 0.36))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.78, 0.20))


func _wire_button_sound(button: BaseButton) -> void:
	var sound_callable := Callable(self, "_play_button_sound")
	if not button.pressed.is_connected(sound_callable):
		button.pressed.connect(sound_callable)


func _play_button_sound() -> void:
	if button_sfx_player == null or effects_volume <= 0.0:
		return
	button_sfx_player.stop()
	button_sfx_player.play()


func _make_plain_content_style(background_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background_color
	style.set_border_width_all(0)
	style.corner_radius_top_left = 4
	style.corner_radius_top_right = 4
	style.corner_radius_bottom_left = 4
	style.corner_radius_bottom_right = 4
	style.set_content_margin(SIDE_LEFT, 0)
	style.set_content_margin(SIDE_RIGHT, 0)
	style.set_content_margin(SIDE_TOP, 2)
	style.set_content_margin(SIDE_BOTTOM, 2)
	return style


func _make_menu_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 48)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.add_theme_font_size_override("font_size", 20)
	button.add_theme_color_override("font_color", Color(0.96, 0.98, 1.0))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.90, 0.45))
	button.add_theme_color_override("font_pressed_color", Color(1.0, 0.84, 0.30))
	button.add_theme_stylebox_override("normal", _make_menu_button_style(Color(0.08, 0.10, 0.13, 0.78), Color(0.52, 0.78, 1.0, 0.44)))
	button.add_theme_stylebox_override("hover", _make_menu_button_style(Color(0.13, 0.20, 0.28, 0.90), Color(1.0, 0.78, 0.26, 0.82)))
	button.add_theme_stylebox_override("pressed", _make_menu_button_style(Color(0.06, 0.09, 0.12, 0.94), Color(1.0, 0.68, 0.18, 0.92)))
	_wire_button_sound(button)
	return button


func _make_menu_button_style(background_color: Color, border_color: Color) -> StyleBoxFlat:
	return _make_button_style(background_color, border_color, 4)


func _make_button_style(background_color: Color, border_color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.corner_radius_top_left = radius
	style.corner_radius_top_right = radius
	style.corner_radius_bottom_left = radius
	style.corner_radius_bottom_right = radius
	style.set_content_margin(SIDE_LEFT, 12)
	style.set_content_margin(SIDE_RIGHT, 12)
	style.set_content_margin(SIDE_TOP, 8)
	style.set_content_margin(SIDE_BOTTOM, 8)
	return style


func _make_factory_button_style(background_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := _make_button_style(background_color, border_color, 5)
	style.set_content_margin(SIDE_LEFT, 12)
	style.set_content_margin(SIDE_RIGHT, 10)
	style.set_content_margin(SIDE_TOP, 7)
	style.set_content_margin(SIDE_BOTTOM, 7)
	return style


func _make_progress_background_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.06, 0.10, 0.15, 0.94)
	style.border_color = Color(0.30, 0.42, 0.55, 0.85)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	return style


func _make_progress_fill_style() -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(1.0, 0.72, 0.18, 0.95)
	style.border_color = Color(1.0, 0.86, 0.36, 0.95)
	style.set_border_width_all(1)
	style.corner_radius_top_left = 3
	style.corner_radius_top_right = 3
	style.corner_radius_bottom_left = 3
	style.corner_radius_bottom_right = 3
	return style


func T(key: String) -> String:
	var en := selected_language_index == 1
	match key:
		"game_title":
			return "Idle Factory Tycoon" if en else "挂机工厂大亨"
		"menu_subtitle":
			return "Expand production lines, hire workers, and build your factory empire" if en else "扩建生产线，雇佣工人，打造你的工厂帝国"
		"enter_factory":
			return "Enter Factory" if en else "进入工厂"
		"settings":
			return "Settings" if en else "设置"
		"quit_game":
			return "Quit Game" if en else "退出游戏"
		"change_region":
			return "New Region!" if en else "换个地区！"
		"change_region_locked":
			return "Unlock all factories first" if en else "解锁全部工厂后可用"
		"change_region_confirm_title":
			return "New Region!" if en else "换个地区！"
		"change_region_confirm":
			return "Move to a new region and show your business talent again?\nYou will start over, but future income will be higher." if en else "确定要换个地区再来展示一次你的商业才能吗？\n你将重新开始，但是收益更高。"
		"cheat_mode":
			return "Cheat Mode" if en else "作弊模式"
		"cheat_add_coins":
			return "Add 1B Coins" if en else "增加 10亿 金币"
		"cheat_unlock_all":
			return "Unlock All Factories" if en else "解锁全部工厂"
		"cheat_boost_factory":
			return "Boost Current Factory" if en else "强化当前工厂"
		"cheat_complete_region":
			return "Complete Current Region" if en else "完成当前地区"
		"exit_factory":
			return "Exit Factory" if en else "退出工厂"
		"coins":
			return "Coins" if en else "金币"
		"current_coins":
			return "Current Coins" if en else "当前金币"
		"total_output":
			return "Total Output" if en else "总产能"
		"sec":
			return "sec" if en else "秒"
		"factory_list":
			return "Factories" if en else "工厂列表"
		"milestones":
			return "Milestones" if en else "阶段目标"
		"achievement_system":
			return "Achievement Goals" if en else "成就目标"
		"open_achievements":
			return "Open achievement details" if en else "点击查看全部成就"
		"achievement_complete":
			return "Completed" if en else "已完成"
		"achievement_locked":
			return "In Progress" if en else "进行中"
		"achievement_summary":
			return "Completed %d / %d\nNext: %s\n%s" if en else "已完成 %d / %d\n下一个：%s\n%s"
		"all_achievements_done":
			return "All achievements completed" if en else "全部成就已完成"
		"window_size":
			return "Window Size" if en else "窗口大小"
		"effects_volume":
			return "SFX Volume" if en else "音效音量"
		"music_volume":
			return "Music Volume" if en else "背景音乐音量"
		"offline_income":
			return "Offline Income" if en else "离线收益"
		"language":
			return "Language" if en else "语言"
		"delete_save":
			return "Delete Save" if en else "删除存档"
		"close":
			return "Close" if en else "关闭"
		"confirm":
			return "Confirm" if en else "确认"
		"enabled":
			return "On" if en else "开启"
		"disabled":
			return "Off" if en else "关闭"
		"max_settlement":
			return "max settlement" if en else "最多结算"
		"all_unlocked_goal":
			return "All factories are unlocked. You can move to a new region now." if en else "所有工厂都已解锁，可以换个地区了。"
		"next_goal":
			return "Next goal: unlock %s (%s / %s)" if en else "下一个目标：解锁%s（%s / %s）"
		"locked":
			return "Locked" if en else "未解锁"
		"production":
			return "Output" if en else "产能"
		"workers":
			return "Workers" if en else "工人"
		"done":
			return "Done" if en else "已完成"
		"in_progress":
			return "In Progress" if en else "进行中"
		"factory_locked_detail":
			return "This factory is locked.\nUnlock cost: %s\nAdvanced factories start fresh, but have higher base output." if en else "这座工厂尚未解锁。\n解锁费用：%s\n高级工厂会从新一轮招聘开始，但基础产能更高。"
		"unlock":
			return "Unlock" if en else "解锁"
		"factory_income":
			return "Factory output" if en else "工厂收益"
		"base_income":
			return "Base output" if en else "基础收益"
		"worker_count":
			return "Workers" if en else "工人数量"
		"worker_level":
			return "Worker level" if en else "工人等级"
		"factory_level":
			return "Factory level" if en else "工厂等级"
		"next_worker_cost":
			return "Next worker cost" if en else "下一名工人成本"
		"next_worker_upgrade":
			return "Next worker upgrade" if en else "下次工人升级"
		"next_factory_upgrade":
			return "Next factory upgrade" if en else "下次工厂升级"
		"offline_efficiency":
			return "Offline efficiency" if en else "离线效率"
		"offline_limit":
			return "Offline limit" if en else "离线上限"
		"click_income":
			return "Click income" if en else "点击收益"
		"hire_worker":
			return "Hire Worker" if en else "雇佣工人"
		"upgrade_worker":
			return "Upgrade Workers" if en else "升级工人"
		"upgrade_factory":
			return "Upgrade Factory" if en else "升级工厂"
		"offline_maxed":
			return "Offline Limit Maxed" if en else "离线收益已满级"
		"upgrade_offline_limit":
			return "Upgrade Offline Limit" if en else "升级离线上限"
		"offline_efficiency_maxed":
			return "Offline Efficiency Maxed" if en else "离线效率已满级"
		"upgrade_offline_efficiency":
			return "Upgrade Offline Efficiency" if en else "升级离线效率"
		"upgrade_click_income":
			return "Upgrade Click Income" if en else "升级点击收益"
		"delete_save_confirm":
			return "Really abandon your factory and workers?" if en else "真的要抛弃你的工厂和员工吗？"
		"save_deleted":
			return "Save Deleted" if en else "存档已删除"
		"save_deleted_message":
			return "They will miss you." if en else "他们会想你的。"
		"offline_message":
			return "While you were away, your factory ran for %s.\nOffline efficiency: %d%%\nCoins earned: %s" if en else "你离线期间，工厂持续运转了 %s。\n离线效率：%d%%\n获得金币：%s"
	return key


func get_factory_name(index: int) -> String:
	var data: Dictionary = FACTORY_DATA[index]
	if selected_language_index == 1:
		return data.get("name_en", data["name"])
	return data["name"]


func get_milestone_text(milestone: Dictionary) -> String:
	if selected_language_index == 1:
		return milestone.get("text_en", milestone["text"])
	return milestone["text"]


func get_achievement_title(achievement: Dictionary) -> String:
	if selected_language_index == 1:
		return achievement.get("title_en", achievement["title"])
	return achievement["title"]


func get_achievement_description(achievement: Dictionary) -> String:
	if selected_language_index == 1:
		return achievement.get("desc_en", achievement["desc"])
	return achievement["desc"]


func _update_ui() -> void:
	coins_label.text = "%s: %s" % [T("coins"), format_money(coins)]
	income_label.text = "%s: %s / %s" % [T("total_output"), format_money(get_total_income_per_second()), T("sec")]
	menu_summary_label.text = "%s: %s    %s: %s / %s" % [
		T("current_coins"),
		format_money(coins),
		T("total_output"),
		format_money(get_total_income_per_second()),
		T("sec")
	]
	_update_goal()
	_rebuild_factory_list()
	_update_change_region_button()
	_update_detail_panel()
	_update_milestones()


func _show_main_menu() -> void:
	menu_background.visible = true
	game_background.visible = false
	menu_root.visible = true
	game_root.visible = false
	_update_ui()


func _enter_factory() -> void:
	menu_background.visible = false
	game_background.visible = true
	menu_root.visible = false
	game_root.visible = true
	_update_factory_background()
	_update_ui()


func _exit_factory() -> void:
	_save_game()
	_show_main_menu()


func _open_settings() -> void:
	_update_settings_controls()
	settings_dialog.visible = true
	settings_dialog.move_to_front()


func _close_settings() -> void:
	settings_dialog.visible = false


func _close_offline_dialog() -> void:
	offline_dialog.visible = false


func _open_achievements() -> void:
	_update_achievements()
	achievements_dialog.visible = true
	achievements_dialog.move_to_front()


func _on_achievement_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT and mouse_event.pressed:
			_play_button_sound()
			_open_achievements()


func _close_achievements() -> void:
	achievements_dialog.visible = false


func _toggle_cheat_mode() -> void:
	if cheat_dialog.visible:
		_close_cheat_mode()
	else:
		_open_cheat_mode()


func _open_cheat_mode() -> void:
	_update_cheat_controls()
	cheat_dialog.visible = true
	cheat_dialog.move_to_front()
	_play_button_sound()


func _close_cheat_mode() -> void:
	cheat_dialog.visible = false


func _quit_game() -> void:
	_save_game()
	get_tree().quit()


func _on_window_size_selected(index: int) -> void:
	selected_window_size_index = clamp(index, 0, WINDOW_SIZE_OPTIONS.size() - 1)
	_apply_window_size()
	_save_game()


func _on_effects_volume_changed(value: float) -> void:
	effects_volume = clamp(value / 100.0, 0.0, 1.0)
	_apply_effects_volume()
	_save_game()


func _on_music_volume_changed(value: float) -> void:
	music_volume = clamp(value / 100.0, 0.0, 1.0)
	_apply_music_volume()
	_save_game()


func _on_offline_enabled_toggled(enabled: bool) -> void:
	offline_enabled = enabled
	_update_settings_controls()
	_save_game()


func _on_language_selected(index: int) -> void:
	selected_language_index = clamp(index, 0, LANGUAGE_OPTIONS.size() - 1)
	_apply_language()
	_save_game()


func _apply_settings() -> void:
	_apply_window_size()
	_apply_effects_volume()
	_apply_music_volume()
	_update_factory_background()
	_apply_language()
	_update_settings_controls()


func _apply_window_size() -> void:
	var option: Dictionary = WINDOW_SIZE_OPTIONS[selected_window_size_index]
	var target_size: Vector2i = option["size"]
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	DisplayServer.window_set_size(target_size)
	get_window().size = target_size
	get_window().content_scale_size = GAME_UI_RESOLUTION
	var screen_size := DisplayServer.screen_get_size(DisplayServer.window_get_current_screen())
	DisplayServer.window_set_position((screen_size - target_size) / 2)


func _apply_effects_volume() -> void:
	var sfx_bus := AudioServer.get_bus_index("SFX")
	if sfx_bus == -1:
		return
	AudioServer.set_bus_mute(sfx_bus, effects_volume <= 0.0)
	if effects_volume > 0.0:
		AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(effects_volume))
	_update_effects_volume_label()


func _apply_music_volume() -> void:
	if bgm_player != null:
		bgm_player.volume_db = linear_to_db(max(music_volume, 0.0001))
		bgm_player.stream_paused = music_volume <= 0.0
	_update_music_volume_label()


func _update_factory_background() -> void:
	if game_background_image == null or current_game_background_index == selected_factory:
		return
	game_background_image.texture = _load_factory_background_texture(selected_factory)
	current_game_background_index = selected_factory


func _load_factory_background_texture(index: int) -> Texture2D:
	if index >= 0 and index < FACTORY_BACKGROUND_PATHS.size():
		var texture := _load_texture_or_null(FACTORY_BACKGROUND_PATHS[index])
		if texture != null:
			return texture
	return _load_fallback_background_texture()


func _load_fallback_background_texture() -> Texture2D:
	var texture := _load_texture_or_null(FALLBACK_MENU_BACKGROUND_PATH)
	if texture != null:
		return texture
	var image := Image.create(8, 8, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.07, 0.13, 0.20, 1.0))
	return ImageTexture.create_from_image(image)


func _apply_language() -> void:
	var option: Dictionary = LANGUAGE_OPTIONS[selected_language_index]
	TranslationServer.set_locale(option["locale"])
	DisplayServer.window_set_title(T("game_title"))
	_refresh_language_texts()


func _refresh_language_texts() -> void:
	if menu_subtitle_label == null:
		return
	menu_subtitle_label.text = T("menu_subtitle")
	menu_enter_button.text = T("enter_factory")
	menu_settings_button.text = T("settings")
	menu_quit_button.text = T("quit_game")
	game_title_label.text = T("game_title")
	game_settings_button.text = T("settings")
	exit_factory_button.text = T("exit_factory")
	factories_title_label.text = T("factory_list")
	milestone_title_label.text = T("achievement_system")
	achievements_title_label.text = T("achievement_system")
	close_achievements_button.text = T("close")
	cheat_title_label.text = T("cheat_mode")
	cheat_add_coins_button.text = T("cheat_add_coins")
	cheat_unlock_all_button.text = T("cheat_unlock_all")
	cheat_boost_factory_button.text = T("cheat_boost_factory")
	cheat_complete_region_button.text = T("cheat_complete_region")
	cheat_close_button.text = T("close")
	change_region_button.text = T("change_region")
	settings_title_label.text = T("settings")
	close_settings_button.text = T("close")
	resolution_title_label.text = T("window_size")
	volume_title_label.text = T("effects_volume")
	music_volume_title_label.text = T("music_volume")
	language_title_label.text = T("language")
	delete_save_button.text = T("delete_save")
	offline_title_label.text = T("offline_income")
	offline_confirm_button.text = T("confirm")
	delete_save_dialog.title = T("delete_save")
	delete_save_dialog.dialog_text = T("delete_save_confirm")
	region_change_dialog.title = T("change_region_confirm_title")
	region_change_dialog.dialog_text = T("change_region_confirm")
	farewell_dialog.title = T("save_deleted")
	farewell_dialog.dialog_text = T("save_deleted_message")
	_update_settings_controls()
	_update_ui()


func _update_settings_controls() -> void:
	if window_size_option != null:
		window_size_option.select(selected_window_size_index)
	if effects_volume_slider != null:
		effects_volume_slider.set_value_no_signal(round(effects_volume * 100.0))
	if music_volume_slider != null:
		music_volume_slider.set_value_no_signal(round(music_volume * 100.0))
	if offline_enabled_check != null:
		offline_enabled_check.set_pressed_no_signal(offline_enabled)
		offline_enabled_check.text = "%s: %s" % [
			T("offline_income"),
			T("enabled") if offline_enabled else T("disabled")
		]
	if offline_status_label != null:
		offline_status_label.text = "%s: %d%%  |  %s %s" % [
			T("offline_efficiency"),
			offline_efficiency_percent,
			T("max_settlement"),
			_format_duration(max_offline_seconds)
		]
	if language_option != null:
		language_option.select(selected_language_index)
	_update_effects_volume_label()
	_update_music_volume_label()


func _update_effects_volume_label() -> void:
	if effects_volume_label != null:
		effects_volume_label.text = "%d%%" % int(round(effects_volume * 100.0))


func _update_music_volume_label() -> void:
	if music_volume_label != null:
		music_volume_label.text = "%d%%" % int(round(music_volume * 100.0))


func _update_goal() -> void:
	var next_index: int = get_next_locked_factory_index()
	if next_index == -1:
		next_goal_label.text = T("all_unlocked_goal")
		progress_bar.max_value = 1
		progress_bar.value = 1
		return

	var cost := get_factory_unlock_cost(next_index)
	next_goal_label.text = T("next_goal") % [
		get_factory_name(next_index),
		format_money(coins),
		format_money(cost)
	]
	progress_bar.max_value = cost
	progress_bar.value = clamp(coins, 0.0, cost)


func _create_factory_buttons() -> void:
	factory_buttons.clear()
	for child in factory_list.get_children():
		child.queue_free()

	for i in range(FACTORY_DATA.size()):
		var button := Button.new()
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.add_theme_font_size_override("font_size", 16)
		button.add_theme_color_override("font_color", Color(0.88, 0.94, 1.0))
		button.add_theme_color_override("font_hover_color", Color(1.0, 0.88, 0.42))
		button.add_theme_color_override("font_pressed_color", Color(1.0, 0.78, 0.24))
		button.add_theme_stylebox_override("normal", _make_factory_button_style(Color(0.09, 0.14, 0.21, 0.70), Color(0.34, 0.48, 0.63, 0.55)))
		button.add_theme_stylebox_override("hover", _make_factory_button_style(Color(0.13, 0.20, 0.29, 0.88), Color(0.74, 0.88, 1.0, 0.75)))
		button.add_theme_stylebox_override("pressed", _make_factory_button_style(Color(0.16, 0.24, 0.34, 0.95), Color(1.0, 0.74, 0.24, 0.90)))
		button.disabled = false
		button.pressed.connect(_on_factory_selected.bind(i))
		_wire_button_sound(button)
		factory_list.add_child(button)
		factory_buttons.append(button)


func _rebuild_factory_list() -> void:
	if factory_buttons.size() != FACTORY_DATA.size():
		_create_factory_buttons()

	for i in range(FACTORY_DATA.size()):
		var data: Dictionary = FACTORY_DATA[i]
		var state: Dictionary = factory_state[i]
		var button: Button = factory_buttons[i]
		var status := T("locked")
		if state["unlocked"]:
			status = "%s %s/%s   %s %d   Lv.%d" % [
				T("production"),
				format_money(get_factory_income_per_second(i)),
				T("sec"),
				T("workers"),
				state["workers"],
				state["factory_level"]
			]
			button.custom_minimum_size = Vector2(0, 58)
		else:
			button.custom_minimum_size = Vector2(0, 50)
		button.text = "%s\n%s" % [get_factory_name(i), status]
		button.button_pressed = i == selected_factory


func _update_change_region_button() -> void:
	if change_region_button == null:
		return
	var all_unlocked := get_unlocked_factory_count() >= FACTORY_DATA.size()
	change_region_button.text = T("change_region") if all_unlocked else T("change_region_locked")
	change_region_button.disabled = not all_unlocked


func _update_cheat_controls() -> void:
	if cheat_complete_region_button != null:
		cheat_complete_region_button.disabled = get_unlocked_factory_count() >= FACTORY_DATA.size()


func _update_detail_panel() -> void:
	var data: Dictionary = FACTORY_DATA[selected_factory]
	var state: Dictionary = factory_state[selected_factory]
	detail_title.text = get_factory_name(selected_factory)

	if not state["unlocked"]:
		detail_stats.text = T("factory_locked_detail") % format_money(get_factory_unlock_cost(selected_factory))
		hire_button.visible = false
		worker_upgrade_button.visible = false
		factory_upgrade_button.visible = false
		offline_upgrade_button.visible = false
		offline_efficiency_upgrade_button.visible = false
		click_upgrade_button.visible = false
		unlock_button.visible = true
		var unlock_cost := get_factory_unlock_cost(selected_factory)
		unlock_button.text = "%s - %s" % [T("unlock"), format_money(unlock_cost)]
		unlock_button.disabled = coins < unlock_cost
		return

	hire_button.visible = true
	worker_upgrade_button.visible = true
	factory_upgrade_button.visible = true
	offline_upgrade_button.visible = true
	offline_efficiency_upgrade_button.visible = true
	click_upgrade_button.visible = true
	unlock_button.visible = false

	var hire_cost: float = get_hire_cost(selected_factory)
	var worker_upgrade_cost: float = get_worker_upgrade_cost(selected_factory)
	var factory_upgrade_cost: float = get_factory_upgrade_cost(selected_factory)
	var click_upgrade_cost: float = get_click_upgrade_cost()

	var detail_lines := PackedStringArray([
		"%s: %s / %s" % [T("factory_income"), format_money(get_factory_income_per_second(selected_factory)), T("sec")],
		"%s: %s / %s" % [T("base_income"), format_money(get_factory_base_income(selected_factory)), T("sec")],
		"%s: %d  |  %s: %d  |  %s: %d" % [
			T("worker_count"),
			state["workers"],
			T("worker_level"),
			state["worker_level"],
			T("factory_level"),
			state["factory_level"]
		],
		"%s: %d%%  |  %s: %s" % [
			T("offline_efficiency"),
			offline_efficiency_percent,
			T("offline_limit"),
			_format_duration(max_offline_seconds)
		],
		"%s: %s" % [T("click_income"), format_money(click_income)]
	])
	detail_stats.text = "\n".join(detail_lines)

	hire_button.text = "%s - %s" % [T("hire_worker"), format_money(hire_cost)]
	hire_button.disabled = coins < hire_cost
	worker_upgrade_button.text = "%s - %s" % [T("upgrade_worker"), format_money(worker_upgrade_cost)]
	worker_upgrade_button.disabled = coins < worker_upgrade_cost
	factory_upgrade_button.text = "%s - %s" % [T("upgrade_factory"), format_money(factory_upgrade_cost)]
	factory_upgrade_button.disabled = coins < factory_upgrade_cost
	if max_offline_seconds >= float(OFFLINE_MAX_UPGRADE_SECONDS):
		offline_upgrade_button.text = T("offline_maxed")
		offline_upgrade_button.disabled = true
	else:
		var offline_cost := get_offline_upgrade_cost()
		offline_upgrade_button.text = "%s - %s" % [T("upgrade_offline_limit"), format_money(offline_cost)]
		offline_upgrade_button.disabled = coins < offline_cost
	if offline_efficiency_percent >= OFFLINE_MAX_EFFICIENCY_PERCENT:
		offline_efficiency_upgrade_button.text = T("offline_efficiency_maxed")
		offline_efficiency_upgrade_button.disabled = true
	else:
		var offline_efficiency_cost := get_offline_efficiency_upgrade_cost()
		offline_efficiency_upgrade_button.text = "%s - %s" % [T("upgrade_offline_efficiency"), format_money(offline_efficiency_cost)]
		offline_efficiency_upgrade_button.disabled = coins < offline_efficiency_cost
	click_upgrade_button.text = "%s - %s" % [T("upgrade_click_income"), format_money(click_upgrade_cost)]
	click_upgrade_button.disabled = coins < click_upgrade_cost


func _update_milestones() -> void:
	var completed := get_completed_achievement_count()
	var next_achievement := get_next_achievement()
	var next_title := T("all_achievements_done")
	var next_progress := ""
	if not next_achievement.is_empty():
		next_title = get_achievement_title(next_achievement)
		next_progress = get_achievement_progress_text(next_achievement)
	milestone_summary_button.text = T("achievement_summary") % [
		completed,
		ACHIEVEMENTS.size(),
		next_title,
		T("open_achievements") if next_progress.is_empty() else next_progress
	]
	if achievements_dialog != null and achievements_dialog.visible:
		_update_achievements()


func _create_achievement_labels() -> void:
	achievement_labels.clear()
	for child in achievements_list.get_children():
		child.queue_free()

	for i in range(ACHIEVEMENTS.size()):
		var label := RichTextLabel.new()
		label.bbcode_enabled = true
		label.fit_content = true
		label.scroll_active = false
		label.selection_enabled = false
		label.custom_minimum_size = Vector2(0, 72)
		label.add_theme_font_size_override("normal_font_size", 15)
		label.add_theme_font_size_override("bold_font_size", 17)
		achievements_list.add_child(label)
		achievement_labels.append(label)


func _update_achievements() -> void:
	if achievement_labels.size() != ACHIEVEMENTS.size():
		_create_achievement_labels()

	for i in range(ACHIEVEMENTS.size()):
		var achievement: Dictionary = ACHIEVEMENTS[i]
		var label := achievement_labels[i]
		var done := _is_achievement_done(achievement)
		var status := T("achievement_complete") if done else T("achievement_locked")
		var status_color := "#8fe28f" if done else "#cbd8e8"
		var title_color := "#ffffff" if done else "#dbe7f8"
		label.text = "[color=%s][b]%s[/b][/color]  [color=%s]%s[/color]\n[color=#cbd8e8]%s[/color]\n[color=#ffd65a]%s[/color]" % [
			title_color,
			get_achievement_title(achievement),
			status_color,
			status,
			get_achievement_description(achievement),
			get_achievement_progress_text(achievement)
		]


func _is_achievement_done(achievement: Dictionary) -> bool:
	return get_achievement_progress_value(achievement) >= float(achievement["target"])


func get_completed_achievement_count() -> int:
	var completed := 0
	for achievement in ACHIEVEMENTS:
		if _is_achievement_done(achievement):
			completed += 1
	return completed


func get_next_achievement() -> Dictionary:
	for achievement in ACHIEVEMENTS:
		if not _is_achievement_done(achievement):
			return achievement
	return {}


func get_achievement_progress_value(achievement: Dictionary) -> float:
	match achievement["type"]:
		"workers":
			return float(get_total_workers())
		"unlocked":
			return float(get_unlocked_factory_count())
		"income":
			return get_total_income_per_second()
		"coins":
			return max(total_earned, coins)
		"factory_level":
			return float(get_max_factory_level())
		"worker_level":
			return float(get_max_worker_level())
		"click_income":
			return click_income
		"offline_efficiency":
			return float(offline_efficiency_percent)
		"offline_limit":
			return max_offline_seconds
		"region":
			return float(region_level)
	return 0.0


func get_achievement_progress_text(achievement: Dictionary) -> String:
	var value: float = min(get_achievement_progress_value(achievement), float(achievement["target"]))
	var target := float(achievement["target"])
	match achievement["type"]:
		"coins", "income", "click_income":
			return "%s / %s" % [format_money(value), format_money(target)]
		"offline_efficiency":
			return "%d%% / %d%%" % [int(value), int(target)]
		"offline_limit":
			return "%s / %s" % [_format_duration(value), _format_duration(target)]
	return "%d / %d" % [int(value), int(target)]


func _on_factory_selected(index: int) -> void:
	selected_factory = index
	_update_factory_background()
	_update_ui()


func _on_hire_pressed() -> void:
	var cost: float = get_hire_cost(selected_factory)
	if coins < cost:
		return
	coins -= cost
	factory_state[selected_factory]["workers"] += 1
	_save_game()
	_update_ui()


func _on_worker_upgrade_pressed() -> void:
	var cost: float = get_worker_upgrade_cost(selected_factory)
	if coins < cost:
		return
	coins -= cost
	factory_state[selected_factory]["worker_level"] += 1
	_save_game()
	_update_ui()


func _on_factory_upgrade_pressed() -> void:
	var cost: float = get_factory_upgrade_cost(selected_factory)
	if coins < cost:
		return
	coins -= cost
	factory_state[selected_factory]["factory_level"] += 1
	_save_game()
	_update_ui()


func _on_offline_upgrade_pressed() -> void:
	if max_offline_seconds >= float(OFFLINE_MAX_UPGRADE_SECONDS):
		return
	var cost := get_offline_upgrade_cost()
	if coins < cost:
		return
	coins -= cost
	max_offline_seconds = min(max_offline_seconds + float(OFFLINE_UPGRADE_SECONDS), float(OFFLINE_MAX_UPGRADE_SECONDS))
	_save_game()
	_update_settings_controls()
	_update_ui()


func _on_offline_efficiency_upgrade_pressed() -> void:
	if offline_efficiency_percent >= OFFLINE_MAX_EFFICIENCY_PERCENT:
		return
	var cost := get_offline_efficiency_upgrade_cost()
	if coins < cost:
		return
	coins -= cost
	offline_efficiency_percent = min(
		offline_efficiency_percent + OFFLINE_EFFICIENCY_STEP_PERCENT,
		OFFLINE_MAX_EFFICIENCY_PERCENT
	)
	_save_game()
	_update_settings_controls()
	_update_ui()


func _on_click_upgrade_pressed() -> void:
	var cost := get_click_upgrade_cost()
	if coins < cost:
		return
	coins -= cost
	click_income *= 2.0
	_save_game()
	_update_ui()


func _collect_click_income(position: Vector2) -> void:
	if _is_gameplay_click_blocked(position):
		return
	coins += click_income
	total_earned += click_income
	_play_button_sound()
	_update_ui()


func _is_gameplay_click_blocked(position: Vector2) -> bool:
	for blocker in gameplay_click_blockers:
		if is_instance_valid(blocker) and blocker.visible and blocker.get_global_rect().has_point(position):
			return true
	for button in factory_buttons:
		if is_instance_valid(button) and button.visible and button.get_global_rect().has_point(position):
			return true
	return false


func _on_unlock_pressed() -> void:
	var cost := get_factory_unlock_cost(selected_factory)
	if coins < cost:
		return
	coins -= cost
	factory_state[selected_factory]["unlocked"] = true
	_save_game()
	_update_ui()


func _cheat_add_coins() -> void:
	coins += 1000000000.0
	total_earned += 1000000000.0
	_save_game()
	_update_ui()


func _cheat_unlock_all_factories() -> void:
	for state in factory_state:
		state["unlocked"] = true
	_save_game()
	_update_ui()
	_update_cheat_controls()


func _cheat_boost_current_factory() -> void:
	var state: Dictionary = factory_state[selected_factory]
	state["unlocked"] = true
	state["workers"] = max(int(state["workers"]), 50)
	state["worker_level"] = max(int(state["worker_level"]), 8)
	state["factory_level"] = max(int(state["factory_level"]), 8)
	_save_game()
	_update_ui()


func _cheat_complete_region() -> void:
	for state in factory_state:
		state["unlocked"] = true
		state["workers"] = max(int(state["workers"]), 10)
		state["worker_level"] = max(int(state["worker_level"]), 3)
		state["factory_level"] = max(int(state["factory_level"]), 3)
	_save_game()
	_update_ui()
	_update_cheat_controls()


func _request_change_region() -> void:
	if get_unlocked_factory_count() < FACTORY_DATA.size():
		return
	region_change_dialog.popup_centered(REGION_DIALOG_SIZE)


func _change_region_confirmed() -> void:
	region_level += 1
	_reset_run_progress()
	_update_factory_background()
	_save_game()
	_update_settings_controls()
	_update_ui()


func _reset_run_progress() -> void:
	coins = 0.0
	total_earned = 0.0
	selected_factory = 0
	offline_enabled = true
	max_offline_seconds = float(MAX_OFFLINE_SECONDS)
	offline_efficiency_percent = OFFLINE_INITIAL_EFFICIENCY_PERCENT
	click_income = get_region_starting_click_income()
	has_loaded_save = true
	_initialize_state()


func _request_delete_save() -> void:
	delete_save_dialog.popup_centered(SAVE_DIALOG_SIZE)


func _delete_save_confirmed() -> void:
	coins = 0.0
	total_earned = 0.0
	selected_factory = 0
	offline_enabled = true
	max_offline_seconds = float(MAX_OFFLINE_SECONDS)
	offline_efficiency_percent = OFFLINE_INITIAL_EFFICIENCY_PERCENT
	click_income = CLICK_INCOME_BASE
	music_volume = 0.55
	region_level = 0
	selected_language_index = 0
	has_loaded_save = false
	_initialize_state()
	if FileAccess.file_exists(SAVE_PATH):
		var user_dir := DirAccess.open("user://")
		if user_dir != null:
			user_dir.remove(SAVE_FILE_NAME)
	_update_factory_background()
	_update_ui()
	farewell_dialog.popup_centered(SAVE_DIALOG_SIZE)


func get_factory_income_per_second(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	var state: Dictionary = factory_state[index]
	if not state["unlocked"]:
		return 0.0
	var income_multiplier := get_region_income_multiplier()
	var base_income: float = data["base_income"] * float(state["factory_level"]) * income_multiplier
	var worker_income: float = float(state["workers"]) * data["worker_income"] * pow(1.55, float(state["worker_level"] - 1)) * income_multiplier
	var level_bonus: float = pow(1.22, float(state["factory_level"] - 1))
	return (base_income + worker_income) * level_bonus


func get_factory_base_income(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	return data["base_income"] * get_region_income_multiplier()


func get_total_income_per_second() -> float:
	var total := 0.0
	for i in range(FACTORY_DATA.size()):
		total += get_factory_income_per_second(i)
	return total


func get_hire_cost(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	var state: Dictionary = factory_state[index]
	return floor(data["worker_base_cost"] * get_region_cost_multiplier() * pow(1.15, float(state["workers"])))


func get_worker_upgrade_cost(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	var state: Dictionary = factory_state[index]
	return floor(data["worker_upgrade_base_cost"] * get_region_cost_multiplier() * pow(1.35, float(state["worker_level"] - 1)))


func get_factory_upgrade_cost(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	var state: Dictionary = factory_state[index]
	return floor(data["factory_upgrade_base_cost"] * get_region_cost_multiplier() * pow(1.55, float(state["factory_level"] - 1)))


func get_offline_upgrade_cost() -> float:
	var level := int(round((max_offline_seconds - float(MAX_OFFLINE_SECONDS)) / float(OFFLINE_UPGRADE_SECONDS)))
	return floor(OFFLINE_UPGRADE_BASE_COST * get_region_cost_multiplier() * pow(3.0, float(max(level, 0))))


func get_offline_efficiency_upgrade_cost() -> float:
	var level := int(round(float(offline_efficiency_percent - OFFLINE_INITIAL_EFFICIENCY_PERCENT) / float(OFFLINE_EFFICIENCY_STEP_PERCENT)))
	return floor(OFFLINE_EFFICIENCY_UPGRADE_BASE_COST * get_region_cost_multiplier() * pow(OFFLINE_EFFICIENCY_UPGRADE_GROWTH, float(max(level, 0))))


func get_offline_efficiency_rate() -> float:
	return float(offline_efficiency_percent) / 100.0


func get_click_upgrade_cost() -> float:
	var level := int(round(log(max(click_income, CLICK_INCOME_BASE)) / log(2.0)))
	return floor(CLICK_UPGRADE_BASE_COST * get_region_cost_multiplier() * pow(CLICK_UPGRADE_GROWTH, float(max(level, 0))))


func get_factory_unlock_cost(index: int) -> float:
	var data: Dictionary = FACTORY_DATA[index]
	return floor(data["unlock_cost"] * get_region_cost_multiplier())


func get_region_cost_multiplier() -> float:
	return pow(REGION_COST_SCALING, float(region_level))


func get_region_income_multiplier() -> float:
	return pow(REGION_INCOME_SCALING, float(region_level))


func get_region_starting_click_income() -> float:
	return CLICK_INCOME_BASE * pow(REGION_STARTING_CLICK_SCALING, float(region_level))


func get_next_locked_factory_index() -> int:
	for i in range(FACTORY_DATA.size()):
		if not factory_state[i]["unlocked"]:
			return i
	return -1


func get_total_workers() -> int:
	var total := 0
	for state in factory_state:
		total += int(state["workers"])
	return total


func get_max_factory_level() -> int:
	var best := 0
	for state in factory_state:
		best = max(best, int(state["factory_level"]))
	return best


func get_max_worker_level() -> int:
	var best := 0
	for state in factory_state:
		best = max(best, int(state["worker_level"]))
	return best


func get_unlocked_factory_count() -> int:
	var total := 0
	for state in factory_state:
		if state["unlocked"]:
			total += 1
	return total


func format_money(value: float) -> String:
	var sign := ""
	if value < 0.0:
		sign = "-"
	value = abs(value)
	if value < 10000.0:
		return "%s%d" % [sign, int(floor(value))]
	if selected_language_index == 1:
		var english_units := ["K", "M", "B", "T", "Qa", "Qi"]
		var english_value := value
		var english_index := -1
		while english_value >= 1000.0 and english_index < english_units.size() - 1:
			english_value /= 1000.0
			english_index += 1
		return "%s%.2f%s" % [sign, english_value, english_units[english_index]]
	var units := ["万", "亿", "兆", "京", "垓", "秭"]
	var index := -1
	while value >= 10000.0 and index < units.size() - 1:
		value /= 10000.0
		index += 1
	return "%s%.2f%s" % [sign, value, units[index]]


func _save_game() -> void:
	var save_data := {
		"coins": coins,
		"total_earned": total_earned,
		"selected_factory": selected_factory,
		"factory_state": factory_state,
		"selected_window_size_index": selected_window_size_index,
		"effects_volume": effects_volume,
		"music_volume": music_volume,
		"region_level": region_level,
		"offline_enabled": offline_enabled,
		"max_offline_seconds": max_offline_seconds,
		"offline_efficiency_percent": offline_efficiency_percent,
		"click_income": click_income,
		"selected_language_index": selected_language_index,
		"last_seen": Time.get_unix_time_from_system()
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(save_data))


func _load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var raw := FileAccess.get_file_as_string(SAVE_PATH)
	var save_data = JSON.parse_string(raw)
	if typeof(save_data) != TYPE_DICTIONARY:
		return

	coins = float(save_data.get("coins", 0.0))
	total_earned = float(save_data.get("total_earned", coins))
	selected_factory = clamp(int(save_data.get("selected_factory", 0)), 0, FACTORY_DATA.size() - 1)
	selected_window_size_index = clamp(int(save_data.get("selected_window_size_index", save_data.get("selected_resolution_index", selected_window_size_index))), 0, WINDOW_SIZE_OPTIONS.size() - 1)
	effects_volume = clamp(float(save_data.get("effects_volume", effects_volume)), 0.0, 1.0)
	music_volume = clamp(float(save_data.get("music_volume", music_volume)), 0.0, 1.0)
	region_level = max(0, int(save_data.get("region_level", region_level)))
	offline_enabled = bool(save_data.get("offline_enabled", offline_enabled))
	max_offline_seconds = clamp(float(save_data.get("max_offline_seconds", max_offline_seconds)), float(MAX_OFFLINE_SECONDS), float(OFFLINE_MAX_UPGRADE_SECONDS))
	offline_efficiency_percent = clamp(
		int(save_data.get("offline_efficiency_percent", OFFLINE_INITIAL_EFFICIENCY_PERCENT)),
		OFFLINE_INITIAL_EFFICIENCY_PERCENT,
		OFFLINE_MAX_EFFICIENCY_PERCENT
	)
	click_income = max(CLICK_INCOME_BASE, float(save_data.get("click_income", CLICK_INCOME_BASE)))
	selected_language_index = clamp(int(save_data.get("selected_language_index", selected_language_index)), 0, LANGUAGE_OPTIONS.size() - 1)

	var saved_factories: Array = save_data.get("factory_state", [])
	for i in range(min(saved_factories.size(), factory_state.size())):
		var saved_state: Dictionary = saved_factories[i]
		factory_state[i]["unlocked"] = bool(saved_state.get("unlocked", i == 0))
		factory_state[i]["workers"] = int(saved_state.get("workers", 0))
		factory_state[i]["worker_level"] = max(1, int(saved_state.get("worker_level", 1)))
		factory_state[i]["factory_level"] = max(1, int(saved_state.get("factory_level", 1)))

	has_loaded_save = true


func _apply_offline_income() -> void:
	if not offline_enabled:
		return
	if not has_loaded_save or not FileAccess.file_exists(SAVE_PATH):
		return
	var raw := FileAccess.get_file_as_string(SAVE_PATH)
	var save_data = JSON.parse_string(raw)
	if typeof(save_data) != TYPE_DICTIONARY:
		return
	var last_seen: float = float(save_data.get("last_seen", Time.get_unix_time_from_system()))
	var now: float = Time.get_unix_time_from_system()
	var offline_seconds: float = clamp(now - last_seen, 0.0, max_offline_seconds)
	if offline_seconds < 30.0:
		return
	var earned: float = get_total_income_per_second() * offline_seconds * get_offline_efficiency_rate()
	if earned <= 0.0:
		return
	coins += earned
	total_earned += earned
	offline_message_label.text = T("offline_message") % [
		_format_duration(offline_seconds),
		offline_efficiency_percent,
		format_money(earned)
	]
	offline_dialog.visible = true
	offline_dialog.move_to_front()
	_save_game()


func _format_duration(seconds: float) -> String:
	var total := int(seconds)
	var hours: int = int(total / 3600)
	var minutes: int = int((total % 3600) / 60)
	if hours > 0:
		if selected_language_index == 1:
			return "%dh %dm" % [hours, minutes]
		return "%d小时 %d分钟" % [hours, minutes]
	if selected_language_index == 1:
		return "%dm" % minutes
	return "%d分钟" % minutes
