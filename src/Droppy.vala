// -*- Mode: vala; indent-tabs-mode: nil; tab-width: 4 -*-
/***
    Maintainers:
        2011-2012 Mario Guerriero <mefrio.g@gmail.com>
        2012 -    Droppy Developers

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

        public int default_width;
        public int default_height;
        public int max_width;
        public int max_height;

        public string shell_open_cmd;

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
            about_authors = { "Osman Alperen Elhan <alperen@elhan.org>",
                              "Ahmet Yasin Uslu <nepjua@gmail.com>" };

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
            shell_open_cmd = "gksu chsh -s " + app_shell_name;

            if( settings.is_login_shell ) {
                shell_open_cmd += " -l";
            }

        }


        protected override void activate () {
            if (window == null) {
                build ();
            }
            else {
                showWindow();
            }
        }

        private void build () {
            window = new DroppyWindow (this);
            if (app_shell_name != null) {
                try {
                    GLib.Process.spawn_command_line_async (shell_open_cmd);
                    return;
                } catch (Error e) {
                    warning (e.message);
                }
            }

            window.window_state_event.connect ((e) => {
                if ( (e.new_window_state & Gdk.WindowState.ICONIFIED ) != 0) {
                    hideWindow ();
                    window.deiconify();
                }
                else if ( (e.new_window_state & Gdk.WindowState.MAXIMIZED ) != 0) {
                    window.unmaximize();
                }
               return true;
            });

            key_manager = new KeybindingManager();
            key_manager.init();
            key_manager.bind("F12", toggleView);

            window.skip_pager_hint = true;
            window.skip_taskbar_hint = true;
            window.stick ();
            is_visible = false;
            Gdk.Rectangle r = {0,0};
            var screen = Gdk.Screen.get_default();
            screen.get_monitor_geometry (screen.get_primary_monitor(), out r);
            max_width = r.width;
            max_height = r.height;

            default_width = max_width;
            default_height = (int) (max_height * 0.45);
        }

        public void checkWindowStatus() {
            /*
                this method was originally intended to
                set window geometry after checking if it's already valid

                from valadoc.org:
                    get_position is not 100% reliable because the X Window System does not
                    specify a way to obtain the geometry of the decorations placed on a window
                    by the window manager.
                    Thus GTK+ is using a "best guess" that works with most window managers.

                Then there is no need to check window geometry.
            */

            // default_height and default_width will be replaced after implementing settings support.
            window.move(0,0);
            window.set_position(Gtk.WindowPosition.CENTER);
            window.set_default_size(default_width, default_height);
            window.resize(default_width, default_height);
        }

        public void showWindow() {
            checkWindowStatus();
            is_visible = true;
            window.show_all();
            window.set_keep_above(true);
            var t = window.current_terminal;
            Gdk.Window gdk_window = (window as Gtk.Widget).get_window();
            uint32 time = Gdk.x11_get_server_time (gdk_window);
            window.present_with_time(time);
            //gdk_window.focus (time);
            //window.grab_focus();
            //t.grab_focus();
        }

        public void hideWindow() {
            is_visible = false;
            // window.hide();
            window.iconify();
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
            Gtk.init(ref args);
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
                return 0;
            }
            return DroppyApp.instance.run (args);
        }
    }
}
