%lex
%%

"$" return "DOLLAR"
".." return "DOT_DOT"
"." return "DOT"
"[" return "OPEN_SQUARE_BRACKET"
"]" return "CLOSE_SQUARE_BRACKET"
"(" return "OPEN_ROUND_BRACKET"
")" return "CLOSE_ROUND_BRACKET"
[0-9]+("."[0-9]+)?\b return "NUMBER"
"||" return "OR"
"&&" return "AND"
"?" return "QUESTION_MARK" 
"(" return "OPEN_ROUND_BRACKET"
")" return "CLOSE_RUOUND_BRACKET"
"@" return "AT"
"*" return "ASTERISK"
[a-zA-Z0-9]+\b return "PROPERTY"
\s+ return "SKIPME"

/lex

%left OR
%left AND

%start jsonpath
%%
jsonpath
    : DOLLAR paths
        {return {type: "$", paths: $2}; }
    | DOLLAR
        {return {type: "$"}; }
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
    : OPEN_SQUARE_BRACKET QUESTION_MARK OPEN_ROUND_BRACKET expr CLOSE_ROUND_BRACKET CLOSE_SQUARE_BRACKET
        { $$ = $4 }
    | OPEN_SQUARE_BRACKET ASTERISK CLOSE_SQUARE_BRACKET
        { $$ = {type: "all"} }
    ;

expr
    : expr op_bool expr
        { $$ = {type: "op", value: $2, args:[$1, $3]}; }
    | par
        { $$ = $1; }
    ;

op_bool
    : OR
        { $$ = 'OR';}
    | AND
        { $$ = 'AND';}
    ;

par
    : NUMBER
        { $$ = { type:'number', value:$1};}
    //| OPEN_ROUND_BRACKET expr CLOSE_ROUND_BRACKET
     //   { $$ = $2; }
    | selector
        { $$ = $1 }
    ;

selector
    : AT DOT PROPERTY
        { $$ = {type: "selector", value:$3} }
    | SKIPME AT DOT PROPERTY
        { $$ = {type: "selector", value:$3} }
    ;

sep
    : DOT
        { $$ = "child";}
    | DOT_DOT
        { $$ = "recursive";}
    ;
