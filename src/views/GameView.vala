using Granite.Widgets;

namespace Application {
public class GameView : Gtk.Stack {
    private Granite.Widgets.Welcome welcome;
    private SudokuSettings settings;
    private Gtk.Box welcome_box;
    private WinPage win_page;
    private SudokuBoard sudoku_board;
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private Gtk.Stack stack;
    private Gtk.InfoBar info_bar;

    public GameView() {
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
        Gtk.Image image = new Gtk.Image.from_resource ("/com/github/bartzaalberg/sudokular/header.png");
        image.override_background_color( Gtk.StateFlags.NORMAL, Constants.WHITE);
        welcome_box.pack_start (image);
        welcome_box.pack_end (welcome);

    	stack.add_named (welcome_box, "welcome");
        stack.add_named (win_page, "win");
        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.pack_end (stack, false, true, 0);
        this.add (main_box);

        info_bar = new Gtk.InfoBar ();
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
    }

    private void set_board (SudokuBoard sudoku_board) {
        info_bar.no_show_all = true;
        info_bar.hide ();
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

    public void load_board (SudokuBoard current_board) {
        sudoku_board = current_board;
        header_bar.set_board (sudoku_board);
        set_board (sudoku_board);
    }
}
}
