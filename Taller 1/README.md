# Taller de análisis de imágenes por software

## Propósito

Introducir el análisis de imágenes/video en el lenguaje de [Processing](https://processing.org/).

## Tareas

Implementar las siguientes operaciones de análisis para imágenes/video:

* Conversión a escala de grises.
* Aplicación de algunas [máscaras de convolución](https://en.wikipedia.org/wiki/Kernel_(image_processing)).
* (solo para imágenes) Despliegue del histograma.
* (solo para imágenes) Segmentación de la imagen a partir del histograma.
* (solo para video) Medición de la [eficiencia computacional](https://processing.org/reference/frameRate.html) para las operaciones realizadas.

Emplear dos [canvas](https://processing.org/reference/PGraphics.html), uno para desplegar la imagen/video original y el otro para el resultado del análisis.

## Integrantes

Complete la tabla:

| Integrante 			| github nick 	 |
|-----------------------|----------------|
| Cristian Lozano Jojoa | CristianLozano |

## Discusión

Se realizarón dos sketch de processing:
1. Primero: Analisis_Imagen

   * Contiene la carga de la imagen original, el desarrollo de escala de grises, identificación de brillo, y de efecto blur.
   * Para estos se realizo en los primeros dos un canvas PImage diferente con tratado pixel a pixel de la imagen, y el último se realizo con la función filter() que processing maneja.
   * Al lado derecho de cada efecto se encuentra el histograma relacionado, mostrando tambien el segmentamiento del histograma por parte de sus puntos máximos y minimos.
   * Como resultado se encontro que el escalamiento a grises muestra un rango mas grande en el histograma con una mejor distribución de seccionamiento.
   * Tambien se ve que para el paso a brillo (Blanco y negro) el histograma reserva solamente datos para el valos negro, dejando de lado el resto de colores, no logra hacer un separamiento claro.
   * Por último, para el efecto blur, se ve un parentezco con la imagen original, pero con un mayor segmentación, pues la imagen tiene secciones de color mas claras que el original.
   
2. Segundo: Analisis_Video

   * Contiene el resultado de hacer muestra del video, de un tratado pixel a pixel (sin udo de un canvaz), y finalmente el resultado en un canvas diferente.
   * Esto se hizo para mostrar la diferencia de cargado en la imagen entre un video nuevo con sus escenas tratadas, y un muestreo de mostrar resultado directamente del video original.
   * Tambien se colocó en la parte arriba izquiera el resultado de frames, mostrando la eficiencia computacional del proceso.
   * Como resultados se puede ver como, para processing, hacer un muestreo del video original y luego su imagen en grises afecta la forma en que se ve el video, diferente al tratado directo de video.
   
## Entrega

* Hacer [fork](https://help.github.com/articles/fork-a-repo/) de la plantilla. Plazo: 28/4/19 a las 24h.
* (todos los integrantes) Presentar el trabajo presencialmente en la siguiente sesión de taller.
