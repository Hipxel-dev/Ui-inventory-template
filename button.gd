extends Node2D

var original_pos = Vector2.ZERO

var names = [
	"Apple",
	"Banana",
	"Carrot",
	"Bread",
	"Cheese",
	"Chicken",
	"Rice",
	"Potato",
	"Tomato",
	"Lettuce",
	"Beef",
	"Pasta",
	"Fish",
	"Milk",
	"Eggs",
	"Yogurt",
	"Butter",
	"Peanut Butter",
	"Jam",
	"Spinach",
	"Onion",
	"Garlic",
	"Orange",
	"Strawberry",
	"Grapes",
	"Mango",
	"Watermelon",
	"Cucumber",
	"Celery",
	"Broccoli",
	"Cauliflower",
	"Pork",
	"Turkey",
	"Sausage",
	"Tofu",
	"Beans",
	"Lentils",
	"Chickpeas",
	"Oats",
	"Cereal",
	"Pancakes",
	"Waffles",
	"Mushrooms",
	"Pepper",
	"Chili",
	"Eggplant",
	"Zucchini",
	"Corn",
	"Avocado",
	"Blueberries",
	"Raspberries",
	"Blackberries",
	"Peach",
	"Plum",
	"Pineapple",
	"Kiwi",
	"Apricot",
	"Fig",
	"Pomegranate",
	"Almonds",
	"Walnuts",
	"Hazelnuts",
	"Cashews",
	"Macadamia Nuts",
	"Pistachios",
	"Sunflower Seeds",
	"Pumpkin Seeds",
	"Chia Seeds",
	"Flax Seeds",
	"Quinoa",
	"Barley",
	"Couscous",
	"Spaghetti",
	"Lasagna",
	"Ravioli",
	"Tortilla",
	"Bagel",
	"Croissant",
	"Muffin",
	"Scone",
	"Donut",
	"Cupcake",
	"Brownie",
	"Cookie",
	"Pie",
	"Cake",
	"Ice Cream",
	"Sorbet",
	"Gelato",
	"Popsicle",
	"Chocolate",
	"Candy",
	"Gum",
	"Lollipop",
	"Pretzel",
	"Chips",
	"Popcorn",
	"Crackers",
	"Granola",
	"Trail Mix",
	"Juice",
	"Soda",
	"Tea",
	"Coffee",
	"Wine",
	"Beer"
];

var vel = Vector2.ZERO

var current_name = ""

var elements = {
	"Amount": floor(rand_range(1,100)),
	
}

var types = [
	Color.pink,
	Color.cyan,
	Color.yellow,
	Color.magenta,
	Color.red,
	Color.green,
	Color.blue,
	Color.chocolate,
	Color.burlywood
]

var current_type = types[0]



func _ready() -> void:
	$rect/name.text = str(names[floor(rand_range(0, names.size() - 1))])
	current_name = $rect/name.text
	$rect/amount.text = str("x",elements["Amount"])
	current_type = floor(rand_range(0,types.size()))
	modulate = types[current_type]

onready var rect = $rect
var process = false

var count = 0

var hold = false

func _physics_process(delta: float) -> void:
	position = position.linear_interpolate(original_pos,delta * 10)
	
	count -= delta
	if count < 0:

	
		if global_position.y > 1000 or global_position.y < -32:
			hide()
		else:
			show()
			
			$rect/bg.modulate = $rect/bg.modulate.linear_interpolate(Color8(150,150,150,255),delta * 10)
			
			rect.margin_right += (114 - rect.margin_right) * 0.3
			rect.margin_left += (-1 - rect.margin_left) * 0.3
			rect.margin_top += (-2 - rect.margin_top) * 0.3
			rect.margin_bottom += (42 - rect.margin_bottom) * 0.3
			
			if get_local_mouse_position().x > rect.margin_left and get_local_mouse_position().x < rect.margin_right:
				if get_local_mouse_position().y > rect.margin_top and get_local_mouse_position().y < rect.margin_bottom:
					get_parent().get_parent().selected = self
				

