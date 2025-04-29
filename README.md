# MNEDP MetodoDeLineas

# Métodos Numéricos para Ecuaciones de Advección-Difusión

[![Licencia](https://img.shields.io/badge/Licencia-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![MATLAB](https://img.shields.io/badge/MATLAB-R2024a-orange.svg)](https://www.mathworks.com/)

**Autor:** Carlos Yanes Pérez  
**Institución:** Universidad de La Laguna (ULL)  
**Asignatura:** Métodos Numéricos en EDP  
**Fecha:** 23 de abril de 2025  
**Práctica:** 3

## Descripción General

Este repositorio contiene scripts y funciones de MATLAB para resolver numéricamente una ecuación de advección-difusión utilizando el método de líneas. Se implementan diferentes variaciones del método theta para la discretización temporal, así como la función `pdepe` de MATLAB para comparación.

- NOTA: Posiblemente los códigos puedan ser optimizados. En esta implementación me he centrado en la funcionalidad, atendiendo a los plazos marcados.

## Planteamiento del Problema

El código resuelve la siguiente ecuación de advección-difusión:

∂u/∂t = ∂²u/∂x² - 0.5 * ∂u/∂x + exp(-t) * (3x² - 9x + 8)
con la condición de contorno:

u(0, t) = exp(-t)
y una condición de contorno Neumann en x=1.

La solución exacta para este problema es:

u(x, t) = (-3x² + 6x + 1) * exp(-t)
## Método de Líneas

El método de líneas se utiliza para resolver la EDP, discretizando el dominio espacial y reduciendo el problema a un sistema de EDOs que se resuelven con métodos numéricos.

## Métodos Numéricos Implementados

Los métodos numéricos implementados son:

1.  **Método theta** (`theta_metodo.m`):
    * Método progresivo (theta = 0)
    * Método de Crank-Nicolson (theta = 0.5)
    * Método regresivo (theta = 1)
2.  **Función `pdepe` de MATLAB** (`pdepe_met.m`)

## Descripción de los Archivos

* `main.m`: Script principal para ejecutar los métodos y generar resultados. Permite seleccionar entre los métodos theta y `pdepe`, y genera gráficos de las soluciones y errores.
* `theta_metodo.m`: Implementa el método theta para diferentes valores de theta (0, 0.5, 1).
* `pdepe_met.m`: Implementa la solución utilizando la función `pdepe` de MATLAB.
* `comparar_metodos.m`: Compara los resultados de los métodos theta y `pdepe`, generando gráficos comparativos y un archivo de texto con los errores.
* `errores_fun.m` (llamada desde `main.m`): Calcula y grafica la evolución del error en el tiempo y guarda los errores en un archivo de texto.

## Uso

1.  Ejecutar `main.m` en MATLAB.
2.  Seleccionar el método deseado (1 para theta, 2 para pdepe, 3 para comparar).
3.  Si se elige el método theta, ingresar el valor de theta (0, 0.5 o 1).
4.  El programa generará gráficos de la solución y/o los errores, y en algunos casos, guardará los errores en archivos de texto.

## Ejemplo

```matlab
% Ejecutar el script principal
main(20, 100)  % Ejemplo con m=20 y n=100

% Para comparar todos los métodos:
% main(10, 10)
% Seleccionar la opción 3
```
## Resultados
El programa genera: 
- Gráficos de las soluciones numéricas y la solución exacta.
- Gráficos de la evolución del error en el tiempo.
- Comparaciones de los errores entre los diferentes métodos.
- Archivos de texto con los valores de los errores.

## Conclusiones
Los resultados muestran la efectividad de los métodos numéricos implementados para resolver la ecuación de advección-difusión. El método de Crank-Nicolson, en particular, destaca por su precisión. El uso de la función `pdepe` de MATLAB proporciona una solución de referencia para comparar con las implementaciones manuales.

## Licencia
Este proyecto está licenciado bajo la Licencia MIT - consulte el archivo LICENSE para más detalles.
