using Granite.Widgets;

namespace Application {
public class WelcomeView : Gtk.ScrolledWindow {

    private StackManager stack_manager = StackManager.get_instance ();
    private SudokuSettings settings;
    private SudokuBoard sudoku_board;
    private HeaderBar header_bar = HeaderBar.get_instance ();

    public WelcomeView () {
        var welcome_view = new Welcome (_("Sudokular"), "");
        welcome_view.append ("", _("New game"), _("Choose difficulty and start a new puzzle"));

    	this.settings = new SudokuSettings ();
        if (settings.isSaved ()) {
            sudoku_board = new SudokuBoard.from_string (settings.load ());
            if (!sudoku_board.isFinshed ()) {
                welcome_view.append ("", _("Resume game"), _("Return to where you left off."));
            } else {
                sudoku_board = null;
            }
        }

        welcome_view.activated.connect ((option) => {
            switch (option) {
                case 0:
                    stack_manager.get_stack ().visible_child_name = "difficulty-view";
                    break;
            }
            switch (option) {
                case 1:
                    if (sudoku_board.isFinshed ()) {
                        sudoku_board = null;
                    }

                    header_bar.set_board (sudoku_board);
                    stack_manager.set_current_board (sudoku_board);
                    stack_manager.get_stack ().visible_child_name = "game-view";
                    break;
            }
        });
        this.add (welcome_view);
    }
}
}
