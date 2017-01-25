#!/bin/sh
activeWinLine=$(xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)")
activeWinId=${activeWinLine:40}
import -window "$activeWinId" ~/`date +%Y-%m-%d_%H.%M.%S`_window_screenshot.png
