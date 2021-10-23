%lex
%%
\s /* skip whitespace */
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
"true" return "TRUE"
"false" return "FALSE"
\'[a-zA-Z0-9\s]+\' return "STRING"
[a-zA-Z0-9]+\b return "NODE"
"<" return "<"
">" return ">"
"<=" return "<="
">=" return ">="
"==" return "=="
"!=" return "!="
//"'" return "QUOTE"


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
        { $$ = [$path, ...$paths]; }
    | path
        { $$ = [$path];}
    ;


path
    : sep NODE filter
        { $$ =   {type:'path', sep: $sep, node: $NODE, filter: $filter}  }
    | sep NODE
        { $$ = {type: 'path',sep: $sep, node: $NODE};}
     }
    ;


filter
    : '[' '?' '(' expr_bool ')' ']'
        { $$ = $expr_bool }
    | '[' '*' ']'
        { $$ = null }
    ;


expr_bool
    : expr_bool OR expr_bool
        { $$ = (function(e1, e2){
                const isOrOp = (e) => e.type=='expr_bool' && e.op=='OR' && !e.priority;
                const isExpr = e => e.type!='exp_bool';
                if(isOrOp(e1) && isOrOp(e2)){
                    e1.args = [...e1.args, ...e2.args];
                    return e1;
                }else if(isOrOp(e1) && isExpr(e2)) {
                    e1.args.push(e2);
                    return e1;
                }else if(isExpr(e1) && isOrOp(e2)){
                    e2.args.push(e1);
                    return e2;
                }else {
                    return {type:'expr_bool', op:'OR', args:[$1, $3]};
                }  
                
            })($1, $3) 
        }
    | expr_bool AND expr_bool
        { $$ = (function(e1, e2){
                const isAndExpr = (e) => e.type=='expr_bool' && e.op=='AND' && !e.priority;
                const isExpr = e => e.type!='exp_bool';
                if(isAndExpr(e1) && isAndExpr(e2)){
                    e1.args = [...e1.args, ...e2.args];
                    return e1;
                }else if(isAndExpr(e1) && isExpr(e2)) {
                    e1.args.push(e2);
                    return e1;
                }else if(isExpr(e1) && isAndExpr(e2)){
                    e2.args.push(e1);
                    return e2;
                }else {
                    return {type:'expr_bool', op:'AND', args:[$1, $3]};
                }  
                
            })($1, $3);
        }
    | '(' expr_bool ')'
        { $$ = {...$expr_bool, priority: true} }
    | expr_compare
        { $$ = $1; }
    ;


sep
    : '.'
        { $$ = '.';}
    | '..'
        { $$ = '..';}
    ;


expr_compare
    : value '==' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value '>' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value '<' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value '>=' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value '<=' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value '!=' value  
        { $$ = { type: 'expr_compare', op: $2, args:[$1, $3] }; }
    | value
    ;


value
    : NUMBER 
        { $$ = {type: "number", value: $1}; }
    | TRUE
        { $$ = {type: "bool", value: true};}
    | FALSE
        { $$ = {type: "bool", value: false};}
    | selector
        { $$ = $1 }
    | STRING
        { $$ = {type: "string", value: $1};}
    
    ;

selector
    : AT '.' NODE 
        { $$ = {type: 'node', value: $3} }
    ;