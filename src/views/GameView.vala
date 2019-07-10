using Granite.Widgets;

namespace Application {
public class GameView : Gtk.Stack {

    private StackManager stack_manager = StackManager.get_instance ();
    private SudokuSettings settings;
    private WinPage win_page;
    private SudokuBoard sudoku_board;
    private HeaderBar header_bar = HeaderBar.get_instance ();
    private Gtk.Stack stack;

    public GameView() {
        settings = new SudokuSettings ();
    	stack = new Gtk.Stack ();

        win_page = new WinPage ();
        win_page.return_to_welcome.connect (() => {
            stack_manager.get_stack ().visible_child_name = "welcome-view";
        });

        stack.add_named (win_page, "win");
        var main_box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        main_box.pack_start (stack, true, true, 0);

        this.add (main_box);

        if (settings.isSaved ()) {
            sudoku_board = new SudokuBoard.from_string (settings.load ());
            if (sudoku_board.isFinshed ()) {
                sudoku_board = null;
            }
        }
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

    public void load_board (SudokuBoard current_board) {
        sudoku_board = current_board;
        header_bar.set_board (sudoku_board);
        set_board (sudoku_board);
    }

    public void save_board () {
        if (sudoku_board != null) {
            settings.save (sudoku_board.to_string ());
        }
    }
}
}
