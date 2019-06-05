# Taller raster

## Propósito

Comprender algunos aspectos fundamentales del paradigma de rasterización.

## Tareas

Emplee coordenadas baricéntricas para:

1. Rasterizar un triángulo.
2. Sombrear su superficie a partir de los colores de sus vértices.
3. (opcional para grupos menores de dos) Implementar un [algoritmo de anti-aliasing](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-practical-implementation) para sus aristas.

Referencias:

* [The barycentric conspiracy](https://fgiesen.wordpress.com/2013/02/06/the-barycentric-conspirac/)
* [Rasterization stage](https://www.scratchapixel.com/lessons/3d-basic-rendering/rasterization-practical-implementation/rasterization-stage)

Implemente la función ```triangleRaster()``` del sketch adjunto para tal efecto, requiere la librería [nub](https://github.com/nakednous/nub/releases).

## Integrantes

Complete la tabla:

| Integrante | github nick |
|------------|-------------|
|  Cristian Camilo Lozano Jojoa          |   CristianLozano          |

## Discusión

Se pudo obtener un programa que recibe un triangulo vectorial y retorna un triangulo rasterizado con errores de muestreo.
Tambien se logro por medio de coordenadas baricentricas, darle un color sombreado a cada punto del triangulo.
Con la ayuda de la funcion EdgeFunction se logro tambien realizar el shading y finalmente el antialiasing.
Fue de gran ayuda el articulo Rasterization: a Practical Implementation ya que nos explico de manera sencilla y practica lo que es rasterizacion de triangulos y coordenadas baricentricas.

## Entrega

* Plazo: ~~2/6/19~~ 4/6/19 a las 24h.
