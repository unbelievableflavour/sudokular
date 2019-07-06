namespace Application {
public class HeaderBar : Gtk.HeaderBar {
	static HeaderBar? instance;

	private Gtk.Label points_label = new Gtk.Label ("");
	private Gtk.Label factor_label = new Gtk.Label ("");
	private Gtk.Label fails_label = new Gtk.Label ("");
	private Granite.ModeSwitch dark_mode_switch = new Granite.ModeSwitch.from_icon_name (
		"display-brightness-symbolic", "weather-clear-night-symbolic"
	);

	HeaderBar () {
        generate_dark_mode_button ();
		reset ();

		this.show_close_button = true;

        pack_start (points_label);
		pack_start (factor_label);
		pack_end(dark_mode_switch);

        set_custom_title (fails_label);
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
