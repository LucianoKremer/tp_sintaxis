%{

#include <stdio.h>
#include <stdlib.h> 
#include <string.h>
#include <stdbool.h>

extern int yylineno;

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
extern int yywrap();

extern void asignarId(char* id, int valor);
extern void inicializarIdentificadores();
extern bool estaElIdRegistrado(char* id);
extern void actualizarId(char*id, int valor);
extern void reasignarId(char*id, int valor);
extern int obtenerValor(char* id);
extern int valorId(char* id);
extern int calcularFecha(int anio, int mes, int dia);
extern int calcularEdad(int fechaActual, int fechaNacimiento);
extern void mostrarEdad (int edad);


struct Id {
	char id[30];
	int num;
};

struct Id listaIds[100];
int contadorIds = 0;

%}



%token ASIGNACION PUNTO SUMA RESTA PARENTESISIZQUIERDO PARENTESISDERECHO COMA OTHER CALCULARFECHA CALCULAREDAD MOSTRAREDAD INICIO FIN ENTERO
%token <cadena> ID  
%token <num> NUMERO

%union{
   char* cadena;
   int num;
} 

%%

programa: INICIO {printf("Inicio de analisis sintactico \n");} sentencias FIN
;

sentencias : sentencia {printf("Inicio de analisis sintactico sentencia \n");}
        | sentencias sentencia  
;

sentencia: ENTERO ID ASIGNACION NUMERO PUNTO { char* id = $<cadena>2; int valor = $<num>4; asignarId(id, valor); printf("Fin de asignacion \n");  }
        | ID ASIGNACION NUMERO PUNTO { char* id = $<cadena>1; int valor = $<num>3; reasignarId(id, valor); printf("Fin de asignacion \n");  }
        | ENTERO ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO ID ID ID PARENTESISDERECHO PUNTO { char* id = $<cadena>2; char* id1 = $<cadena>6; char* id2 = $<cadena>7; char* id3 = $<cadena>8; int valor1 = valorId(id1); int valor2 = valorId(id2); int valor3 = valorId(id3); int fecha = calcularFecha(valor1, valor2, valor3); asignarId(id, fecha); printf("Fin de calculo de fecha \n");}
        | ENTERO ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO ID ID PARENTESISDERECHO PUNTO { char* id = $<cadena>2; char* id1 = $<cadena>6; char* id2 = $<cadena>7; int valor1 = valorId(id1); int valor2 = valorId(id2); int edad = calcularEdad(valor1, valor2); asignarId(id, edad); printf("Fin de calculo de edad \n");}
        // | ID ASIGNACION CALCULARFECHA PARENTESISIZQUIERDO ID ID ID PARENTESISDERECHO PUNTO
        // | ID ASIGNACION CALCULAREDAD PARENTESISIZQUIERDO ID ID PARENTESISDERECHO PUNTO
        | MOSTRAREDAD PARENTESISIZQUIERDO ID PARENTESISDERECHO PUNTO {char* id = $<cadena>3; int valor = valorId(id); mostrarEdad(valor); printf("Fin de muestreo de edad \n");}
;


%%

int main() {
    inicializarIdentificadores();
    yyparse();
    return 1;
}

void yyerror (char *s){
    printf ("Error de tipo semantico en linea %d \n", yylineno);
}

int yywrap()
{
    return 1;
}

int calcularFecha(int anio, int mes, int dia) {
    return anio * 10000 + mes * 100 + dia;
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
    
    int edad;

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
    edad = edad_a * 10000 + edad_m * 100 + edad_d;
    printf("La edad no procesada es de: %d ", edad);

    return edad; 
}

void mostrarEdad (int edad) {
    int edad_d = edad % 100;
    int edad_m = (edad % 10000 - edad_d) / 100;
    int edad_a = edad / 10000;

    printf("Usted tiene %d años, %d meses y %d dias\n", edad_a, edad_m, edad_d);
}



void inicializarIdentificadores() {
    printf("inicializacion de memoria para identificadores \n");
    for(int i = 0; i<100; i++) {
        listaIds[i].num = 0;
    }
}

void asignarId(char* id, int valor)
{
	int i = 0;
    int aux = 0;
	bool encontrado = false;
	if(estaElIdRegistrado(id)){
        actualizarId(id, valor);
    } else 
	{
        printf("inicializacion de identificador: %s, de valor: %d \n", id, valor);
	    strcpy(listaIds[contadorIds].id, id);
	    listaIds[contadorIds].num = valor;
        printf("identificador: %s, asignado a: %d \n", listaIds[i].id, listaIds[i].num);
	    contadorIds++;
	}
}

bool estaElIdRegistrado(char* id) {
    for(int i = 0; i<contadorIds; i++){
        if(strcmp(listaIds[i].id, id) == 0){
            return true;
        }
    }
    printf("Identificador: %s, no encontrado. Comienzo de inicializacion \n", id);
    return false;
}

void actualizarId(char*id, int valor) {
    int i = 0;
    while(i<contadorIds) {
        if(strcmp(listaIds[i].id, id) == 0){
            listaIds[i].num = valor;
            return;
        }
    }
}

void reasignarId(char*id, int valor) {
    if(estaElIdRegistrado(id)){
        actualizarId(id, valor);
    }else {
        printf("Error semantico, intenta asignar un id no creado \n");
        exit(0);
    }
}

int valorId(char* id) {
    if(estaElIdRegistrado(id)){
        printf("Identificador: %s encontrado, su valor es: %d \n", id, obtenerValor(id));
        return obtenerValor(id);
    }else{
        printf("Error semantico, esta pidiendo el valor de un id no creado \n");
        exit(0);
    }
}

int obtenerValor(char* id) {
    int i = 0;
    char*aux;
    while(i<contadorIds) {
        aux = &listaIds[i].id[0];
        if(strcmp(aux, id) == 0){
            return listaIds[i].num;
        }
        i++;
    }
    return 0; //nunca va a llegar aca porque en "valorId" ya verifique que exista
}

