
# final_file = ""
# starting_value = 5200
# ending_value = 5300

# while starting_value <= ending_value:
#     final_file += f"|-\n| {str(starting_value)} || \n"
#     starting_value += 1
# final_file += "|-"

# print(final_file)

other_attribs = {
    # "ball trail particle" : True,
	# "ball hit particle" : True,
	# "ball explode particle" : True,
	# "ball explode sound" : True,
	# "ball damage type" : False,
	# "ball bleed duration" : False,
	# "ball ignite duration" : False,
	# "ball stun override" : False,
	# "ball stun duration" : False,
	# "ball stun slowdown" : False,
	# "ball stun flags" : False,
	# "ball add cond" : True,
	# "ball remove cond" : True,
	# "ball self cond" : True,
	# "ball ammo drain" : False,
	# "ball ammo drain mode" : False,
	# "ball ammo drain basis" : False,
	# "ball ammo drain flat" : False,
	# "ball ammo drain clip" : False,
	# "ball ammo steal" : False,
	# "ball ammo steal ratio" : False,
	# "ball ammo steal type" : False,
	# "ball drain cloak" : False,
	# "ball drain charge" : False,
	# "ball explodes" : False,
	# "ball explode damage" : False,
	# "ball explode falloff" : False,
	# "ball explode on world" : False,
	# "ball explode on fuse" : False,
	# "ball explode self damage" : False,
	# "ball explode damage type" : False,
	# "ball explode damage buildings" : False,
	# "ball explode hits teammates" : False,
	# "ball explode force" : False,
	# "ball explode ignore los" : False,
	# "ball explode hits direct target" : False,
	# "ball explode applies effects" : False,
	# "ball explode shake" : False,
}

attribs = {
	# description = False, effect = 0, Isstring = False, hidden_override = False
	"ball model" 					: [False, 0, True, False],
	"ball model scale" 				: [False, 0, False, False],
	"ball skin"  					: [False, 0, False, False],
	"ball color" 					: [False, 0, True, False],
	"ball launch sound" 			: [False, 0, True, False],
	"ball hit sound" 				: [False, 0, True, False],
	"ball speed mult" 				: ["Baseballs move at %s1% speed", 0, False, False],
	"ball gravity mult" 			: ["Baseballs have %s1% gravity", 0, False, False],
	"ball launch angle" 			: [False, 0, True, False],
	"ball lifetime" 				: ["Baseballs Live for only %s1 seconds", -1, False, False],
	"ball hitbox size mult" 		: [False, 0, False, False],
	"ball max bounces" 				: ["Baseballs bounces are limited to %s1", -1, False, False],
	"ball damage" 					: ["Baseballs deal %s1 damage", 0, False, True],
	"ball heal on hit" 				: ["Baseballs Heal for %s1 health on hit", 1, False, False],
	"ball no stun" 					: ["Baseballs Dont stun on Hit", -1, False, False],
	"ball hit teammate attribute" 	: [False, 0, True, False],
	"ball hit enemy attribute" 		: [False, 0, True, False],
	"ball kill icon" 				: [False, 0, True, False],
}

# attribs = [
# 	"ball model",
# 	"ball model scale",
# 	"ball skin",
# 	"ball color",
# 	"ball trail particle",
# 	"ball hit particle",
# 	"ball explode particle",
# 	"ball launch sound",
# 	"ball hit sound",
# 	"ball explode sound",
# 	"ball speed",
# 	"ball gravity",
# 	"ball lifetime",
# 	"ball size",
# 	"ball max bounces",
# 	"ball damage",
# 	"ball damage type",
# 	"ball heal on hit",
# 	"ball bleed duration",
# 	"ball ignite duration",
# 	"ball stun override",
# 	"ball stun duration",
# 	"ball stun slowdown",
# 	"ball stun flags",
# 	"ball no stun",
# 	"ball add cond",
# 	"ball remove cond",
# 	"ball self cond",
# 	"ball ammo drain",
# 	"ball ammo drain mode",
# 	"ball ammo drain basis",
# 	"ball ammo drain flat",
# 	"ball ammo drain clip",
# 	"ball ammo steal",
# 	"ball ammo steal ratio",
# 	"ball ammo steal type",
# 	"ball drain cloak",
# 	"ball drain charge",
# 	"ball explodes",
# 	"ball explode damage",
# 	"ball explode falloff",
# 	"ball explode on world",
# 	"ball explode on fuse",
# 	"ball explode self damage",
# 	"ball explode damage type",
# 	"ball explode damage buildings",
# 	"ball explode hits teammates",
# 	"ball explode force",
# 	"ball explode ignore los",
# 	"ball explode hits direct target",
# 	"ball explode applies effects",
# 	"ball explode shake",
# ]

TABS = [
	"",
	"\t",
	"\t\t",
	"\t\t\t",
	"\t\t\t\t",
	"\t\t\t\t\t",
]

string = ""
def ConstructAttrib(index, attrib, description = False, effect = 0, Isstring = False, hidden = False):
	global string
	string = ""
	WriteLine( 	f"{TABS[2]}\"{index}\"")
	WriteLine(	f"{TABS[2]}{{")
	WriteLine(	f"{TABS[3]}\"name\"{TABS[5]}\"{attrib}\"")
	WriteLine(	f"{TABS[3]}\"attribute_class\"{TABS[2]}\"dummy\"")
	if(description != False):
		WriteLine(	f"{TABS[3]}\"description_string\"{TABS[1]}\"{description}\"")
	WriteLine(	f"{TABS[3]}\"description_format\"{TABS[1]}\"value_is_additive\"")
	if(description != False):
		if(effect == 1):
			WriteLine(	f"{TABS[3]}\"effect_type\"{TABS[3]}\"positive\"")
		elif(effect == -1):
			WriteLine(	f"{TABS[3]}\"effect_type\"{TABS[3]}\"negative\"")
		elif(effect == 0):
			WriteLine(	f"{TABS[3]}\"effect_type\"{TABS[3]}\"neutral\"")
	if(Isstring != False):
		WriteLine(	f"{TABS[3]}\"attribute_type\"{TABS[2]}\"string\"")
	if(description == False or Isstring == True or hidden == True):
		WriteLine(	f"{TABS[3]}\"hidden\"{TABS[4]}\"1\"")
	else:
		WriteLine(	f"{TABS[3]}\"hidden\"{TABS[4]}\"0\"")
	WriteLine(	f"{TABS[2]}}}", False)
	print(string)

def WriteLine(line: str, newline = True):
	global string
	line = line.expandtabs(4)
	string += line
	if(newline):
		string += "\n"

# print(attribs)

index = 50000
for attrib, data in attribs.items():
	ConstructAttrib(index, attrib, data[0], data[1], data[2], data[3])
	index += 1