%{
#include "code.h"
#include "malloc.h"

%}

%union{
char *ident;
int number;
}

%token SYM_if SYM_else SYM_while SYM_endwhile SYM_endif SYM_do SYM_then SYM_cobegin SYM_coend SYM_wait SYM_skip;
%token F_mod F_autoincrement F_autodecrement
%token F_xor F_odd
%token F_lss F_leq F_grt
%token F_geq F_plus F_minus
%token F_times F_slash F_lparen
%token F_rparen F_eql F_comma F_becomes
%token F_period F_neq F_semicolon
%token F_lbrace F_rbrace
%token F_ll F_rr F_jud
%token F_notjud
%token F_disjunction F_conjunction F_not F_concurrency


%token <ident> ID
%token <number> NUM

%%

c:
    SYM_cobegin c F_concurrency c SYM_coend |SYM_skip|ID F_becomes NUM | declaration_list statement_list|wait_statement
    declaration_list : declaration_stat | declaration_list  declaration_stat
    declaration_stat : ID F_eql NUM {$1 = $3}
    |ID F_eql ID F_plus ID  {$1 = $3 + $5}
    |ID F_eql ID F_minus ID  {$1 = $3 - $5 } |ID F_eql ID F_times ID  {$1 = $3 * $5} ;
    statement_list : statement | statement_list statement ;
    statement  : if_statement | while_statement;
    if_statement  : SYM_if judge_statement F_do statement_list SYM_else statement_list SYM_endif
    judge_statement  : true |false |
    ID F_eql ID {
    if($1==$2)return true ;else return false;
    }|
    ID F_leq ID {
    if($1<=$2)return true; else return false;
    }
    ID F_conjunction ID {
    if($1 && $2)return true;return false;
    }
    ID F_disjunction ID {
    if($1 || $2)return true;return false;
    }
    F_not ID {
    if(!$1)return true;return false;
    }
    while_statement  : SYM_while judge_statement SYM_do statement_list SYM_endwhile
    wait_statement  : SYM_wait judge_statement

%%


 yyerror(char *s){
    err++;
    printf("%s in line %d***\n",s,line);
}
void main(void)
{
    
    
    printf("Input file?\n");
    scanf("%s",fname);

    if((fin=fopen(fname,"r"))==NULL){
        printf("Cann't open file according to given filename\n");
        exit(0);
    }
    redirectInput(fin);

    printf("List object code?[y/n]");
    scanf("%s",fname);
    if(fname[0]=='y')
        listswitch=true;
    else
        listswitch=false;

    printf("List symbol table?[y/n]");
    scanf("%s",fname22);
    if(fname22[0]=='y')
        tableswitch=true;
    else
        tableswitch=false;

    err=0;
    cx=0;
    
    yyparse();

    if(err==0)
        {
        listcode();
        displaytable();
        interpret();        
        }
    else
        printf("%d errors in x0 program\n",err);
    fclose(fin);
    getchar();
    return;
}


