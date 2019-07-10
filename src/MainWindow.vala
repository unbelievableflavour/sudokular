namespace Application {
public class MainWindow : Gtk.Window {
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private uint configure_id;
    private StackManager stack_manager = StackManager.get_instance ();
    public MainWindow (Gtk.Application application) {
        Object (application: application,
                icon_name: Constants.APPLICATION_NAME,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {
        set_titlebar (header_bar);

        this.delete_event.connect (on_window_closing);

        stack_manager.load_views (this);
        add_shortcuts();
    }

    private bool on_window_closing () {
        stack_manager.save_current_board();
        return false;
    }

    private void add_shortcuts () {
        key_press_event.connect ((e) => {
            switch (e.keyval) {
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
                    stack_manager.save_current_board();
                    this.destroy ();
                  }
                  break;
            }

            return false;
        });
    }

    public override bool configure_event (Gdk.EventConfigure event) {
        var settings = new GLib.Settings (Constants.APPLICATION_NAME);

        if (configure_id != 0) {
            GLib.Source.remove (configure_id);
        }

        configure_id = Timeout.add (100, () => {
            configure_id = 0;

            if (is_maximized) {
                settings.set_boolean ("window-maximized", true);
            } else {
                settings.set_boolean ("window-maximized", false);

                Gdk.Rectangle rect;
                get_allocation (out rect);
                settings.set ("window-size", "(ii)", rect.width, rect.height);

                int root_x, root_y;
                get_position (out root_x, out root_y);
                settings.set ("window-position", "(ii)", root_x, root_y);
            }

            return false;
        });

        return base.configure_event (event);
    }
}
}
