%lex
%%
"$" return "DOLLAR"
".." return "DOT_DOT"
"." return "DOT"
"[" return "OPEN_SQUARE_BRACKET"
"]" return "CLOSE_SQUARE_BRACKET"
"(" return "OPEN_ROUND_BRACKET"
")" return "CLOSE_ROUND_BRACKET"
[0-9]+\b return "NUMBER"
"||" return "OR"
"&&" return "AND"
\s+\b return "PROPERTY"
/lex

%start expressione
%%
expressione
    : DOLLAR separator path
        {return {type: "root", sep: $2, content: $3}; }
    ;

separator
    : DOT
        { $$ = {type: "child"};}
    | DOT_DOT
        { $$ = {type: "recursive"};}
    ;

path
    : square_bracket
        { $$ = $1; }
    ;

square_bracket
    : OPEN_SQUARE_BRACKET expr_bool CLOSE_SQUARE_BRACKET
        { $$ = {type: "square bracket", content: $2}; }
    ;

expr_bool
    : par op_bool par
        { $$ = {type: "op", value: $2, args:[$1, $3]}; }
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
    | OPEN_ROUND_BRACKET expr_bool CLOSE_ROUND_BRACKET
        { $$ = $2; }
    ;
