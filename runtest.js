const parser = require("./jsonpath").parser;

const jsonpath = `$..[10&&11]`;

const parsed = parser.parse(jsonpath);

console.log();
console.log(jsonpath);
console.log();
console.log(JSON.stringify(parsed, null , 4));
console.log();