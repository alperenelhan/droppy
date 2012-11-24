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

using Droppy;

namespace Droppy {

    public class DroppyApp : Granite.Application {

        public DroppyWindow window;
        private static DroppyApp _instance;

        private static KeybindingManager key_manager;
        static string app_cmd_name;
        static string app_shell_name;
        static bool print_version;

        public bool is_visible;

        public int minimum_width;
        public int minimum_height;

        construct {
            print_version = false;
            build_data_dir = Constants.DATADIR;
            build_pkg_data_dir = Constants.PKGDATADIR;
            build_release_name = Constants.RELEASE_NAME;
            build_version = Constants.VERSION;
            build_version_info = Constants.VERSION_INFO;

            program_name = app_cmd_name;
            exec_name = app_cmd_name.down ().replace (" ", "-");
            app_years = "2011-2012";
            app_icon = "utilities-terminal";
            app_launcher = "droppy.desktop";
            application_id = "net.launchpad.droppy";
            main_url = "https://launchpad.net/droppy";
            bug_url = "https://bugs.launchpad.net/droppy";
            help_url = "https://answers.launchpad.net/droppy";
            translate_url = "https://translations.launchpad.net/droppy";
            about_authors = { "Osman Alperen Elhan <alperen@elhan.org£",
                              "Ahmet Yasin Uslu <nepjua@gmail.com" };

            about_license_type = License.GPL_3_0;
        }

        public static DroppyApp instance {
            get {
                if (_instance == null) {
                    _instance = new DroppyApp ();
                }
                return _instance;
            }
        }

        public DroppyApp () {
            Logger.initialize ("Droppy");
            Logger.DisplayLevel = LogLevel.DEBUG;

            saved_state = new SavedState ();
            settings = new Settings ();
        }


        protected override void activate () {
            window = new DroppyWindow (this);
            if (app_shell_name != null) {
                try {
                    GLib.Process.spawn_command_line_async ("gksu chsh -s " + app_shell_name);
                    return;
                } catch (Error e) {
                    warning (e.message);
                }
            }

            hideWindow();
            key_manager = new KeybindingManager();
            key_manager.init();
            key_manager.bind("F8", toggleView);
        }

        public void showWindow() {
            window.move(0,0);
            window.resize(1920, 400);
            is_visible = true;
            window.show();
            window.set_keep_above(true);
        }

        public void hideWindow() {
            is_visible = false;
            window.hide();
        }

        public void toggleView() {
            if(is_visible) {
                hideWindow();
            }
            else {
                showWindow();
            }
        }

        static const OptionEntry[] entries = {
            { "shell", 's', 0, OptionArg.STRING, ref app_shell_name, N_("Set shell at launch"), "" },
            { "version", 'v', 0, OptionArg.NONE, out print_version, "Print version info and exit", null },
            { null }
        };

        public static int main (string[] args) {
            app_cmd_name = "Droppy";

            var context = new OptionContext ("File");
            context.add_main_entries (entries, "droppy");
            context.add_group (Gtk.get_option_group (true));

            try {
                context.parse (ref args);
            } catch (Error e) {
                stdout.printf ("droppy: ERROR: " + e.message + "\n");
                return 0;
            }

            if (print_version) {
                stdout.printf ("Droppy %s\n", Constants.VERSION);
                stdout.printf ("Copyright 2011-2012 Terminal Developers.\n");
                return 0;
            }
            return DroppyApp.instance.run (args);
        }
    }
} // Namespace
