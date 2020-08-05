#ifndef __LABWC_RCXML_H
#define __LABWC_RCXML_H

#include <stdio.h>
#include <stdbool.h>
#include <wayland-server-core.h>

#include "common/buf.h"

struct rcxml {
	bool client_side_decorations;
	char *theme_name;
	char *font_name_activewindow;
	int font_size_activewindow;
	struct wl_list keybinds;
	int title_height; /* not set in rc.xml, but derived from font, etc */
};

extern struct rcxml rc;

void rcxml_parse_xml(struct buf *b);
void rcxml_read(const char *filename);
void rcxml_get_nodenames(struct buf *b);

#endif /* __LABWC_RCXML_H */
