#!/bin/sh

# If ibus-mozc is removed but not purged, keep hands off :-)
dpkg-query -l ibus-mozc 2>/dev/null | grep -q ^ii || exit 0

# If non-ibus IM framework is set-up (by im-config etc.), keep hands off :-)
env | grep -E '^(XMODIFIERS|GTK_IM_MODULE|QT_IM_MODULE|CLUTTER_IM_MODULE)=' | grep -q ibus || exit 0

mkdir -p ${XDG_DATA_HOME:-~/.local/share}
exec >> ${XDG_DATA_HOME:-~/.local/share}/ibus-mozc-gnome-initial-setup.log 2>&1

key=/org/gnome/desktop/input-sources/sources

# Try to read the current value
for i in $(seq 30); do
	value=$(dconf read $key)
	[ x != x"$value" ] && break; sleep 1
done
[ x != x"$value" ] || { echo "E: dconf read failed"; exit 1; }

# Try to write the new value
(
	# If some ibus input method is already used, keep hands off :-)
	echo "$value" | grep -F "('ibus', " && { echo "I: GNOME ibus already set-up. Doing nothing. Current: $value"; exit 0; }

	echo "I: Current: $value"

	value="[('ibus', 'mozc-jp'), ${value#[}"
	dconf write $key "$value" || { echo "E: dconf write failed. New: $value"; exit 1; }
	echo "I: Done. New: $value"
) && touch ${XDG_CONFIG_HOME:-~/.config}/ibus-mozc-gnome-initial-setup-done
