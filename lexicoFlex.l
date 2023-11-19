%{

#include <stdio.h>
#include <string.h>
#include "sintacticoBison.tab.h"

void errorLexico();

%}

%option yylineno

DIGITO          ["0-9"]
LETRA           ["a-z"]
IDENTIFICADOR   {LETRA}+("_"{LETRA}+)?
NUMERO          {DIGITO}+
BLANCO          [ \t]
NUEVALINEA      [ \n]

%%

"("              { return PARENTESISIZQUIERDO;  }
")"              { return PARENTESISDERECHO;    }
"inicio"         { return INICIO;               }
"fin"            { return FIN;                  }
"es"             { return ASIGNACION;           }
"int"            { return ENTERO;               }
"calcularFecha"  { return CALCULARFECHA;        }
"calcularEdad"   { return CALCULAREDAD;         }
"mostrarEdad"    { return MOSTRAREDAD;          }
"."              { return PUNTO;                }
","              { return COMA;                 }

"+"              { return SUMA;                 }
"-"              { return RESTA;                }

{BLANCO}         ; // para reconocer los espacios en blanco
{NUEVALINEA}     ; // para reconocer los saltos de línea
{IDENTIFICADOR}  { printf("Identificador reconocido: %s \n", yytext);    yylval.cadena  = strdup(yytext);   return ID;      }
{NUMERO}         { printf("Numero reconocido: %s \n", yytext);           yylval.num     = atoi(yytext);     return NUMERO;  }

.                { errorLexico(yytext); return OTHER; }

%%

void errorLexico(char* lexema) {
    printf("Error léxico en la línea %d: Caracter no reconocido: %s\n", yylineno, lexema);
    exit(EXIT_FAILURE);
}

