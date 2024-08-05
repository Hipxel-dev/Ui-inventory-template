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
	Color.cyan,
	Color.magenta,
	Color.pink,
	Color.blueviolet
]

var current_type = types[0]



func _ready() -> void:
	$rect/name.text = str(names[floor(rand_range(0, names.size() - 1))])
	current_name = $rect/name.text
	$rect/amount.text = str("x",elements["Amount"])
	current_type = floor(rand_range(0,types.size()))
	modulate = types[current_type]

func _physics_process(delta: float) -> void:
	position += vel * delta * 2
	vel /= 2
