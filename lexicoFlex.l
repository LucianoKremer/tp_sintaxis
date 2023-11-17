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
IDENTIFICADOR {LETRA}+({GUION}{LETRA}+)?
NUMERO {DIGITO}+
BLANCO [ \t]
NUEVALINEA [ \n]

%%

"("              { printf("Token tipo: PARENTESISIZQUIERDO \n "); return PARENTESISIZQUIERDO; }
")"              { printf("Token tipo: PARENTESISDERECHO \n ");return PARENTESISDERECHO; }
"inicio"         { return INICIO; }
"fin"            { return FIN; }
"Es"             { printf("Token tipo: ASIGNACION %s \n ", yytext); yylval.reservada = strdup(yytext); return ASIGNACION; }
"Int"            { printf("Token tipo: ENTERO %s \n ", yytext); return ENTERO; }
"CalcularFecha"  { printf("Token tipo: CALCULARFECHA \n "); yylval.reservada = strdup(yytext); return CALCULARFECHA; }
"CalcularEdad"   { yylval.reservada = strdup(yytext); return CALCULAREDAD; }
"MostrarEdad"    { yylval.reservada = strdup(yytext); return MOSTRAREDAD; }
"."              { printf("Token tipo: PUNTO"); return PUNTO; }
","              { return COMA; }

"+"              { return SUMA; }
"-"              { return RESTA; }

{BLANCO}+        ; // para reconocer los espacios en blanco
{NUEVALINEA}+    ; // para reconocer los saltos de línea
{IDENTIFICADOR}  { printf("Token tipo: IDENTIFICADOR %s \n ", yytext); yylval.reservada = strdup(yytext); return ID; }
{NUMERO}         { printf("Token tipo: ENTERO %s \n ", yytext); yylval.number = atoi(yytext); return NUMERO; }

.                { errorLexico(yytext); return OTHER; }

%%

void errorLexico(char* lexema) {
    printf("Error léxico en la línea %d: Caracter no reconocido: %s\n", yylineno, lexema);
    exit(EXIT_FAILURE);
}

int yywrap(){
    return 1;
}


