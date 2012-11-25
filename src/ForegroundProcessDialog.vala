// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/*-
 * Copyright (c) 2012 droppy Developers
 * (http://dev.elhan.org/projects/droppy)
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

using Vte;

namespace Droppy {

    public class ForegroundProcessDialog : Gtk.MessageDialog {

        public ForegroundProcessDialog () {
            use_markup = true;
            set_markup ("<b>" + _("Are you sure you want to close this tab?") + "</b>\n\n" +
                      _("There is an active process on this tab.")+"\n"+
                      _("If you close this tab, this process will end."));

            var button = new Gtk.Button.with_label (_("Cancel"));
            button.show ();
            add_action_widget (button, 0);

            button = new Gtk.Button.with_label (_("Close Tab"));
            button.show ();
            add_action_widget (button, 1);

            var warning_image = new Gtk.Image.from_stock (Gtk.Stock.DIALOG_WARNING,
                                                          Gtk.IconSize.DIALOG);
            set_image (warning_image);
            warning_image.show ();
        }

        public ForegroundProcessDialog.before_close () {
            use_markup = true;
            set_markup ("<b>" + _("Are you sure you want to quit Terminal?") + "</b>\n\n" +
                      _("There is an active process on this terminal.")+"\n"+
                      _("If you quit Terminal, this process will end."));

            var button = new Gtk.Button.with_label (_("Cancel"));
            button.show ();
            add_action_widget (button, 0);

            button = new Gtk.Button.with_label (_("Quit Terminal"));
            button.show ();
            add_action_widget (button, 1);

            var warning_image = new Gtk.Image.from_stock (Gtk.Stock.DIALOG_WARNING,
                                                          Gtk.IconSize.DIALOG);
            set_image (warning_image);
            warning_image.show ();
        }
    }
}
