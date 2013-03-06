#include "region.h"

cairo_region_t* _region = NULL;
GdkWindow* _win = NULL;
cairo_rectangle_int_t _base_rect;

cairo_region_t* _saved_region = NULL;

void dock_region_save()
{
    g_assert(_win != NULL);
    _saved_region = gdk_window_get_visible_region(_win);
}
void dock_region_restore()
{
    g_assert(_saved_region != NULL);
    gdk_window_shape_combine_region(_win, _saved_region, 0, 0);
}

void init_region(GdkWindow* win, double x, double y, double width, double height)
{
    if (_win == NULL) {
        _win = win;
        _region = cairo_region_create();
        _base_rect.x = x;
        _base_rect.y = y;
        _base_rect.width = width;
        _base_rect.height = height;
        dock_require_region(0, 0, width, height);
    } else {
        _win = NULL;
        cairo_region_destroy(_region);
        init_region(win, x, y, width, height);
        /*g_assert_not_reached();*/
    }
}


void dock_force_set_region(double x, double y, double width, double height)
{
    cairo_region_destroy(_region);
    cairo_rectangle_int_t tmp = {(int)x + _base_rect.x, (int)y + _base_rect.y, (int)width, (int)height};
    _region = cairo_region_create_rectangle(&tmp);
    cairo_rectangle_int_t dock_board_rect = _base_rect;
    dock_board_rect.y += 30;
    dock_board_rect.height = 30;
    cairo_region_union_rectangle(_region, &dock_board_rect);
    gdk_window_shape_combine_region(_win, _region, 0, 0);
}

void dock_require_region(double x, double y, double width, double height)
{
    cairo_rectangle_int_t tmp = {(int)x + _base_rect.x, (int)y + _base_rect.y, (int)width, (int)height};
    cairo_region_union_rectangle(_region, &tmp);
    gdk_window_shape_combine_region(_win, _region, 0, 0);
}
void dock_release_region(double x, double y, double width, double height)
{
    cairo_rectangle_int_t tmp = {(int)x + _base_rect.x, (int)y + _base_rect.y, (int)width, (int)height};
    cairo_region_subtract_rectangle(_region, &tmp);
    gdk_window_shape_combine_region(_win, _region, 0, 0);
}
void dock_set_region_origin(double x, double y)
{
    _base_rect.x = x;
    _base_rect.y = y;
}
