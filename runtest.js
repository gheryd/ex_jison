const parser = require("./jsonpath").parser;

const jsonpath = `$..[10]`;

const parsed = parser.parse(jsonpath);

console.log();
console.log(jsonpath);
console.log();
console.log(parsed);
console.log();