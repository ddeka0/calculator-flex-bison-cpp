%{
	#include <iostream>
	#include <cstdlib>
	#include <string>
	#include <map>
	#include <cstdio>
	using namespace std;
	map<string,double> vars;
	extern int yylex();
	extern void yyerror(char *);
	void DivError(void);
	void UnknownVarError(string s);
%}

%union {
	int int_val;
	double double_val;
	string* str_val;
}

%token <int_val> PLUS MINUS ASTERISK FSLASH EQUALS PRINT LPAREN RPAREN SEMICOLON
%token <str_val> VARIABLE
%token <double_val> NUMBER
%type <double_val> exp;
%type <double_val> inner1;
%type <double_val> inner2;
%start parsetree

%%

parsetree		: lines
				;
lines			: lines line
				| line
				;
line			: PRINT exp SEMICOLON				{ printf("%lf\n",$2);}
				| VARIABLE EQUALS exp SEMICOLON		{ vars[*$1] = $3 ; delete $1;}
				;
exp				: exp PLUS inner1					{ $$ = $1 + $3;}
				| exp MINUS inner1					{ $$ = $1 - $3;}
				| inner1							{ $$ = $1;}
				;

inner1			: inner1 ASTERISK inner2			{ $$ = $1 * $3;}
				| inner1 FSLASH inner2 				{	
														if($3 == 0) 
															DivError();
										  				else
															$$ = $1 / $3;
									   				}
				| inner2							{ $$ = $1;}
				;
inner2			: VARIABLE							{ 
														if(!vars.count(*$1)) UnknownVarError(*$1);
													  	else $$ = vars[*$1];
													  	delete $1;
													}
				| NUMBER							{ $$ = $1;}
				| LPAREN exp RPAREN					{ $$ = $2;}
				;

%%


void DivError(void) {
	printf("Error: division by zero\n");
	exit(0);
}

void UnknownVarError(string s) {
	printf("Error: %s does not exist !\n", s.c_str());

}
