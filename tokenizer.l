/* Definition Section */ 

%{  
void headerFileName(char a[]); 
int blockcounter=0;  
%} 

/* Starting character sequence for multiline comment */ 
startOfComment \/\* 
/* Ending character sequence for multiline comment */ 
endOfComment \*\/ 
/* Character sequence for identifiers */ 
identifier [a-zA-Z_][a-zA-Z0-9_]*

/*Rule Section*/ 
%% 
\/\/(.*) {/* No action is assigned, to remove single line comments */} ; 
{startOfComment}.*{endOfComment} {/* No action is assigned, to remove multi line comments */} ;
"#include <".*".h>" {/* Pattern to match header file. */headerFileName(yytext);fprintf(yyout, "%s", yytext);}
"{" {/* Pattern to match block start */blockcounter++;printf("block start(%d): %s\n",blockcounter,yytext);fprintf(yyout, "%s", yytext);}
"}" {/* Pattern to match block end. */printf("block end(%d): %s\n",blockcounter,yytext);blockcounter--;fprintf(yyout, "%s", yytext);}
"while"|"if"|"else"|"return"|"int"|"float"|"void" {/* Pattern to match keywords. */printf("keyword : %s\n", yytext);fprintf(yyout, "%s", yytext);} 
{identifier}"(".*")" {/* Pattern to match function. */printf("function : %s\n",yytext);fprintf(yyout, "%s", yytext);}
{identifier} {/* Pattern to match identifier. */printf("identifier : %s\n", yytext);fprintf(yyout, "%s", yytext);}
[0-9]*"."[0-9]+ {/* Pattern to match digits(integer) */printf("digit(float) : %s\n", yytext);fprintf(yyout, "%s", yytext);}
[0-9]+ {/* Pattern to match digits(float). */printf("digit(integer) : %s\n", yytext);fprintf(yyout, "%s", yytext);} 
[()|,;]    {/* Pattern to match seprators */;printf("separator : %s\n", yytext);fprintf(yyout,"%s",yytext);}
[+-=\*<>]|"!="   {/* Pattern to match operators */;printf("operator : %s\n", yytext);fprintf(yyout,"%s",yytext);}
%% 

/*Driver function*/ 

int main(int argc,char **argcv) 
{ 
    printf("\n\n");
    yyin=fopen(argcv[1],"r");
    yyout=fopen("out.c","w"); //Creates out.c which is the input .c file without comments.
    yylex(); 
    return 0; 
}

void headerFileName(char a[])
{
    #include <string.h>
    int length = strlen(a);
    printf("Pre-processor Directive : ");
    
    for(int i=0;i<8;i++)
    printf("%c",a[i]);
    printf("\n");
    printf("separator: <\n");
    printf("Header File : ");
    for(int i=10;i<length-1;i++)
    printf("%c",a[i]);
    printf("\n");
    printf("separator: >\n");
}

int yywrap()
{
    return(1);
}
