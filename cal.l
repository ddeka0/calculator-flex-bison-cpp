%{
	#include <iostream>
	#include <cstdio>
	#include <string>
	using namespace std;
	#include "cal.tab.h"
	void yyerror(char *);
	int yyparse(void);

%}

%%

[ \t\n]+						;
"print"							return PRINT;
[a-zA-Z][a-zA-Z0-9]*			{ yylval.str_val = new string(yytext); return VARIABLE;}
[0-9][0-9]*(.[0-9]+)?			{ yylval.double_val = atof(yytext); return NUMBER;}
"="								return EQUALS;
"+"								return PLUS;
"-"								return MINUS;
"*"								return ASTERISK;
"/"								return FSLASH;
"("								return LPAREN;
")"								return RPAREN;
";"								return SEMICOLON;

%%

void yyerror(char *str) {
	printf("Parse Error: \n%s \n",str);
}
int yywrap(void) {
	
}

int main(int argc, char ** argv) {
	if(argc != 2) {printf("usage: parser.exe or ./parser filename.ext\n"); exit(0);}
	FILE *file = fopen(argv[1],"r");
	if(file == NULL) {printf("unable to open %s\n",argv[1]); exit(0);}
	yyin = file;
	yyparse();
	fclose(file);
}
