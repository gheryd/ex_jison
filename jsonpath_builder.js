
export function jsonpathBuilder(parsed) {
    

    const pathChunks =  parsed.paths.map(
        path => path.sep + path.node + composeFilter(path.filter)
    );

    return '$' + pathChunks.join(' ');
    
}


function composeExprBool(exprBool){
    const op = exprBool.op;
    const argsChunks = exprBool.args.map( 
        arg => {
            switch(arg.type){
                case 'expr_bool':
                    return (arg.priority ? '(' : '') + exprBool(arg) + (arg.priority ? ')' : '')
                case 'expr_compare':
                    return composeExprCompare(arg);
                default:
                    return composeValue(arg);
                
            }
        }
    )
    return argsChunks.join(' ' + op + ' ');
}


function composeExprCompare(exprCompare){
    return composeValue(exprCompare.args[0]) + 
            ' ' +
            exprCompare.op + 
            ' ' +
            composeValue(exprCompare.args[0]);
}


function composeValue(valueExpr){
    switch(valueExpr.type){
        case 'string':
        case 'bool':
        case 'string':
            return valueExpr.value
        case 'node':
            return '@.' + valueExpr.value;
    }
}


function composeFilter(filter){
    if(filter===undefined){
        return "";
    }

    if(filter===null){
        return "[*]";
    }

    return "[?(" + composeExprBool(exprBool)  + ")]";
    
}


