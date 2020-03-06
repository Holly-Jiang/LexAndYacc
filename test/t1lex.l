%{
        #include "y.tab.h"
        #include <stdio.h>
        #include <string.h>
        
        int line =1;
        void yyerror(char *);
        int yywrap(void);
%}


        char [A-Za-z]
        num [0-9]
        eq [=]
        name {char}+
        age {num}+
        %%
        {name} { yylval = strdup(yytext);
        return NAME; }
        {eq} { return EQ; }
        {age} { yylval = strdup(yytext);
        return AGE; }
%%
        [ \t]   {;}
        [\n]    {line++;}
        [/][*](.)*[*][/]        {;}

"if"    {return SYM_if;}
"else"  {return SYM_else;}
"while" {return SYM_while;}
"endif" {return SYM_endif;}
"endwhile" {return SYM_endwhile;}
"do" {return SYM_do;}
"then" {return SYM_then;}
"cobegin" {return SYM_cobegin;}
"coend" {return SYM_coend;}
"wait" {return SYM_wait;}
"skip" {return SYM_skip;}





        [A-Za-z]([A-Za-z]|[0-9])*  {
        yylval.ident=(char *)malloc(strlen(yytext)+1);
        strcpy(yylval.ident,yytext);
        return ID;
        }

[0-9]+  {
        yylval.number=atoi(yytext);
        return NUM;}

"%"             {return F_mod;}
"++"            {return F_autoincrement;}
"--"            {return F_autodecrement;}
":="            {return F_becomes;}
"<"             {return F_lss;}
"<="            {return F_leq;}
">"             {return F_grt;}
">="            {return F_geq;}
"=="            {return F_jud;}
"!="            {return F_notjud;}
"+"             {return F_plus;}
"-"             {return F_minus;}
"*"             {return F_times;}
"/"             {return F_slash;}
"("             {return F_lparen;}
")"             {return F_rparen;}
"="             {return F_eql;}
","             {return F_comma;}
";"             {return F_semicolon;}
"{"             {return F_lbrace;}
"}"             {return F_rbrace;}
"["             {return F_ll;}
"^"             {return F_disjunction;}
"v"             {return F_conjunction;}
"¬"             {return F_not;}
"||"            {return F_concurrency;}
"]"             {return F_rr;}
.               {yyerror("unknown character");
}

%%

void redirectInput(FILE *input){
        yyin=input;
}

int yygetchar(void){
        int ret;
        ret=getc(yyin);
        printf("%c",ret);
        return ret;
}

int yywrap(void)
{
return 1;
}




