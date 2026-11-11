extends Area2D

@onready var body : CharacterBody2D = get_parent()

func onElasticCollision(area: Area2D):
	if area.is_in_group("elastic"):
		var other : CharacterBody2D = area.get_parent()
		
		var posDir : Vector2  = (body.position - other.position).normalized()
		var velDir : Vector2  = body.velocity - other.velocity
		var velNormal : float = velDir.dot(posDir)
		
		body.position += posDir * 10
		
		if velNormal > 0: return
		
		var speedNormal  = velNormal * posDir
		var speedTangent = velDir - speedNormal
		
		body.knockback -= speedNormal + speedTangent
