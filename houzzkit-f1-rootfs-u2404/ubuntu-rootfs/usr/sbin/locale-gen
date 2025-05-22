#!/bin/bash

set -e

LOCALEGEN=/etc/locale.gen
LOCALES=/usr/share/i18n/locales
USER_LOCALES=/usr/local/share/i18n/locales
SUPPORTED=/var/lib/locales/supported.d
ALIASES=/usr/share/locale/locale.alias


[ -s "$LOCALEGEN" ] || exit 0

KEEP=0
IS_LANG=no
ARCHIVE=yes

#  Handle command-line options
prev=
while true
do
	option="$1"
	if [ -n "$prev" ]; then
                eval "$prev=\$option"
                prev=
                continue
	fi

	case $option in
	-h|--help)
		cat <<EOT
Usage: locale-gen [OPTIONS]
Options:
 -h, --help         display this message and exit
     --purge        remove existing locales before processing
     --archive      store compiled locale data inside a single archive
     --no-archive   do not store compiled locale data inside a single archive
                    (default)
     --aliases=FILE read locale aliases from FILE. (Default: /etc/locale.alias)
     --lang         treat argument as generic language code
EOT
		exit 0
		;;
	--purge)
		# This is the default when called without arguments
		;;
	--no-purge)
		KEEP=1
		;;
	--archive)
		ARCHIVE=yes
		;;
	--no-archive)
		ARCHIVE=no
		;;
	--keep-existing)
		KEEP=1
		;;
	--aliases)
		prev=ALIASES
		;;
	--aliases=*)
		ALIASES=$(expr "x$option" : 'x[^=]*=\(.*\)')
		;;
	--lang)
		IS_LANG=yes
		;;
	--*)
		echo "locale-gen: invalid option -- $option"
		echo "Try 'locale-gen --help' for more information."
		exit 1
		;;
	*)
		break
		;;
	esac

	shift
done

no_archive=
[ "$ARCHIVE" = yes ] || no_archive="--no-archive"
locale_alias=
[ -n "$ALIASES" ] && [ -r "$ALIASES" ] && locale_alias="-A $ALIASES"

if [ -z "$1" ] && [ "$KEEP" -eq 0 ]; then
	# Remove all old locale dir and locale-archive before generating new
	# locale data.
	rm -rf /usr/lib/locale/locale-archive || true
	for dir in /usr/lib/locale/*; do
		[ -e "$dir" ] || continue
		if [ "${dir#/usr/lib/locale/}" = C.utf8 ]; then
			# owned by libc-bin
			continue
		fi
		rm -rf "$dir" 2>/dev/null || true
	done
fi

umask 022

is_entry_ok() {
	if [ -z "$locale" ] || [ -z "$charset" ]; then
		echo "error: Bad entry '$locale $charset'"
		return 1
	fi
}

add_to_locale_gen() {
  echo "$1" | while read locale; do
    if ! grep -q "^[# ]*$locale *\$" $LOCALEGEN; then
      echo "# $locale" >> $LOCALEGEN
    fi
    sed -i -e "0,/^[# ]*$locale *$/ s/^[# ]*$locale *$/$locale/" $LOCALEGEN
  done
}

if [ -z "$1" ]; then
  GENERATE="`cat $SUPPORTED/* $LOCALEGEN 2>/dev/null || true`"
else
  GENERATE=
  while [ -n "$1" ]; do
    if [ -f "$SUPPORTED/$1" ]; then
      GENERATE="$GENERATE\n`cat $SUPPORTED/$1`"
    elif [ $IS_LANG = no ] && L=`grep "^${1/%.utf8/.UTF-8} " /usr/share/i18n/SUPPORTED`; then
      # convert utf8 to UTF-8 and check if the requested locale exists
      GENERATE="$GENERATE\n$L"
      add_to_locale_gen "$L"
    elif [ $IS_LANG = no ] && L=`grep "^${1%.[uU][tT][fF]*} UTF-8" /usr/share/i18n/SUPPORTED`; then
      # recognize 'll_CC.UTF-8' or 'll_CC.utf8' as ll_CC without codeset
      GENERATE="$GENERATE\n$L"
      add_to_locale_gen "$L"
    else
      # try to come up with a sensible default
      L=`grep -E "^${1}( |[._@][^[:space:]]* )UTF-8" /usr/share/i18n/SUPPORTED || true`
      if [ -z "$L" ]; then
        echo "Error: '$1' is not a supported language or locale" >&2
        exit 1
      fi
      GENERATE="$GENERATE\n$L"
      add_to_locale_gen "$L"
    fi
    shift
  done
fi

echo "Generating locales (this might take a while)..."
echo -e "$GENERATE" | sort -u | while read -r locale charset; do \
	if [ -z "$locale" ] || [ "${locale#\#}" != "$locale" ]; then continue; fi
	is_entry_ok || continue

	if [ "$KEEP" -eq 1 ] && PERL_BADLANG=0 perl -MPOSIX -e 'exit 1 unless setlocale(LC_ALL, $ARGV[0])' "$locale"; then continue; fi

	locale_base="${locale%%.*}"
	locale_base="${locale_base%%@*}"
	locale_at="${locale#*@}"
	[ "$locale_at" = "$locale" ] && locale_at= || locale_at="@$locale_at"
	printf "  %s.%s%s..." "$locale_base" "$charset" "$locale_at"

	if [ -e "$USER_LOCALES/$locale" ]; then
		input="$USER_LOCALES/$locale"
	elif [ -e "$LOCALES/$locale" ]; then
		input="$locale"
	else
		input="$locale_base$locale_at"
		if [ -e "$USER_LOCALES/$input" ]; then
			input="$USER_LOCALES/$input"
		fi
	fi
	localedef $no_archive -i $input -c -f $charset $locale_alias $locale || :; \
	echo " done"
done
echo "Generation complete."
