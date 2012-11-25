// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2012 droppy Developers
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 *
 * Authored by: Osman Alperen Elhan <alperen@elhan.org>
 *              Ahmet Yasin Uslu <nepjua@gmail.com>
 */

namespace Droppy {

    public SavedState saved_state;
    public Settings settings;

    public enum DroppyWindowState {
        NORMAL = 0,
        MAXIMIZED = 1,
        FULLSCREEN = 2
    }

    public class SavedState : Granite.Services.Settings {

        public int window_width { get; set; }
        public int window_height { get; set; }
        public DroppyWindowState window_state { get; set; }
        public string tabs { get; set; }
        public int opening_x { get; set; }
        public int opening_y { get; set; }

        public SavedState () {
            base ("org.elementary.droppy.SavedState");
        }
    }

    public class Settings : Granite.Services.Settings {

        public int scrollback_lines { get; set; }
        public bool follow_last_tab { get; set; }
        public bool remember_tabs { get; set; }
        public bool alt_changes_tab { get; set; }

        public int opacity {get; set; }
        public string foreground { get; set; }
        public string background { get; set; }
        public string cursor_color { get; set; }
        public string palette { get; set; }

        public string shell { get; set; }
        public string encoding { get; set; }
        public string font {get; set;}

        public Settings ()  {
            base ("org.elementary.droppy.Settings");
        }
    }
}