using Granite.Widgets;

namespace Application {
public class DifficultyView : Gtk.ScrolledWindow {

    private StackManager stack_manager = StackManager.get_instance ();
    private SudokuSettings settings;
    private SudokuBoard sudoku_board;
    private HeaderBar header_bar = HeaderBar.get_instance ();

    public DifficultyView () {
        var difficulty_view = new Welcome (_("Choose difficulty"), "");
        foreach (Difficulty diff in Difficulty.all ()) {
    		difficulty_view.append ("",diff.to_translated_string (), "");
    	}

        difficulty_view.activated.connect ((index) => {
            var choosenDifficulty = Difficulty.all ()[index];
            var sudoku_board = new SudokuBoard (choosenDifficulty);

            stack_manager.set_current_board(sudoku_board);
            header_bar.set_board (sudoku_board);
            stack_manager.get_stack ().visible_child_name = "game-view";
        });
        this.add (difficulty_view);
    }
}
}
