# Open up the file to access it
file = open("chaosmvm/translations.nut", "r", encoding="utf-8")

# Removes a substring from the entire string
def RemoveSubStringFromString(string: str, sub_string: str) -> str:
	new_string: str = string
	while sub_string in new_string:
		new_string = new_string[0:new_string.find(sub_string)] + new_string[new_string.find(sub_string) + len(sub_string):]
	return new_string

# Removes multiple substrings from a string
def RemoveSubStringsFromString(string: str, substrings: [str]) -> str:
	new_string: str = string
	for string in substrings:
		new_string = RemoveSubStringFromString(new_string, string)
	return new_string

# Removes letters after a substring, mostly to remove comments such as "//"
def RemoveAllLettersAfterSubString(string: str, sub_string: str) -> str:
	if(sub_string not in string):
		return string
	return string[0:string.find(sub_string)]

errors = 0

line_num = 0
last_item = ""
# lines = []
for line in file:
	line_num += 1
	if(line_num <= 11):
		continue
	if(line == "\n"):
		continue
	parsed_line = RemoveSubStringsFromString(RemoveAllLettersAfterSubString(line, "//"), ["\t", "\n", " "])
	# Ignore lines that start with single lines comments, and brackets
	if(len(parsed_line) == 0 or parsed_line[0] == "{" or parsed_line[0] == "}"):
		continue

	item = parsed_line.split("=")[0]
	# value = parsed_line.split("=")[1]
	if(item == last_item):
		print(f"WARNING: LINE {line_num} AND {line_num-1} ARE DUPLICATE ITEMS!")
		print(f"{line_num-1} \t\t {last_item} = . . .")
		print(f"{line_num} \t\t {item} = . . .")
		errors += 1
	last_item = item
	# lines.append(parsed_line)
file.close()

import sys

if(errors == 0):
	print("No Errors found!")
else:
	print(f"Found {errors} errors!")
	sys.exit(1)