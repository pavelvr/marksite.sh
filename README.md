# MarkSite v0.1.2

_Generador de Sitios Web Estáticos a partir de documentos [MarkDown](http://daringfireball.net/projects/markdown) utilizando [pandoc](http://pandoc.org) como motor de conversión a [HTML5](http://www.w3.org/TR/html5/)._

MarkDown es un lenguaje de marcado ligero, legible para humanos en su forma de entrada, y susceptible de producir múltiples formatos de salida (HTML, RTF, etc.), a través de diferentes herramientas de conversión entre formatos.

Una de estas herramientas es pandoc, muy avanzada, con funcionalidades tanto de convertir simples documentos MarkDown a HTML, como de generar libros, tesis, artículos con necesidades especiales de formateo como aquellos de contenido científico.

MarkSite consta de 3 scripts: el núcleo de funcionalidad escrito en bash (de linux, unix, ...) y dos scripts de apoyo para preparar el ambiente de ejecución con las utilidades propias de dichos sistemas (previamente compiladas para windows), garantizando que marksite pueda ser utilizado en sistemas Windows de forma transparente, portable, y sin necesidad de instalar absolutamente nada.

Es una herramienta de línea de comandos, por lo tanto, toda la interacción será a través de una consola, pero dada la sencillez de operación, no hay que asustarse, es apenas un comando, con muy pocas opciones, las mínimas necesarias para mantener un balance adecuado de facilidad de uso, potencia y flexibilidad.

## Modo de uso (resumido)

1. En Windows: abrir la consola de trabajo de `marksite` haciendo doble click sobe `cmdhere.cmd`; en sistemas Linux, abrir una terminal en el directorio de `marksite`
2. Crear un sitio
	```dos
    |> marksite init mi-sitio
    ```
3. Crear (si procede) y editar el menú principal del sitio (`mi-sitio/menu.md`). Para crearlo ejecutar el siguiente comando:
	```dos
    |> marksite init-menu mi-sitio
    ```
4. Editar los archivos de "metainformación" (`mi-sitio/metadata.yml`), de inclusión de scripts de JavaScript (`mi-sitio/js-includes.md`), de estilos (`mi-sitio/static/css/styles.css`), script de JavaScript (`mi-sitio/static/js/my.js`), que serán utilizados durante la generación y cuyo contenido afecta a todo el sitio
5. Editar el documento MarkDown `mi-sitio/content/index.md`, archivo inicial del sitio
6. Crear y editar los documentos MarkDown que deseemos (nuestras páginas)
	```dos
    |> marksite add-page mi-sitio mi-pagina
    |> marksite add-page mi-sitio directorio/mi-otra-pagina
    ```
7. Generar el sitio
	```dos
    |> marksite build mi-sitio
    ```
8. Repetir los pasos del 4 al 7 a discresión

**Nota**: Todos los archivos, tanto documentos MarkDown como archivos de configuración, deben ser editados con un editor de textos que soporte UTF-8, como [Notepad++](http://notepad-plus-plus.org/). El bloc de notas de Windows **no soporta UTF-8**.

## Modo de uso

En sistemas Windows, lo recomendado es ejecutar la herramienta `cmdhere.cmd` (haciendo doble click sobre ella, por ejemplo). Al hacerlo, se abrirá una consola ya lista para recibir comandos, además de un consejo rápido que nos recuerda que si ejecutamos `marksite.cmd` (nótese que no es necesario incluir la extención `.cmd`, bastará con escribir `marksite`) sin parámetros, nos mostrará la ayuda rápida de uso, con una lista de los parámetros posibles, y algunos ejemplos de su uso.

`marksite` funciona recibiendo comandos, y los parámetros de estos. Los comandos de `marksite` son:

- `init`
	- **Descripción**: Crea un nuevo 'sitio' (un directorio) con la estructura básica, incluyendo los directorios para las Hojas de Estilo en Cascada (archivos `.css`), los scripts escritos en JavaScript (archivos `.js`), un directorio para imágenes, un directorio para poner nuestro contenido, y algunos archivos más que servirán para que `marksite` conozca algunas opciones de configuración.
	- **Parámetros**:
		- `site-name`: El nombre de nuestro sitio, sin espacios, puede ser algo tan simple como "mi-sitio", o algo más complejo, incluyendo subdirectorios: "sitios/personal", en cuyo caso se creará un directorio "sitios" y dentro de este, el directorio "personal", con la estructura básica ya mencionada
	- **Ejemplos**:
		- `marksite init mi-sitio`
		- `marksite init sitios/personal`
- `init-menu`:
	- **Descripción**: Crea un archivo "menu.md" dentro del directorio de un sitio
	- **Parámetros**:
		- `site-name`: El nombre de nuestro sitio (tal cual lo escribimos en el momento de inicializarlo con `init`: "mi-sitio" o "sitios/personal")
	- **Ejemplos**:
		- `marksite init-menu mi-sitio`
		- `marksite init-menu sitios/personal`
- `add-page`:
	- **Descripción**: Crea un nuevo documento dentro del directorio "content" del sitio en cuestión
	- **Parámetros**:
		- `site-name`: El nombre de nuestro sitio (tal cual lo escribimos en el momento de inicializarlo con `init`: "mi-sitio" o "sitios/personal")
		- `page-name`: El nombre del archivo a crear (sin incluir la extensión .md, `marksite` la agregará automáticamente). Al igual que con `site-name` en `init`, puede contener caminos simples o complejos.
	- **Ejemplos**:
		- `marksite add-page mi-sitio mi-curriculum`
		- `marksite add-page sitios/personal articulos/sobre-la-sociedad`
- `build-site`:
	- **Descripción**: Genera la versión HTML5 de nuestro sitio. Probablemente será este el comando que más utilicemos, puesto que cada vez que agreguemos un documento MarkDown nuevo, lo editemos, agreguemos nuevas imágenes, cambiemos las hojas de estilo o los scripts de JavaScript, será necesario regenerar el sitio. La estructura lista para publicar en un servidor web, o para usar localmente, puede ser encontrada entonces en el directorio `www/` de nuestro sitio.
	- **Parámetros**:
		- `site-name`: El nombre de nuestro sitio (tal cual lo escribimos en el momento de inicializarlo con `init`: "mi-sitio" o "sitios/personal")
	- **Ejemplos**:
		- `marksite build mi-sitio`
- `dump-template`:
	- **Descripción**: Escribe la plantilla HTML5 básica de **pandoc** como "mi-sitio/template.html". A partir de ese momento, al encontrarse `marksite` este archivo, comienza a utilizarlo, en lugar de la versión interna de **pandoc**, por lo que el método para definir una plantilla personalizada para nuestro sitio es ejecutar este comando, y luego editar la plantilla.
	- **Parámetros**:
		- `site-name`: El nombre de nuestro sitio (tal cual lo escribimos en el momento de inicializarlo con `init`: "mi-sitio" o "sitios/personal")
	- **Ejemplos**:
		- `marksite dump-template mi-sitio`

## Sobre el contenido de los archivos y la codificación de caracteres

Algo muy importante, es que todos los archivos deben estar codificados usando UTF-8. Aunque por sus características pudieran ser creados y editados sencillamente en el "Bloc de notas" de Windows, la carencia de soporte UTF-8 del mismo, lo invalida automáticamente. Casi cualquier otro editor de texto moderno, bastará. Personalmente recomiendo la versión mini de Notepad++ (o la versión completa).


## Ficheros y directorios que componen marksite

- `bin/`: Directorio: almacena todas las utilidades típicas de sistemas linux y unix necesarias para el funciomiento de `marksite`, así como **pandoc**. Esto garantiza que no sea necesario instalar ni configurar nada en el sistema, o sea, asegura la portabilidad de la herramienta.
- `marksite.sh`: script escrito en bash. Es el núcleo de la herramienta. En sistemas Windows, jamás lo ejecutaremos directamente.
- `marksite.cmd`: este es nuestro punto de entrada, y se encarga de recibir todos los comandos y parámetros que le pasemos, prepara el ambiente y luego ejecuta `marksite.sh`.
- `cmdhere.cmd`: la función de estre script es facilitar el trabajo con una consola: abrirla en el directorio indicado, preconfigurar algunos detalles, y recordarnos siempre que podemos ejecutar `marksite` sin parámetros para ver la ayuda rápida. Lo más cómodo en sistemas Windows es comenzar a trabajar haciendo simplemente doble click sobre este script.


## Estructura básica de un sitio

```
+--- mi-sitio/
|   |--- js-includes.md(*)
|   |--- menu.md(*)
|   |--- metadata.yml
|   +--- content/
|   |   +--- index.md
|   +--- static/
|   |   +--- css/
|   |       +--- styles.css
|   |   +--- images/
|   |   \--- js/
|   |       +--- my.js
|   \--- www/
```

**(*)**: _Son opcionales, aunque `js-includes.md` sí se crea con la estructura básica, no así `menu.md`._

#### Directorio `content/`

Es aquí donde se almacenan nuestros documentos en formato MarkDown, que luego serán convertidos a HTML5. Con la creación del sitio se incluye el archivo `index.md`, con el siguiente contenido:

```
---
pagetitle: index page title
keywords:
date: 2016.05.01

---

## index page

Lorem ipsum...

```

El primer bloque, limitado por `---` es información extra, "metainformación", y cada una de las llaves que aparecen representan el título que se mostrará en la barra de títulos del navegador web, algunas palabras clave, y la fecha de la última modificación respectivamente y son todas opcionales. El bloque no debe ser eliminado ni modificado, excepto por los valores de cada una de las llaves de configuración.

A partir de la segunda `---`, todo lo que aparece es el contenido del documento. Puede ser eliminado totalmente, el contenido que se incluye es solamente como facilidad. Se recomienda escribir el título del documento sustituyendo "index page" (o el título que aparezca cuando se cree una página nueva) y a partir de ahí desarrollar el resto del documento.

#### Directorio `static/`

Todo el contenido de este directorio será transferido tal cual, durante el paso de generación del sitio, al directorio `www` sin procesamiento extra de ninguna clase. Es el lugar adecuado para crear, por ejemplo, directorios donde se desee almacenar archivos para descargar, como comprimidos, PDFs, etc.

#### Directorio `www/`

Aquí se "publicará" el sitio, una vez procesado y generado. El contenido de este directorio es el que se debería copiar a un servidor donde esté publicado el sitio resultante.

#### Archivo `js-includes.md`

En este archivo se incluirán, uno en cada línea, los nombres de los scripts de JavaScript que utilizaremos en nuestro sitio (ej: `bootstrap.js`, `jquery.js`). En el momento de inicializar el sitio, solamente contiene una línea, apuntando a `js/my.js`. Este último, es un script vacío, que también se crea en el momento de la inicialización, listo ya para que comencemos a agregarle funcionalidad. Los scripts serán cargados en el mismo orden en que aparezcan, por lo que, si nuestro `my.js` utiliza funciones de `jquery.js`, el contenido de `js-includes.js` debería ser:

```
js/jquery.js
js/my.js
```

Todos los scripts de JavaScript deben ser copiados, por lo tanto, en `static/js/`.

#### Archivo `menu.md`

Este archivo se puede crear ejecutando `marksite init-menu nombre-sitio`, y no es más que un archivo MarkDown, que contendrá una lista, ordenada o desordenada (según el gusto personal), que será luego convertido por `marksite` a HTML5 e incluido como parte de cada uno de los archivos resultantes. Al momento de su creación sólo contendrá un enlace a la página principal del sitio (index.md):

```
- [Index](index.md)
```

#### Archivo `metadata.yml`

Este arhivo es uno de los más importantes. Almacena "metainformación" que afecta al sitio en general:

```
---
title-prefix:
title:
author:
highlight: pygments
css: css/styles.css
---
```

Al igual que con el bloque de "metainformación" de cada uno de nuestros documentos, no debe ser modificada su estructura, solamente los valores de cada llave, que son, en su mayoría, opcionales. Las llaves representan:

- `title-prefix`: El prefijo que se aplicará al título de cada página, antes de mostrarlo en la barra de títulos del navegador. Si por ejemplo, la llave `pagetitle` de un documento contiene "Currículum Vitae", y definiéramos el valor de esta llave como "Sitio personal de Pável Varela Rodríguez -", entonces, al entrar a la página correspondiente a dicho documento, el título de la ventana del navegador sería: "Sitio personal de Pável Varela Rodríguez - Currículum Vitae". Esta llave es opcional, de no definir su valor, en el ejemplo, el título de la página sería solamente el definido por `pagetitle`.
- `title`: Título principal del sitio, aparecerá como título principal, al principio de todas y cada una de las páginas. Generalmente, esta llave tendrá casi el mismo valor que `title-prefix`, a excepción del guión final.
- `author`: El valor de esta llave se agrega al principio de todas las páginas, así como en la sección de "metainformación" que utilizan luego los indizadores en internet.
- `highlight`: Esta llave es muy útil en caso de que en algunos documentos del sitio se incluya código fuente de programación. Esta opción define qué estilo de coloreado de sintaxis se utilizará. Para desactivar totalmente esta funcionalidad, se dejará sin valor, o con el valor especial `no`. Los posibles estilos de coloreado de sintaxis son: `pygments`, `kate`, `monochrome`, `espresso`, `zenburn`, `haddock`, y `tango`. De escribirse un valor diferente de los mencionados, **pandoc** lanzará un error durante la fase de conversión.
- `css`: La hoja de estilos a utilizar. Al igual que los scripts JavaScript, el camino debe ser escrito con respecto al directorio `static`. El valor por defecto hace referencia a un archivo de estilos vacía que se crea durante la inicialización de un sitio.


## Licencia

Todas las herramientas y utilidades con que se construyó `marksite` distribuidos como software libre (la mayoría con licencia GPL). `marksite` también se distribuye bajo licencia GPLv3+, por lo que puede ser estudiado, modificado, redistribuido con total libertad.

## Contacto

Pável Varela Rodríguez [neonskull@gmail.com](mailto:neonskull@gmail.com) o [pavelv@trdcaribe.co.cu](mailto:pavelv@trdcaribe.co.cu)

