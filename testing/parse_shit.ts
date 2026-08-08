import * as fs from "fs"
import * as path from 'path';

interface AttributeData {
	name: string
	attribute_class: string

	description_string?: string
	description_format?: string
	hidden?: string
}

interface TF2SchemaRoot {
	attributes: Record<string, AttributeData> // Keys are dynamic IDs like "1"
}

function parseTf2Attributes(): string {
	var NewFileData: string = ""
	try {
		const filePath = path.resolve(__dirname, 'tf2_schema.json')
		const rawData = fs.readFileSync(filePath, 'utf-8')

		// Parse the entire file using the root interface
		const schema: TF2SchemaRoot = JSON.parse(rawData)

		// Isolate just the attributes dictionary
		const attributesDict = schema.attributes

		// Option A: Loop through them as key-value pairs
		console.log("--- Iterating as Key/Value pairs ---")
		Object.entries(attributesDict).forEach(([id, attr]) => {
			// | [IDX] || [Attribute Name] || [Desc String] || [Type] || [Class] || [Notes]
			const Name: string = attr.name
			const Class: string = attr.attribute_class

			const Description: string = attr.description_string ?? ""
			const Format: string = attr.description_format ?? "additive"
			const Hidden: boolean = attr.hidden === "1"

			var NewData = `| ${id} || ${Name} || ${Description} || ${Format} || ${Class} || `

			if (Hidden == true) {
				NewData += "Hidden"
			}
			NewData += "\n|-\n"

			NewFileData += NewData

			console.log(NewData)
		});
	} catch (error) {
		console.error("Error processing TF2 schema:", error);
	}
	return NewFileData
}

const allAttributes: string = parseTf2Attributes()

console.log("Final Format: ")
console.log(allAttributes)