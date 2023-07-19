#! /usr/bin/env -S vala workbench.vala --pkg gtk4 --pkg libadwaita-1 --pkg gio-2.0

using Gtk;
using Adw;
using Gdk;
using GLib;

public void main() {
  var root_box = workbench.builder.get_object("root_box") as Box;
  var stack = workbench.builder.get_object("stack") as Stack;
  var navigation_row = workbench.builder.get_object("navigation_row") as ComboRow;
  var transition_row = workbench.builder.get_object("transition_row") as ComboRow;

  Gtk.Separator? separator = null;
  Gtk.StackSwitcher? stack_switcher = null;
  Gtk.StackSidebar? stack_sidebar = null;

  if (navigation_row.selected == 0) {
    stack_switcher = new Gtk.StackSwitcher();
    stack_switcher.stack = stack;
    root_box.prepend(stack_switcher);
  } else {
    stack_sidebar = new Gtk.StackSidebar();
    separator = new Separator(Gtk.Orientation.HORIZONTAL);
    stack_sidebar.stack = stack;
    root_box.prepend(separator);
    root_box.prepend(stack_sidebar);
  }

  navigation_row.notify["selected"].connect(() => {
    if (navigation_row.selected == 0) {
      if (stack_sidebar != null) {
        root_box.remove(stack_sidebar);
        root_box.remove(separator);
      }

      stack_switcher = new Gtk.StackSwitcher();
      stack_switcher.stack = stack;
      root_box.prepend(stack_switcher);
      root_box.set_orientation(Gtk.Orientation.VERTICAL);
    } else {
      if (stack_switcher != null) {
        root_box.remove(stack_switcher);
      }

      separator = new Separator(Gtk.Orientation.HORIZONTAL);
      stack_sidebar = new StackSidebar();
      stack_sidebar.stack = stack;
      root_box.prepend(separator);
      root_box.prepend(stack_sidebar);
      root_box.set_orientation(Gtk.Orientation.HORIZONTAL);
    }
  });

  stack.set_transition_type(transition_row.selected);

  transition_row.notify["selected"].connect(() => {
    stack.set_transition_type(transition_row.selected);
  });
}
