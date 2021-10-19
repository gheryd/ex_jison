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
/lex

%start expressione
%%
expressione
    : DOLLAR contenuto
        {return {contenuto: $2}; }
    ;

contenuto
    : DOT_DOT parentesi_quadre
        { $$ = {type: "doppio punto", args: [$2] }; }
    ;

parentesi_quadre
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
