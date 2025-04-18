labwc(1)

# NAME

labwc - a Wayland stacking compositor

# SYNOPSIS

*labwc* [options...]

# DESCRIPTION

Labwc is a wlroots-based stacking compositor for wayland.

It is light-weight and independent with a focus on simply stacking windows
well and rendering some window decorations. Where practicable it uses clients
for wall-paper, panels, screenshots and so on.

# SIGNALS

The compositor will exit or reload its configuration upon receiving SIGTERM
and SIGHUP respectively. For example:

```
kill -s <signal> $LABWC_PID
killall -s <signal> labwc
```

Each running instance of labwc sets the environment variable `LABWC_PID` to
its PID. This is useful for sending signals to a specific instance and is what
the `--exit` and `--reconfigure` options use.

# OPTIONS

*-c, --config* <config-file>
	Specify a config file with path

*-C, --config-dir* <config-directory>
	Specify a config directory

*-d, --debug*
	Enable full logging, including debug information. See *ENVIRONMENT
	VARIABLES* section below for further options.

*-e, --exit*
	Exit the compositor by sending SIGTERM to `$LABWC_PID`

*-h, --help*
	Show help message and quit

*-m, --merge-config*
	Merge user config/theme files in all XDG Base Directories

*-r, --reconfigure*
	Reload the compositor configuration by sending SIGHUP to `$LABWC_PID`

*-s, --startup* <command>
	Run command on startup

*-S, --session* <command>
	Run command on startup and terminate compositor on exit. This is useful
	for session management as it allows the session client to terminate
	labwc by exiting itself. This is a Wayland specific use-case because
	under X, xinit starts the server and keeps it alive for as long as the
	session client. Thus either the session client starts the Window
	Manager, or the Window Manager can be launched independently first. On
	Wayland, the Compositor is both Display Server and Window Manager, so
	the described session management mechanisms do not work because the
	Compositor needs to be running before the session can function.  As some
	session clients support both X11 and Wayland, this command line option
	avoids re-writes and fragmentation.

*-v, --version*
	Show the version number and quit

*-V, --verbose*
	Enable more verbose logging

# SESSION MANAGEMENT

To enable the use of graphical clients launched via D-Bus or systemd service
activation, labwc can update both activation environments on launch. Provided
that labwc is aware of an active D-Bus user session (*i.e.*, the environment
variable `DBUS_SESSION_BUS_ADDRESS` is defined), the compositor will invoke the
commands

```
dbus-update-activation-environment
systemctl --user import-environment
```

(when available) to notify D-Bus and systemd with the values of the following
environment variables:

```
WAYLAND_DISPLAY
DISPLAY
XDG_CURRENT_DESKTOP
XDG_SESSION_TYPE
XCURSOR_SIZE
XCURSOR_THEME
LABWC_PID
```

This behavior is enabled by default whenever labwc uses the "DRM" wlroots
backend (which implies that labwc is the primary compositor on the console).
When other backends are employed (for example, when labwc runs nested in another
Wayland compositor or an X11 server), updates to the activation environment are
disabled by default. Updates to the activation environment can be forced by
setting the environment variable `LABWC_UPDATE_ACTIVATION_ENV` to one of the
truthy values `1`, `true`, `yes` or `on`; or suppressed by setting the variable
to one of the falsy values `0`, `false`, `no` or `off`.

Whenever labwc updates the activation environment on launch, it will also
attempt to clear the activation environment on exit. For D-Bus, which does not
provide a means for properly un-setting variables in the activation environment,
this is accomplished by setting the session variables to empty strings. For
systemd, the command `systemctl --user unset-environment` will be invoked to
actually remove the variables from the activation environment.

# ENVIRONMENT VARIABLES

Set the environment variables listed below to enable specific debug options.
This can be done in either the *environment* file or on the command line, for
example: *LABWC_DEBUG_FOO=1 labwc*.

*LABWC_DEBUG_LIBSFDO*
	Enable debug and info logging for libsfdo, for example for parsing of
	.desktop files and searching for icons. Note that libsfdo error logging
	is always enabled regardless of this environment variable but will only
	be shown with the *-V|--version* option.

*LABWC_DEBUG_DIR_CONFIG_AND_THEME*
	Increase logging of paths for config files (for example rc.xml,
	autostart, environment and menu.xml) as well as titlebar buttons.

*LABWC_DEBUG_CONFIG_NODENAMES*++
*LABWC_DEBUG_MENU_NODENAMES*
	Enable logging of all nodenames (for example *policy.placement: Cascade*
	for *<placement><policy>Cascade</policy></placement>*) for config and
	menu files respectively.

*LABWC_DEBUG_KEY_STATE*
	Enable logging of press and release events for bound keys (generally
	key-combinations like *Ctrl-Alt-t*)

# SEE ALSO

labwc-actions(5), labwc-config(5), labwc-menu(5), labwc-theme(5)
