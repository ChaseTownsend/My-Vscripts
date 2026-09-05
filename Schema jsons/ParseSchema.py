import os
import json
# from typing import TextIO
from pathlib import Path

EFFECT_NEGATIVE = -1
EFFECT_NONE = 0
EFFECT_POSITIVE = 1


VAL_ADDITIVE = 0
VAL_PERCENT = 1
VAL_ADD_PERC = 2

def GetItemsFile(input_file_path: str | os.PathLike) -> list[str]:
	"""
	Reads a file line by line, removes non-UTF-8 bytes,
	strips out all forms of newlines, and writes a single block of text.
	"""
	with open(input_file_path, 'rb') as source_file:
		 
		line_bytes: bytes
		lines = []
		for line_bytes in source_file:
			# Decode the bytes into a UTF-8 string, skipping invalid bytes
			clean_line: str = line_bytes.decode('cp1250', errors='ignore')
			
			# Remove all Windows (\r\n), Unix (\n), and old Mac (\r) newlines
			clean_line = clean_line.replace('\r\n', '').replace('\n', '').replace('\r', '')

			lines.append(clean_line)

		return lines

BadKeys = [
	"status",
]

target_file = Path(__file__).parent.resolve() / "item_schema.json"

def ParseFile():

	KeysToRemove = [
		"attributes",
		"item_description",
		"styles",
		"item_set",
		"drop_type",
		"per_class_loadout_slots",
		"capabilities",
		"item_class",
		"item_type_name",
		"item_name",
		"proper_name",
		"model_player",
		"item_quality",
		"image_inventory",
		"min_ilevel",
		"max_ilevel",
		"image_url",
		"image_url_large",
		"items_game_url",
		"craft_material_type"
	]

	BlacklistedNames = [
		"saxxy",
		"Deflector",
		"The Robo-Sandvich",
		"Memory Maker",
		"Gold Frying Pan",
		"TF_WEAPON_PASSTIME_GUN",
		"Gloves of Running Urgently MvM",
	]

	BlacklistedSlots = [
		"misc",
		"action",
		"taunt",
	]

	BlacklistedCraftClass = [
		"craft_token"
	]

	BlacklistedSets = [
		"Festive",
		"Upgradeable",
		"warbird",
		"gentlemanne",
		"pyroland",
		"harvest",
		"powerhouse",
		"teufort",
		"craftsmann",
		"concealedkiller",
	]

	def IsFromSet(name: str):
		for set_ in BlacklistedSets:
			if(name.startswith(set_)):
				return True

	def IsNameBlacklisted(name: str):
		return IsFromSet(name) or "Botkiller" in name or name in BlacklistedNames

	def IsSlotBlacklisted(slot: str):
		return slot in BlacklistedSlots

	def IsCraftClassBlacklisted(craft_class: str):
		return craft_class in BlacklistedCraftClass

	data = None
	with open(target_file, 'r') as file:
		data = json.load(file)

		Items = data["items"]

		for key in data["items"]:
			index: int = data["items"].index(key)
			name: str = key["name"]

			if("item_slot" in key):
				slot: str = key["item_slot"]
				if(IsSlotBlacklisted(slot)):
					del data["items"][index]
			else:
				print(f"Item {index}: Missing item_slot!, has defindex of {key["defindex"]}")
				del data["items"][index]

			if(IsNameBlacklisted(name)):
				del data["items"][index]

			if("craft_class" in key):
				if(IsCraftClassBlacklisted(key["craft_class"])):
					del data["items"][index]
				elif(key["craft_class"] == ""):
					data["items"][index].pop("craft_class", None)

		Items = data["items"]

		for Item in Items:
			for key in KeysToRemove:
				Item.pop(key, None)

	with open(target_file, "w", encoding="utf-8") as file:
		json.dump(data, file, indent="\t")

ParseFile()