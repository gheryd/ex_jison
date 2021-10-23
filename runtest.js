const parser = require("./jsonpath").parser;

const examples = {
    0: `$..prop[*]`,
    1: `$.prop[?(@.nodeA||@.nodeB||@.nodeC)]`,
    2: `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)]`,
    3: `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[*].prop3`,
    4: `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[?(@.prop4)].prop3`,
};

const jsonpath = examples[1];

const parsed = parser.parse(jsonpath);

console.log();
console.log(jsonpath);
console.log();
console.log(JSON.stringify(parsed, null , 4));
console.log();