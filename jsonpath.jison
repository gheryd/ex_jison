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
"?" return "QUESTION_MARK" 
"(" return "OPEN_ROUND_BRACKET"
")" return "CLOSE_RUOUND_BRACKET"
"@" return "AT"
[a-zA-Z]+\b return "ALPHABETICAL"
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
    : OPEN_SQUARE_BRACKET filter CLOSE_SQUARE_BRACKET
        { $$ = {type: "square bracket", content: $2}; }
    ;

filter
    : QUESTION_MARK OPEN_ROUND_BRACKET filter_expr CLOSE_ROUND_BRACKET
        { $$ = {type: "filter", expr: $3} }
    ;

filter_expr
    : par op_bool par
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
    | OPEN_ROUND_BRACKET filter_expr CLOSE_ROUND_BRACKET
        { $$ = $2; }
    | selector
        { $$ = $1 }
    ;

selector
    : AT DOT ALPHABETICAL
        { $$ = {type: "selector", value:$3} }
    ;
