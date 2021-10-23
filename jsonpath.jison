%lex
%%

"$" return "$"
".." return ".."
"." return "."
"[" return "["
"]" return "]"
"(" return "("
")" return ")"
[0-9]+("."[0-9]+)?\b return "NUMBER"
"||" return "OR"
"&&" return "AND"
"?" return "?" 
"(" return "("
")" return ")"
"@" return "AT"
"*" return "*"
[a-zA-Z0-9]+\b return "PROPERTY"
\s+ return "SKIPME"

/lex

%left AND
%left OR

%start jsonpath
%%
jsonpath
    : '$' paths
        {return {paths: $paths}; }
    | '$'
        {return {paths: []}; }
    ;

paths
    : path paths
        { $$ = [$1, ...$2]; }
    | path
        { $$ = [$1];}
     }
    ;

path
    : sep PROPERTY filter
        { $$ = {sep: $1, prop: $2, filter: $3}; }
    | sep PROPERTY
        { $$ = {sep: $1, prop: $2};}
     }
    ;

filter
    : '[' '?' '(' expr ')' ']'
        { $$ = $4 }
    | '[' '*' ']'
        { $$ = {type: 'all'} }
    ;

expr
    : expr OR expr
        { $$ = (function(e1, e2){
                console.log("-------------------------------------------------------------------");
                console.log("OR!", e1,e2);
                const isOrOp = (e) => e.type=='expr_bool' && e.op=='OR' && !e.priority;
                const isExpr = e => e.type!='exp_bool';
                if(isOrOp(e1) && isOrOp(e2)){
                    e1.args = [...e1.args, ...e2.args];
                    console.log("e1 and e2 is OR, merge args", e1);
                    return e1;
                }else if(isOrOp(e1) && isExpr(e2)) {
                    e1.args.push(e2);
                    console.log("e1 is OR and e2 is expr, add e2 to e1.args", e1);
                    return e1;
                }else if(isExpr(e1) && isOrOp(e2)){
                    e2.args.push(e1);
                    console.log("e2 is OR and e1 is expr, add e1 to e2.args", e1);
                    return e2;
                }else {
                    console.log("nested");
                return {type:'expr_bool', op:'OR', args:[$1, $3]};
                }  
                
            })($1, $3) 
        }
    | expr AND expr
        { $$ = (function(e1, e2){
                console.log("-------------------------------------------------------------------");
                console.log("AND!", e1,e2);
                const isAndExpr = (e) => e.type=='expr_bool' && e.op=='AND' && !e.priority;
                const isExpr = e => e.type!='exp_bool';
                if(isAndExpr(e1) && isAndExpr(e2)){
                    e1.args = [...e1.args, ...e2.args];
                    console.log("e1 and e2 is AND, merge args", e1);
                    return e1;
                }else if(isAndExpr(e1) && isExpr(e2)) {
                    e1.args.push(e2);
                    console.log("e1 is AND and e2 is expr, add e2 to e1.args", e1);
                    return e1;
                }else if(isExpr(e1) && isAndExpr(e2)){
                    e2.args.push(e1);
                    console.log("e2 is AND and e1 is expr, add e1 to e2.args", e1);
                    return e2;
                }else {
                    console.log("nested");
                return {type:'expr_bool', op:'AND', args:[$1, $3]};
                }  
                
            })($1, $3) 
        }
    | '(' expr ')'
        { $$ = {...$expr, priority: true} }
    | par
        { $$ = $1; }
    ;

par
    : NUMBER
        { $$ = { type:'number', value:$1};}
    //| '(' expr ')'
     //   { $$ = $2; }
    | selector
        { $$ = $1 }
    ;

selector
    : AT '.' PROPERTY
        { $$ = {type: 'selector', value:$3} }
    | SKIPME AT '.' PROPERTY
        { $$ = {type: 'selector', value:$3} }
    ;

sep
    : '.'
        { $$ = 'child';}
    | '..'
        { $$ = 'recursive';}
    ;
