#!/bin/bash

VERSION=0.2

dump-template ()
{
	if [ ! $# -eq 1 ]; then echo "Usage: dump-template site-name";return;fi

	# fixing \ in path (for Windows console's autocompletion)
	SITE=$(echo $1 | tr "\\\\" "/")

	TEMPLATE=$SITE/template.html
	if [ ! -f "$TEMPLATE" ]; then
		echo Dumping default template to: $SITE
		pandoc -D html5 > "$TEMPLATE"
	else
		echo Template file already there...Doing nothing.
	fi
}

add-page ()
{
	if [ ! $# -eq 2 ];then echo "Usage: add-page site-name page-name";return;fi

	# fixing \ in path (for Windows console's autocompletion)
	SITE=$(echo $1 | tr "\\\\" "/")
	PAGE_NAME=$(echo $2 | tr "\\\\" "/")

	PAGE=$SITE/content/$PAGE_NAME.md
	if [ ! -f "$PAGE" ]; then
		echo Creating new page: $PAGE_NAME
		mkdir -p "$(dirname "$PAGE")"
		BASENAME=$(basename "$PAGE_NAME")
		CONTENT="---\r\n"
		CONTENT=$CONTENT"pagetitle: "$BASENAME" page title\r\n"
		CONTENT=$CONTENT"keywords:\r\n"
		CONTENT=$CONTENT"---\r\n\r\n"
		CONTENT=$CONTENT"## "$BASENAME" page\r\n\r\n"
		CONTENT=$CONTENT"Lorem ipsum...\r\n"
		echo -ne $CONTENT > "$PAGE"
	else
		echo Page "$PAGE_NAME" already exists...Doing nothing.
	fi
}

init-menu ()
{
	if [ ! $# -eq 1 ];then echo "Usage: init-menu site-name";return;fi

	# fixing \ in path (for Windows console's autocompletion)
	SITE=$(echo $1 | tr "\\\\" "/")

	if [ ! -f "$SITE/menu.md" ]; then
		echo Adding main menu to: $1
		echo "- [Index](index.md)" > "$SITE/menu.md"
	else
		echo Main menu file already there...Doing nothing.
	fi
}

init ()
{
	if [ ! $# -eq 1 ];then echo "Usage: init site-name";return;fi

	# fixing \ in path (for Windows console's autocompletion)
	SITE=$(echo $1 | tr "\\\\" "/")

	echo Creating new site: $SITE

	mkdir -p "$SITE/"{content,static/{css,js,images},www}

	if [ ! -f "$SITE/metadata.yml" ]; then
		METADATA="---\r\n"
		METADATA=$METADATA"title-prefix:\r\n"
		METADATA=$METADATA"title:\r\n"
		METADATA=$METADATA"author:\r\n"
		METADATA=$METADATA"highlight: pygments\r\n"
		METADATA=$METADATA"stylesheet: css/styles.css\r\n"
		METADATA=$METADATA"---\r\n"
		echo -ne $METADATA > "$SITE/metadata.yml"
	fi

	CSS_FILE=$SITE/static/css/styles.css
	test ! -f "$CSS_FILE" && echo -ne "/* your style rules here */\r\n" > "$CSS_FILE"

	JS_FILE=$SITE/static/js/my.js
	test ! -f "$JS_FILE" && echo -ne "/* your js code here */\r\n" > "$JS_FILE"

	JS_INCLUDES=$SITE/js-includes.md
	test ! -f "$JS_INCLUDES" && echo -ne "js/my.js" > "$JS_INCLUDES"

	add-page $SITE index
}

build ()
{
	if [ ! $# -eq 1 ];then echo "Usage: build-site site-name";return;fi

	# fixing \ in path (for Windows console's autocompletion)
	SITE=$(echo $1 | tr "\\\\" "/")

	echo -n "Building site: $SITE ... "

	cp -ru "$SITE/static/"* "$SITE/www"

	CSS_FILE="css/styles.css"
	HIGHLIGHT=
	if [ -f "$SITE/metadata.yml" ]; then
		METADATA="$SITE/metadata.yml"

		HIGHLIGHT_STYLE=$(grep "highlight" "$METADATA"| sed -r "s/(\ |highlight:)//g")
		test -z "$HIGHLIGHT_STYLE" -o "$HIGHLIGHT_STYLE" = "no" \
			&& HIGHLIGHT="--no-highlight" \
			|| HIGHLIGHT="--highlight-style="$HIGHLIGHT_STYLE

		STYLESHEET=$(grep "stylesheet" "$METADATA"| sed -r "s/(\ |stylesheet:)//g")
		test -n "$STYLESHEET" && CSS_FILE=$STYLESHEET
		STYLESHEET_IS_LESS="no"
		test -n "$(echo $STYLESHEET | grep -Ei ".*\.less$")" \
			&& STYLESHEET_IS_LESS="yes" \
			&& CSS_FILE="${CSS_FILE%.less}.css"
	fi

	test -f "$SITE/menu.md" && MENU="-V toc=\"{{MENU}}\"" || MENU=
	test -f "$SITE/header.md" && HEADER="-A $SITE/.header.html" || HEADER=
	test -f "$SITE/footer.md" && FOOTER="-A $SITE/.footer.html" || FOOTER=
	test -f "$SITE/template.html" && TEMPLATE="--template=$SITE/template.html" || TEMPLATE=

	test -f "$SITE/js-includes.md" && JS_INCLUDES="yes" || JS_INCLUDES="no"

	PARAMS="-s -f markdown+yaml_metadata_block -t html5"

	if [ $STYLESHEET_IS_LESS = "yes" ];then
		less_file=$SITE/www/$STYLESHEET
		css_file=${less_file%.less}.css
		# if css file doesn't exists, creating it with a modification date of
		# 1 year ago, so, it doesn't matches less file modification date
		# this fixes: css file not getting build the first time site builts
		test ! -f "$css_file" && touch -d "1 year ago" "$css_file"
		if [ ! "$(date +%s -r "$css_file")" = "$(date +%s -r "$less_file")" ];then
			node bin/lessc/bin/lessc "$less_file" "$css_file"
			touch -c -m -r "$less_file" "$css_file"
		fi
	fi

	FILES=
	DIRS=
	for _file in $(find "$SITE/content" -type f -iname "*.md");do
		# Windows' version of find returns some \ in path, fixing it
		_file=$(echo $_file | tr "\\\\" "/")
		FILES=$FILES$_file"\n"
		DIRS=$DIRS"$(dirname $_file)\n"
	done
	
	# TODO: include metadata.yml in the checks for FORCE_REBUILD
	# complex tests not working, so, doing it step by step
	FORCE_REBUILD="no"
	if [ -n "$MENU" ];then
		if [ ! -f "$SITE/.menu.html" ];then
			FORCE_REBUILD="yes"
		elif [ ! "$(date +%s -r "$SITE/.menu.html")" = "$(date +%s -r "$SITE/menu.md")" ];then
			FORCE_REBUILD="yes"
		fi
	fi
	if [ -n "$HEADER" ];then
		if [ ! -f "$SITE/.header.html" ];then
			FORCE_REBUILD="yes"
		elif [ ! "$(date +%s -r "$SITE/.header.html")" = "$(date +%s -r "$SITE/header.md")" ];then
			FORCE_REBUILD="yes"
		fi
	fi
	if [ -n "$FOOTER" ];then
		if [ ! -f "$SITE/.footer.html" ];then
			FORCE_REBUILD="yes"
		elif [ ! "$(date +%s -r "$SITE/.footer.html")" = "$(date +%s -r "$SITE/footer.md")" ];then
			FORCE_REBUILD="yes"
		fi
	fi
	if [ "$JS_INCLUDES" = "yes" ];then
		if [ ! -f "$SITE/.js-includes.html" ];then
			FORCE_REBUILD="yes"
		elif [ ! "$(date +%s -r "$SITE/.js-includes.html")" = "$(date +%s -r "$SITE/js-includes.md")" ];then
			FORCE_REBUILD="yes"
		fi
	fi

	for _dir in $(echo -ne $DIRS | uniq); do
		_out_dir=$SITE/www${_dir#"$SITE/content"}
		test ! -d "$_out_dir" && mkdir -p "$_out_dir"

		_prefix=$(echo ${_out_dir#"$SITE/www"} | sed -e "s/[^\/]//g" -e "s/\//\.\.\//g")

		# TODO: try to delay menu and js-includes regeneration unless it's
		# actually needed (any file in $_dir will be (re)generated)
		href_sed_script="s/(href=\\\")([a-zA-Z0-9_\\\-\\\.\\\/\\\?]+\\\")/\1"$(echo $_prefix | sed -e "s/\//\\\\\//g" -e "s/\./\\\\./g")"\2/g"

		# preparing main menu for $_dir
		if [ -n "$MENU" ]; then
			pandoc -f markdown -t html5 "$SITE/menu.md" | sed -r "$href_sed_script" > "$SITE/.menu.html"
			touch -c -m -r "$SITE/menu.md" "$SITE/.menu.html"
		fi

		# preparing header for $_dir
		if [ -n "$HEADER" ]; then
			pandoc -f markdown -t html5 "$SITE/header.md" | sed -r "$href_sed_script" > "$SITE/.header.html"
			touch -c -m -r "$SITE/header.md" "$SITE/.header.html"
		fi

		# preparing footer for $_dir
		if [ -n "$FOOTER" ]; then
			pandoc -f markdown -t html5 "$SITE/footer.md" | sed -r "$href_sed_script" > "$SITE/.footer.html"
			touch -c -m -r "$SITE/footer.md" "$SITE/.footer.html"
		fi

		# preparing scripts block for $_dir
		JS_INCLUDES_PARAM=
		if [ "$JS_INCLUDES" = "yes" ]; then
			JS=
			for js_file in $(grep ".js" "$SITE/js-includes.md"); do
				JS=$JS"<script type=\"text/javascript\" src=\"$_prefix$js_file\"></script>\n"
			done
			echo -ne $JS > "$SITE/.js-includes.html"
			touch -c -m -r "$SITE/js-includes.md" "$SITE/.js-includes.html"
			JS_INCLUDES_PARAM="-A $SITE/.js-includes.html"
		fi

		# processing files inside $_dir
		for md_file in $(echo -e $FILES);do
			if [ "$(dirname $md_file)" = "$_dir" ]; then
				html_file=$_out_dir/$(basename "${md_file%.md}.html")

				if [ "$FORCE_REBUILD" = "yes" ];then
					REBUILD_FILE="yes"
				elif [ ! -f "$html_file" ];then
					REBUILD_FILE="yes"
				elif [ ! "$(date +%s -r "$html_file")" = "$(date +%s -r "$md_file")" ];then
					REBUILD_FILE="yes"
				else
					REBUILD_FILE="no"
				fi

				if [ "$REBUILD_FILE" = "yes" ];then
					# echo $html_file
					pandoc $PARAMS -c $_prefix$CSS_FILE $MENU \
						-V date="$(date +%Y-%m-%d -r "$md_file")" \
						$HEADER $HIGHLIGHT $TEMPLATE $FOOTER $JS_INCLUDES_PARAM \
						"$md_file" "$METADATA" |\
							sed -e "/{{MENU}}/r $SITE/.menu.html" -e '//d' |\
							sed -r "s/\.md\"/\.html\"/g" > "$html_file"
					touch -c -m -r "$md_file" "$html_file"
				fi
			fi
		done
	done

	echo "done"
}

help ()
{
	echo "$(basename $0 .sh) v$VERSION, gpl-v3+"
	echo "Static HTML5 website generator"
	echo "Uses MarkDown documents as input and pandoc as engine"
	echo ""
	echo "Usage: $(basename $0 .sh) [<command>] [<param1, ...>]"
	echo ""
	echo "Commands:"
	echo "[help]                              Shows this help message en exit"
	echo "init <site-name>                    Creates new site with given site-name"
	echo "init-menu <site-name>               Creates menu.md into site-name"
	echo "add-page <site-name> <page-name>    Creates new page into site-name"
	echo "build <site-name>                   Renders HTML version of site-name"
	echo "dump-template <site-name>           Dumps default HTML5 template into site-name"
	echo ""
	echo "Examples:"
	echo ""
	echo "- Initialize directory my-code-samples with the basic site structure:"
	echo "$ marksite init my-code-samples"
	echo ""
	echo "- Create downloads.md inside my-code-samples:"
	echo "$ marksite add-page my-code-samples downloads"
	echo ""
	echo "- Create csharp.md inside subdirectory:"
	echo "$ marksite add-page my-code-samples languages/csharp"
	echo ""
	echo "- Render HTML5 version of your my-code-samples' site:"
	echo "$ marksite build my-code-samples"
}

test $# -eq 0 && help || $@
