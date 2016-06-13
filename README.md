# marksite.sh

There is a [spanish documentation](README.es.md) available.

_[pandoc](http://pandoc.org) + [MarkDown](http://daringfireball.net/projects/markdown) based static website generator written in bash_

MarkDown is a lightweight markup language, readable by humans in it's input form and capable to produce multiple ouput formats (HTML, RTF, etc.), trough a number of conversion tools.

One of these tools is pandoc, very advanced, with features for the conversion of simple MarkDown documents to HTML5, but also to generate books, thesis, articles with special formatting needs like those of scientific content.

`marksite` is a set of 3 scripts: the core functionality written in bash (linux, unix, ...) and 2 helper scripts, to prepare runtime with tools common in those operating systems (previuosly compiled to run on Windows), so it can be ran transparently, portable, and without any need to install absolutely nothing in Windows.

It's a command line tool, so, all interaction will be trough a console, but thanks to its operation simplicity there is no need to be scared, it is barely 1 command with just a little options, the minimum to keep a good balance between usability, power and flexibility.

# Usage (summary)

1.- On Windows: open `marksite's` working console by doing double click upon `cmdhere.cmd`; on Linux systems, open a terminal on `marksite's` directory
2.- Create a website
	```dos
    |> marksite init my-site
    ```
3. Create (if needed) and edit the main menu of your website (`my-site/menu.md`). In order to create it execute:
	```dos
    |> marksite init-menu my-site
    ```
4. Edit metadata (`my-site/metadata.yml`), JavaScript including scripts (`my-site/js-includes.md`), styles (`my-site/static/css/styles.css`), JavaScript (`my-site/static/js/my.js`) files that will be used in generation phase and affect the whole website
5. Edit MarkDown document `my-site/content/index.md`, homepage file
6. Create and edit MarkDown documents as pleased (our pages)
	```dos
    |> marksite add-page my-site my-page
    |> marksite add-page my-site directory/my-other-page
    ```
7. Generate (build) website
	```dos
    |> marksite build my-site
    ```
8. Repetir steps 4 to 7 as pleased

**Note**: All files, MarkDown and configuration, must be edited with an editor with UTF-8 support, like [Notepad++](http://notepad-plus-plus.org/). Windows' Notepado **doesn't supports UTF-8**.

## Usage

On Windows systems it's recommended to run `cmdhere.cmd` (ie: by doing double click upon it). This will open a windows' console ready to receive commands. It also shows a little tip, reminding us we can run `marksite` with no parameters which will make it to show a quick help, a list of possible parameters and some usage examples.

`marksite` works by commands and parameters for them. `marksite's` are:

- `init`
	- **Description**: Creates the basic structure for a new 'website' (a directory), including directories for Cascading Style Sheets (`.css` files), JavaScript (`.js` files), a directory for images, a directory for the content, and some configuration files also.
	- **Parameters**:
		- `site-name`: The name of our website, no spaces. Could be some as simple as "my-site" or a little more complex, including subdirectories: "sites/personal" (in this case a directory named "sites" will be created then, a directory name "personal" inside it)
	- **Examples**:
		- `marksite init my-site`
		- `marksite init sites/personal`
- `init-menu`:
	- **Description**: Creates a filed named "menu.md" inside a website's directory
	- **Parameters**:
		- `site-name`: The name of the site (as we wrote it at initialization time with the `init` command, ie: "my-site" or "sites/personal")
	- **Examples**:
		- `marksite init-menu my-site`
		- `marksite init-menu sites/personal`
- `add-page`:
	- **Description**: Creates a new document inside the "content" directory of a website
	- **Parameters**:
		- `site-name`: Website's name
		- `page-name`: Name of the file to be created (no .md extension, `marksite` will append it for us). As with `site-name` in the `init` command, it can contain simple or complex paths.
	- **Examples**:
		- `marksite add-page my-site my-resume`
		- `marksite add-page sites/personal articles/about-society`
- `build-site`:
	- **Description**: Generates the HTML5 version of our website. This might be the most used command, since we will run it every time we add a new MarkDown document, modify it, add new images, modify stylesheets or javascript files. The ready-for-publish estructure (either locally or using a web server), can be found inside the 'www/' directory of our website.
	- **Parameters**:
		- `site-name`: Website's name
	- **Examples**:
		- `marksite build my-site`
- `dump-template`:
	- **Description**: Writes **pandoc's** basic HTML5 template as "site-name/template.html". From that moment, since `marksite` could find this file, it is used as website's template, instead of **pandoc's** internal template, so, the method to create a custom template would be to run this command and then modify the template.
	- **Parameters**:
		- `site-name`: Website's name
	- **Examples**:
		- `marksite dump-template my-site`


## Files content and character enconding

Something very important is that every file must be enconded using UTF-8. Although they might be created and edited simply with Windows' Notepad, the lack of UTF-8 support make it a non-feasible option. Almost any other modern text editor should be more than enough. Personally I recommend the mini version of Notepad++ (or the full version).


## Files and directories of marksite

- `bin/`: Directory: stores the needed linux/unix, **pandoc** and **node.js** (needed for lessc). This guarantees `marksite` runs on Windows systems absolutely portable and without installing anything.
- `marksite.sh`: bash script. It is the core tool. On Windows systems it won't be executed directly.
- `marksite.cmd`: this is the entry point on Windows, since it makes some environment preparations and runs `marksite.sh` with the parameters we've passed.
- `cmdhere.cmd`: this is a helper script. It's job is to load a console, ready to start working with `marksite`. On Windows, this should be your first option in order to start working comfortable.


## Basic structure of a website

```
+--- my-site/
|   |--- footer.md(*)
|   |--- header.md(*)
|   |--- js-includes.md(*)
|   |--- menu.md(*)
|   |--- metadata.yml
|   |--- template.html(*)
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

**(*)**: _Optionals, though `js-includes.md` is created with the initial structure, the rest of the files are not._


#### Directory `content/`

Is in this directory where all our MarkDown documents are stored, which then will be converted to HTML5. With the creation of the website the file `index.md` is included with the following content:

```
---
pagetitle: index page title
keywords:
date: 2016.05.01

---

## index page

Lorem ipsum...

```

The first block, delimited by `---` is extra information, metadata and each key represents the title that will be shown in the title bar of the web browser, some keywords and the date of the last modification and are all optional. This block should not be deleted or modified, except for the values of each key.

From the second `---` everything is the actual content of the document. May be deleted, all the content included in the creation of the document is just a comodity. It's recommended to write the title of the document by replacing "index page" (or the title `marksite` gives to the document on creation) and then continue to write the rest of your content.

#### Directory `static/`

The whole content of this directory will be copied as it is, no modification or convertion, to the directory `www/`, without any further processing. This is the right place to store downloading files, PDFs, compressed files, etc.

#### Directory `www/`

The website will be "published" to this directory, after being processed and generated. THe content of this directory is the one to publish on a web server.

#### Files `footer.md` and `header.md`

If one of them is present, or both, they will be processed, converted to HTML5 and then included at the beginning and the end, respectivaly, of the body of each page of the website.

#### File `js-includes.md`

In this files you should put, one by line, the names of the JavaScript files you will be using (ie: `bootstrap.js`, `jquery.js`). On website's creation there is only one line in this file: `js/my.js`. This last file (`js/my.js`) is an empty script, also created on website initialization, ready for us to start adding code. The scripts will be loaded in the exacto order the are, so, if our `my.js` uses some function from `jquery.js`, the content of `js-includes.js` should be:

```
js/jquery.js
js/my.js
```

Thus, every JavaScript file must be copied inside `static/js/`.

#### File `menu.md`

This file could be created by running `marksite init-menu site-name`. It is just a MarkDown file, containing a list, ordered or unordered (it's a matter of personal taste), that will be then converted to HTML5 and included in each file. At creation time it just contains a single link to the homepage of the website (index.md):

```
- [Index](index.md)
```

#### File `template.html`

`marksite` uses **pandoc's** default HTML5 template but allows to define a custom one. To get the original template will be enough to run:

```
marksite dump-template site-name
```

Once you did it, you can proceed to modify it as toy please, always trying to keep the variables defined on it.

#### File `metadata.yml`

This is one of the most important files. Stores metadata affecting the whole website:

```
---
title-prefix:
title:
author:
highlight: pygments
stylesheet: css/styles.css
---
```

Just like the metadata block on each document, shouldn't be modified, only the values of each key, which are mostly optional. The keys represent:

- `title-prefix`: The prefix to be applied to the title of every page before being displayed on the title bar of the web browser. For example, if the key `pagetitle` of a document is defined with a value "Curriculum Vitae", and then we define `title-prefix` as "Pável's personal website -", once the page is loaded in web browser, the title bar will show: "Pável's personal website - Curriculum Vitae". This key is optional, so, if you do not define a value, in our example, the title bar will show only the value defined in `pagetitle`.
- `title`: Website's main title. The most common value for this key is the same as `title-prefix`, except for the last dash.
- `author`: The value of this key is added to the metadata section of each page.
- `highlight`: A really useful key if we have some source code on our pages. This option defines what syntax highlighting style to use. To fully disable this feature leave it with no value or the special value `no`. Available styles are: `pygments`, `kate`, `monochrome`, `espresso`, `zenburn`, `haddock`, y `tango`. In case of writing a value different from the mentioned **pandoc** will raise an error on the conversion phase.
- `stylesheet`: Stylesheet to be used. Like with JavaScript files, the path is relative to the `static` directory. Default value references the empty stylesheet created on website's initialization. Could be a CSS file or a LESS file. If it's a LESS file,  `marksite` will compile it using `lessc`, generating then a file with the same name but .css extension on the same directory.

## License

All the tools and utilities upon `marksite` is build are distributed as free software (mostly GPL). `marksite` is also distributed under the GPLv3+ license, so it may be studied, modified and redistributed in total freedom.

## Contact

Pável Varela Rodríguez [neonskull@gmail.com](mailto:neonskull@gmail.com)

