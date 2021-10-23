const parser = require("./jsonpath").parser;

const examples = {};
let i = 0;
examples[i] = `$..prop[*]`,
examples[++i] =  `$.prop[?(@.nodeA||@.nodeB)]`;
examples[++i] = `$.prop[?(@.nodeA||@.nodeB||@.nodeC)]`;
examples[++i] = `$.prop[?(@.nodeA&&@.nodeB||@.nodeC||@.nodeD)]`,
examples[++i] = `$.prop[?(@.nodeA||@.nodeB&&@.nodeC&&@.nodeD)]`;
examples[++i] = `$.prop[?(@.nodeA&&@.nodeB||@.nodeC&&@.nodeD)]`;
examples[++i] = `$.prop[?(@.nodeA&&@.nodeB||@.nodeC||@.nodeD)]`,
examples[++i] =  `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[*].prop3`;
examples[++i] = `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[?(@.prop4)].prop3`;

const jsonpath = examples[5];

const parsed = parser.parse(jsonpath);

console.log();
console.log(jsonpath);
console.log();
console.log(JSON.stringify(parsed, null , 4));
console.log();