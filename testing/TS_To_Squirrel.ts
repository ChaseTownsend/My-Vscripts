import "./Typescript_Squirrel_Docs.d.ts"
import * as fs from "fs"

/*
    Parses a .ts file into a .nut file for use in tf2's scripting engine
*/

function WriteFile(path: string, data: string = ""): void
{
    fs.writeFileSync(path, data)
}

function ReadFile(path: string): string
{
    return fs.readFileSync(path, {
        encoding : "utf8"
    })
}

ReadFile