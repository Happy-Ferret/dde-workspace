/**
 * Copyright (c) 2011 ~ 2012 Deepin, Inc.
 *               2011 ~ 2012 snyh
 *
 * Author:      snyh <snyh@snyh.org>
 * Maintainer:  snyh <snyh@snyh.org>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, see <http://www.gnu.org/licenses/>.
 **/
#include "xdg_misc.h"
#include <gtk/gtk.h>
#include "dwebview.h"
#include "i18n.h"
#include "utils.h"

gboolean clear_bg(GtkWidget* w, cairo_t* cr)
{
    cairo_set_operator(cr, CAIRO_OPERATOR_CLEAR);
    cairo_paint(cr);
    return FALSE;
}
int main(int argc, char* argv[])
{
    init_i18n();
    gtk_init(&argc, &argv);
    GtkWidget* container = create_web_container(TRUE, TRUE);
    gtk_window_set_wmclass(GTK_WINDOW(container), "dde-launcher", "DDELauncher");

    set_default_theme("Deepin");
    set_desktop_env_name("GNOME");


    GtkWidget *webview = d_webview_new_with_uri(GET_HTML_PATH("dominant_color"));

    gtk_container_add(GTK_CONTAINER(container), GTK_WIDGET(webview));

    g_signal_connect (container , "destroy", G_CALLBACK (gtk_main_quit), NULL);
    g_signal_connect(webview, "draw", G_CALLBACK(clear_bg), NULL);

    monitor_resource_file("dominant_color", webview);

    gtk_widget_show_all(container);
    gtk_main();
    return 0;
}
