%{

#include <stdio.h>
#include <stdlib.h> 
#include <string.h>

extern int yylineno;

struct Variable{
    char* nombre;
    int valor;
};

struct Nodo{
    struct Variable info;
    struct Nodo*sig;
};


int yylex(); 
int yyerror(char*);
int main(int argc, char **argv);
int calcularEdad(int fechaActual, int fechaNacimiento);
void mostrarEdad ( int edad);
int calcularFecha(int anio, int mes, int dia);
void asignarValorA(char* unIdentificador, int unValor);
void cambiarValorA(char* unIdentificador, int unValor);
void insertar(struct Nodo*lista, struct Variable var);
void reemplazarEn(struct Nodo*lista, char* unIdentificador, int unValor);
struct Nodo*buscar(struct Nodo*lista, char* unIdentificador);
void liberarMemoria(struct Nodo* lista);


struct Nodo* lista = NULL;

%}

%error-verbose

%token ASIGNACION PUNTO SUMA RESTA PARENTESISIZQUIERDO PARENTESISDERECHO COMA OTHER ID NUMERO CALCULARFECHA CALCULAREDAD MOSTRAREDAD INICIO FIN ENTERO

%union{
   char cadena[30];
   int number;
   char* reservada;
} 

%type <cadena> ID sentencia sentencias
%type <number> NUMERO expresion primaria 
%type <reservada> MOSTRAREDAD CALCULARFECHA CALCULAREDAD INICIO FIN ENTERO ASIGNACION

%start prog

%%

prog: 
    INICIO { printf("Regla: INICIO\n")} sentencias { printf("Regla: sentencias\n")} FIN { printf("Regla: FIN\n")};
;

sentencias : sentencias sentencia { printf("Regla:sentencias sentencia\n")}
        | sentencia {printf("Entro a sentencia\n")}
;

sentencia: ENTERO ID PUNTO {printf("Regla: ENTERO ID PUNTO\n"); asignarValorA($2, 0);};
        | ENTERO ID ASIGNACION NUMERO PUNTO {printf("Regla: ENTERO ID ASIGNACION NUMERO PUNTO\n"); asignarValorA($2, $4); }; 
        | ID ASIGNACION expresion PUNTO { cambiarValorA($1, $3); };
        | ENTERO ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO NUMERO NUMERO NUMERO PARENTESISDERECHO PUNTO {asignarValorA($2, calcularFecha($6, $7, $8)); }; // SI ME DAN 3 NUMEROS
        | ENTERO ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO NUMERO NUMERO PARENTESISDERECHO PUNTO {asignarValorA($2, calcularEdad($6, $7)); }; // SI ME DAN 2 NUMEROS
        | ENTERO ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO ID ID ID PARENTESISDERECHO PUNTO {asignarValorA($2, calcularFecha(buscar(lista, $6)->info.valor, buscar(lista, $7)->info.valor, buscar(lista, $8)->info.valor)); }; // SI ME DAN 3 IDENTIFICADORES
        | ENTERO ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO ID ID PUNTO PARENTESISDERECHO PUNTO {asignarValorA($2, calcularEdad(buscar(lista, $6)->info.valor, buscar(lista, $7)->info.valor)); }; // SI ME DAN 2 IDENTIFICADORES
        | MOSTRAREDAD PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO { mostrarEdad(buscar(lista, $3)->info.valor) };
;


expresion: primaria {$$ = $1; }
        | expresion SUMA primaria { $$ = $1 + $3; }
        | expresion RESTA primaria { $$ = $1 - $3; }
; 

primaria: ID { $$ = (buscar(lista, $1)->info.valor); }
        |NUMERO { $$ = $1 ; }
        |PARENTESISIZQUIERDO expresion PARENTESISDERECHO { $$ = $2; }
;

%%



int yyerror(char *s)
{
	printf(" -> Error sintactico en linea %d \n", yylineno);
	return 0;
}

int main(int argc, char **argv)
{
    yyparse();
    liberarMemoria(lista);
    return 0;
}

void liberarMemoria(struct Nodo* lista) {
    struct Nodo* p = lista;
    while (p != NULL) {
        free(p->info.nombre);
        struct Nodo* temp = p;
        p = p->sig;
        free(temp);
    }
}

int calcularEdad(int fechaActual, int fechaNacimiento) {
    int dia_a = fechaActual % 100;
    int mes_a = (fechaActual % 10000 - dia_a) / 100;
    int anio_a = fechaActual / 10000;
    int dia_n = fechaNacimiento % 100;
    int mes_n = (fechaNacimiento % 10000 - dia_n) / 100;
    int anio_n = fechaNacimiento / 10000;

    int edad_a = anio_a - anio_n;
    int edad_m = mes_a - mes_n;
    int edad_d = dia_a - dia_n;
    int aux;
    
    if(edad_m <= 0) {
        edad_a--;
        aux = 12 - edad_m;
        edad_m = aux;
    }

    if(edad_d < 0) {
        edad_m--;
        aux = 30 - edad_d;
        edad_d = aux;
    }
    return edad_a * 10000 + edad_m * 100 + edad_d; 
}

void mostrarEdad ( int edad){
    int edad_d = edad % 100;
    int edad_m = (edad % 10000 - edad_d) / 100;
    int edad_a = edad / 10000;

    printf("Usted tiene %d años, %d meses y %d dias\n", edad_a, edad_m, edad_d);
}

int calcularFecha(int anio, int mes, int dia){
    return anio * 10000 + mes * 100 + dia;
}

void asignarValorA(char* unIdentificador, int unValor) {
    struct Variable aux;
    aux.nombre = strdup(unIdentificador);
    aux.valor = unValor;
    printf("Regla: ASIGNAR VALOR A\n");
    insertar(lista, aux);
}

void cambiarValorA(char* unIdentificador, int unValor) {
    struct Variable aux;
    aux.nombre = strdup(unIdentificador);
    aux.valor = unValor;
    reemplazarEn(lista, unIdentificador, unValor);
}

void insertar(struct Nodo*lista,struct Variable var)
{
    struct Nodo *n,*p,*ant;
    n = (struct Nodo*)malloc(sizeof(struct Nodo));
    n->info.valor = var.valor;
    n->info.nombre = var.nombre;
     printf("Regla: insertar\n");
    p = lista;
    while(p!=NULL)
    {
        ant=p;
        p=p->sig;
    }
    n->sig=p;
    if(p!=lista)
        ant->sig=n;
    else
        lista=n;
    
}

void reemplazarEn(struct Nodo*lista,char* unIdentificador, int unValor)
{
    struct Nodo*objetivo=buscar(lista, unIdentificador);
    if(objetivo == NULL){
    printf("Esta intentando asignar %d a un identificador : %s que no existe", unValor, unIdentificador);
        exit(0);
    }  
    else
        objetivo->info.valor = unValor;
        
}

struct Nodo*buscar(struct Nodo*lista, char* unIdentificador)
{
    struct Nodo*p=lista;
    while(p!=NULL && p->info.nombre != unIdentificador)
        p=p->sig;
    return p;
}

