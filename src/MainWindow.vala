namespace Application {
public class MainWindow : Gtk.Window {
	private SudokuSettings settings;
    private Gtk.Stack stack;
    private Granite.Widgets.Welcome welcome;
    private Gtk.Box welcome_box;
    private SudokuBoard sudoku_board;
    private WinPage win_page;
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private uint configure_id;

    public MainWindow (Gtk.Application application) {
        Object (application: application,
                icon_name: Constants.APPLICATION_NAME,
                height_request: Constants.APPLICATION_HEIGHT,
                width_request: Constants.APPLICATION_WIDTH);
    }

    construct {
        set_titlebar (header_bar);

        this.delete_event.connect (on_window_closing);

    	this.settings = new SudokuSettings ();
    	stack = new Gtk.Stack ();
        stack.margin_top = 15;
        stack.margin_bottom = 15;
        welcome_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
    	welcome = new Granite.Widgets.Welcome ("", _("Choose difficulty"));
    	foreach (Difficulty diff in Difficulty.all ()) {
    		welcome.append ("",diff.to_translated_string (), "");
    	}
        win_page = new WinPage ();
        win_page.return_to_welcome.connect (() => {
            stack.set_visible_child (welcome_box);
        });
        Gtk.Image image = new Gtk.Image.from_resource ("/com/github/bartzaalberg/sudoku/header.png");
        welcome_box.pack_start (image);
        welcome_box.pack_end (welcome);
    	stack.add_named (welcome_box, "welcome");
        stack.add_named (win_page, "win");
        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.pack_end (stack, false, true, 0);
        this.add (main_box);

        var info_bar = new Gtk.InfoBar ();
        if (settings.isSaved ()) {
            sudoku_board = new SudokuBoard.from_string (settings.load ());
            if (!sudoku_board.isFinshed ()) {
                info_bar.set_message_type (Gtk.MessageType.ERROR);
                main_box.pack_end (info_bar, false, true, 0);
                var content = info_bar.get_content_area ();
                var infobox = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 20);
                content.add (infobox);
                var button = new Gtk.Button.with_label (_("Resume last game"));
                button.clicked.connect (() => {
                    info_bar.no_show_all = true;
                    info_bar.hide ();
                    header_bar.set_board (sudoku_board);
                    set_board (sudoku_board);
                });
                infobox.pack_end (button);
            } else {
                sudoku_board = null;
            }

        }
        welcome.activated.connect ((index) => {
            info_bar.no_show_all = true;
            info_bar.hide ();
            var choosenDifficulty = Difficulty.all ()[index];
            sudoku_board = new SudokuBoard (choosenDifficulty);
            header_bar.set_board (sudoku_board);
            set_board (sudoku_board);
        });
        add_shortcuts();
    }

    private void set_board (SudokuBoard sudoku_board) {
        var board = new Board (sudoku_board);
        stack.add_named (board, "board");
        show_all ();
        stack.set_visible_child (board);
        sudoku_board.start ();
        sudoku_board.won.connect ((b) => {
            if (b.fails <= 3) {
                settings.highscore = b.points;
            }
            win_page.set_board (b, settings.highscore);
            stack.set_visible_child (win_page);
            sudoku_board = null;
            settings.delete ();
        });
    }

    private bool on_window_closing () {
        if (sudoku_board != null) {
            settings.save (sudoku_board.to_string ());
        }
        return false;
    }

    private void add_shortcuts () {
        key_press_event.connect ((e) => {
            switch (e.keyval) {
                case Gdk.Key.q:
                  if ((e.state & Gdk.ModifierType.CONTROL_MASK) != 0) {
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
