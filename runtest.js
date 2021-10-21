const parser = require("./jsonpath").parser;

const jsonpath = `$..[?(@.nodeA||(@.nodeB&&@.nodeB))]`;

const parsed = parser.parse(jsonpath);

console.log();
console.log(jsonpath);
console.log();
console.log(JSON.stringify(parsed, null , 4));
console.log();