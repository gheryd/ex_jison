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
        {return {contenuto: $1}; }
    ;

contenuto
    : DOT_DOT parentesi
        { $$ = {type: "doppio punto", child: $3 } }
    ;

parentesi
    : OPEN_BRACKET NUMBER CLOSE_BRACKET
        { $$ = {type: "content bracket", num: $2} }
    ;

