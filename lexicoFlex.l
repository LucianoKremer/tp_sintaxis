%{

#include <stdio.h>
#include <string.h>
#include "sintacticoBison.tab.h"
void errorLexico();

%}

%option yylineno

DIGITO ["0-9"]
LETRA ["a-z"]
GUION ["_"]
IDENTIFICADOR {LETRA}+({GUION}{LETRA}+)*
NUMERO {DIGITO}+
BLANCO [ "\t"]
NUEVALINEA [ \n]

%%

"calcularFecha"  { printf("Token tipo: CALCULARFECHA \n "); yylval.reservada = strdup(yytext); return CALCULARFECHA; }
"calcularEdad"   { yylval.reservada = strdup(yytext); return CALCULAREDAD; }
"mostrarEdad"    { yylval.reservada = strdup(yytext); return MOSTRAREDAD; }

"int"            { printf("Token tipo: ENTERO %s \n ", yytext); return ENTERO; }
"inicio"         { return INICIO; }
"fin"            { return FIN; }
"es"             { printf("Token tipo: ASIGNACION %s \n ", yytext); yylval.reservada = strdup(yytext); return ASIGNACION; }

{BLANCO}+        ; // para reconocer los espacios en blanco
{NUEVALINEA}+    ; // para reconocer los saltos de línea
{IDENTIFICADOR}  { printf("Token tipo: IDENTIFICADOR %s \n ", yytext); yylval.reservada = strdup(yytext); return ID; }
{NUMERO}         { printf("Token tipo: ENTERO %s \n ", yytext); yylval.number = atoi(yytext); return NUMERO; }

"."              { printf("Token tipo: PUNTO"); return PUNTO; }
","              { return COMA; }
"("              { printf("Token tipo: PARENTESISIZQUIERDO \n "); return PARENTESISIZQUIERDO; }
")"              { printf("Token tipo: PARENTESISDERECHO \n ");return PARENTESISDERECHO; }
"+"              { return SUMA; }
"-"              { return RESTA; }



.                { errorLexico(yytext); return OTHER; }

%%

void errorLexico(char* lexema) {
    printf("Error léxico en la línea %d: Caracter no reconocido: %s\n", yylineno, lexema);
    exit(EXIT_FAILURE);
}

int yywrap(){
    return 1;
}


