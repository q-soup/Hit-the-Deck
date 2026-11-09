extends PanelContainer

func set_card(text: String, face_down := false) -> void:
	$Label.text = "?" if face_down else text
