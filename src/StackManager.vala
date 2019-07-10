namespace Application {
public class StackManager : Object {

    static StackManager? instance;

    private Gtk.Stack stack;
    private const string WELCOME_VIEW_ID = "welcome-view";
    private const string DIFFICULTY_VIEW_ID = "difficulty-view";
    private const string GAME_VIEW_ID = "game-view";

    GameView game_view;
    public Gtk.Window main_window;


    StackManager () {
        stack = new Gtk.Stack ();
        stack.margin_bottom = 4;
        stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
    }

    public static StackManager get_instance () {
        if (instance == null) {
            instance = new StackManager ();
        }
        return instance;
    }

    public Gtk.Stack get_stack () {
        return this.stack;
    }

    public void load_views (Gtk.Window window) {
        game_view = new GameView();

        main_window = window;
        stack.add_named (new WelcomeView (), WELCOME_VIEW_ID);
        stack.add_named (new DifficultyView (), DIFFICULTY_VIEW_ID);
        stack.add_named (game_view, GAME_VIEW_ID);

        stack.notify["visible-child"].connect (() => {
            var header_bar = HeaderBar.get_instance ();

            if (stack.get_visible_child_name () == WELCOME_VIEW_ID) {
                header_bar.show_return_button (false);
            }

            if (stack.get_visible_child_name () == DIFFICULTY_VIEW_ID) {
                header_bar.show_return_button (true);
            }

            if (stack.get_visible_child_name () == GAME_VIEW_ID) {
                header_bar.show_return_button (true);
            }
        });

        window.add (stack);
   }

   public void set_current_board (SudokuBoard current_board) {
        game_view.load_board(current_board);
   }

   public void save_current_board () {
        game_view.save_board();
   }

   public void reload_board () {
        var current_board = game_view.get_board();
        game_view.load_board(current_board);
   }
}
}
