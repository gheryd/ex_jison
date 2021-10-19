%lex
%%
"$" return "DOLLAR"
".." return "DOT_DOT"
"." return "DOT"
"[" return "OPEN_BRACKET"
"]" return "CLOSE_BRACKET"
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
    : DOT_DOT parentesi
        { $$ = {type: "doppio punto", child: $2 }; }
    ;

parentesi
    : OPEN_BRACKET cont_parentesi CLOSE_BRACKET
        { $$ = {type: "square bracket", content: $2}; }
    ;

cont_parentesi
    : NUMBER op NUMBER
        { $$ = {op: $2, args:[$1, $3]}; }
    ;

op
    : OR
        { $$ = 'OR';}
    | AND
        { $$ = 'AND';}
    ;

