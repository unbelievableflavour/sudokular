namespace Application {
public class HeaderBar : Gtk.HeaderBar {
	static HeaderBar? instance;
	
	private StackManager stack_manager = StackManager.get_instance ();

	private Gtk.Label points_label = new Gtk.Label ("");
	private Gtk.Label factor_label = new Gtk.Label ("");
	private Gtk.Label fails_label = new Gtk.Label ("");
	public Gtk.Button return_button = new Gtk.Button ();

	private Granite.ModeSwitch dark_mode_switch = new Granite.ModeSwitch.from_icon_name (
		"display-brightness-symbolic", "weather-clear-night-symbolic"
	);

	HeaderBar () {
		generate_return_button ();
        generate_dark_mode_button ();

		reset ();

        set_custom_title (fails_label);

		pack_start (return_button);
        pack_start (points_label);
		pack_start (factor_label);
		pack_end(dark_mode_switch);
		this.show_close_button = true;
	}

    public static HeaderBar get_instance () {
        if (instance == null) {
            instance = new HeaderBar ();
        }
        return instance;
    }

	public void set_board (SudokuBoard board) {
		points_label.visible = true;
		factor_label.visible = true;
		fails_label.visible = true;
		board.notify["points"].connect ((s, p) => {
			points_label.set_markup (_("Points: ") + "<b>%i</b>".printf (board.points));
		});
		board.notify["factor"].connect ((s, p) => {
			factor_label.set_markup (_("Factor: ") + "<b>x%i</b>".printf (board.factor));
		});
		board.notify["fails"].connect ((s, p) => {
			set_fail (board);
		});
		set_fail (board);
		points_label.set_markup (_("Points: ") + "<b>%i</b>".printf (board.points));
		factor_label.set_markup (_("Factor: ") + "<b>x%i</b>".printf (board.factor));
		show_all ();
	}

	private void set_fail (SudokuBoard board) {
		if (board.fails > 3) {
			string tmp = "%i ".printf (board.fails);
			tmp += _("broken series");
			fails_label.set_markup ("<span foreground=\"red\" weight=\"bold\">"+tmp+"</span>");
			fails_label.margin_top = 0;
		} else {
			string tmp = "";
			for (var i = 0; i < board.fails; i++) {
				tmp += "X";
			}
			fails_label.set_markup ("<span face=\"Daniel Black\" weight=\"bold\">"+tmp+"</span>");
			fails_label.margin_top = 10;
		}
	}

	public void reset () {
		points_label.visible = false;
		factor_label.visible = false;
		fails_label.visible = false;
	}

    private void generate_return_button () {
        return_button.label = _("Back");
        return_button.no_show_all = true;
        return_button.visible = false;
        return_button.get_style_context ().add_class ("back-button");
        return_button.clicked.connect (() => {
			reset();
            stack_manager.save_current_board();
            stack_manager.get_stack ().visible_child_name = "welcome-view";
        });
    }

    public void show_return_button (bool answer) {
        return_button.visible = answer;
    }

    private void generate_dark_mode_button () {
	    GLib.Settings settings = new GLib.Settings (Constants.APPLICATION_NAME);
	    var gtk_settings = Gtk.Settings.get_default ();
	    dark_mode_switch.primary_icon_tooltip_text = _("Light mode");
	    dark_mode_switch.secondary_icon_tooltip_text = _("Dark mode");
	    dark_mode_switch.valign = Gtk.Align.CENTER;
	    dark_mode_switch.bind_property ("active", gtk_settings, "gtk_application_prefer_dark_theme");
	    settings.bind ("use-dark-theme", dark_mode_switch, "active", GLib.SettingsBindFlags.DEFAULT);
	}
}
}
