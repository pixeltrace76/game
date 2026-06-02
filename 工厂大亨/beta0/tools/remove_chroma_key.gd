extends SceneTree

const INPUT_PATH := "res://art/logo/main_menu_logo_v3_chroma.png"
const OUTPUT_PATH := "res://art/logo/main_menu_logo_v3.png"
const KEY_COLOR := Color(0.0, 1.0, 0.0, 1.0)
const TRANSPARENT_DISTANCE := 0.055
const OPAQUE_DISTANCE := 0.38
const CROP_PADDING := 18
const STRAY_BORDER := 24


func _initialize() -> void:
	var image := Image.new()
	var load_error := image.load(INPUT_PATH)
	if load_error != OK:
		push_error("Failed to load chroma image: %s" % INPUT_PATH)
		quit(1)
		return

	image.convert(Image.FORMAT_RGBA8)
	_remove_key_color(image)
	_clear_border_artifacts(image)
	var cropped := _crop_to_visible_pixels(image)
	var save_error := cropped.save_png(OUTPUT_PATH)
	if save_error != OK:
		push_error("Failed to save transparent image: %s" % OUTPUT_PATH)
		quit(1)
		return

	print("Saved transparent logo: %s" % OUTPUT_PATH)
	quit()


func _remove_key_color(image: Image) -> void:
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var color := image.get_pixel(x, y)
			var distance := _rgb_distance(color, KEY_COLOR)
			var alpha := smoothstep(TRANSPARENT_DISTANCE, OPAQUE_DISTANCE, distance)
			if alpha <= 0.01:
				image.set_pixel(x, y, Color(0, 0, 0, 0))
				continue

			var foreground := _unpremultiply_key(color, alpha)
			foreground.a = alpha
			image.set_pixel(x, y, foreground)


func _clear_border_artifacts(image: Image) -> void:
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if x < STRAY_BORDER or y < STRAY_BORDER or x >= image.get_width() - STRAY_BORDER or y >= image.get_height() - STRAY_BORDER:
				image.set_pixel(x, y, Color(0, 0, 0, 0))


func _rgb_distance(a: Color, b: Color) -> float:
	var dr := a.r - b.r
	var dg := a.g - b.g
	var db := a.b - b.b
	return sqrt(dr * dr + dg * dg + db * db)


func _unpremultiply_key(color: Color, alpha: float) -> Color:
	var safe_alpha: float = max(alpha, 0.001)
	var inv_alpha: float = 1.0 - safe_alpha
	var red: float = clamp((color.r - KEY_COLOR.r * inv_alpha) / safe_alpha, 0.0, 1.0)
	var green: float = clamp((color.g - KEY_COLOR.g * inv_alpha) / safe_alpha, 0.0, 1.0)
	var blue: float = clamp((color.b - KEY_COLOR.b * inv_alpha) / safe_alpha, 0.0, 1.0)
	if green > max(red, blue):
		green = lerp(max(red, blue), green, safe_alpha)
	return Color(red, green, blue, safe_alpha)


func _crop_to_visible_pixels(image: Image) -> Image:
	var min_x := image.get_width()
	var min_y := image.get_height()
	var max_x := -1
	var max_y := -1

	for y in range(image.get_height()):
		for x in range(image.get_width()):
			if image.get_pixel(x, y).a > 0.10:
				min_x = min(min_x, x)
				min_y = min(min_y, y)
				max_x = max(max_x, x)
				max_y = max(max_y, y)

	if max_x < min_x or max_y < min_y:
		return image

	min_x = max(min_x - CROP_PADDING, 0)
	min_y = max(min_y - CROP_PADDING, 0)
	max_x = min(max_x + CROP_PADDING, image.get_width() - 1)
	max_y = min(max_y + CROP_PADDING, image.get_height() - 1)

	return image.get_region(Rect2i(min_x, min_y, max_x - min_x + 1, max_y - min_y + 1))
