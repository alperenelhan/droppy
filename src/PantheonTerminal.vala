// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
  BEGIN LICENSE

  Copyright (C) 2011-2012 Mario Guerriero <mefrio.g@gmail.com>
  This program is free software: you can redistribute it and/or modify it
  under the terms of the GNU Lesser General Public License version 3, as published
  by the Free Software Foundation.

  This program is distributed in the hope that it will be useful, but
  WITHOUT ANY WARRANTY; without even the implied warranties of
  MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
  PURPOSE.  See the GNU General Public License for more details.

  You should have received a copy of the GNU General Public License along
  with this program.  If not, see <http://www.gnu.org/licenses/>

  END LICENSE
***/

using Gtk;

using Granite;
using Granite.Services;

using PantheonTerminal;

namespace PantheonTerminal {

    public class PantheonTerminalApp : Granite.Application {

            public GLib.List <PantheonTerminalWindow> windows;

            static string app_cmd_name;

            construct {

                program_name = app_cmd_name;
                exec_name = app_cmd_name.down();
                app_years = "2011-2012";
                app_icon = "utilities-terminal";
                app_launcher = "pantheon-terminal.desktop";
                application_id = "net.launchpad.pantheon-terminal";
                main_url = "https://launchpad.net/pantheon-terminal";
                bug_url = "https://bugs.launchpad.net/pantheon-terminal";
                help_url = "https://answers.launchpad.net/pantheon-terminal";
                translate_url = "https://translations.launchpad.net/pantheon-terminal";
                about_authors = { "David Gomes <davidrafagomes@gmail.com>", "Mario Guerriero <mefrio.g@gmail.com>" };
                //about_documenters = {"",""};
                about_artists = { "Daniel Foré <daniel@elementaryos.org>" };
                about_translators = "Launchpad Translators";
                about_license_type = License.GPL_3_0;

            }

        public PantheonTerminalApp () {

            Logger.initialize ("PantheonTerminal");
            Logger.DisplayLevel = LogLevel.DEBUG;

            windows = new GLib.List <PantheonTerminalWindow> ();

            saved_state = new SavedState ();
            settings = new Settings ();
        }

        protected override void activate () {
            new_window ();
        }

        public void new_window () {
            var window = new PantheonTerminalWindow (this);
            window.show ();
            windows.append (window);
            add_window (window);
        }

        public static int main(string[] args) {
            app_cmd_name = "Pantheon Terminal";

            var app = new PantheonTerminalApp ();
            return app.run (args);
        }
    }
} // Namespace
