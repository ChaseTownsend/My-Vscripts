
final_file = ""
starting_value = 5200
ending_value = 5300

while starting_value <= ending_value:
    final_file += f"|-\n| {str(starting_value)} || \n"
    starting_value += 1
final_file += "|-"

print(final_file)