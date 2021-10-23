const parser = require("./jsonpath").parser;

const examples = {};
let i = -1;
examples[++i] = `$`,
examples[++i] = `$..prop[*]`,
examples[++i] =  `$.prop[?(@.nodeA||@.nodeB)]`;
examples[++i] = `$.prop[?(@.nodeA||@.nodeB||@.nodeC)]`;
examples[++i] = `$.prop[?(@.nodeA&&@.nodeB||@.nodeC||@.nodeD)]`,
examples[++i] = `$.prop[?(@.nodeA||@.nodeB&&@.nodeC&&@.nodeD)]`;
examples[++i] = `$.prop[?(@.nodeA&&@.nodeB||@.nodeC&&@.nodeD)]`;
examples[++i] =  `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[*].prop3`;
examples[++i] = `$..prop1[?(@.nodeA||@.nodeB&& @.nodeC)].prop2[?(@.prop4)].prop3`;

examples[++i] =  `$.prop[?(@.nodeA)]`;
examples[++i] =  `$.prop[?(@.nodeA>@.nodeB)]`;
examples[++i] =  `$.prop[?(@.nodeA>10)]`;
examples[++i] =  `$.prop[?(@.nodeA>10 && @.nodeB==@.nodeC)]`;
examples[++i] =  `$.prop[?(@.nodeA>10 && @.nodeB=='ci ao a')].nodeC[*]`;
examples[++i] =  `$.prop[?(@.nodeA>10 && @.nodeB!='ci ao a')].nodeC[*]`;
examples[++i] =  `$.prop[?(@.nodeA>10 && @.nodeB==false)].nodeC[*]`

const jsonpath = examples[15];

console.log();
console.log(jsonpath);




const parsed = parser.parse(jsonpath);


console.log();
console.log(JSON.stringify(parsed, null , 4));
console.log();
