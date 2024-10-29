# qutemacs - a simple, preconfigured Emacs binding set for qutebrowser
#
# The aim of this binding set is not to provide bindings for absolutely
# everything, but to provide a stable launching point for people to make their
# own bindings.
#
# Installation:
#
# 1. Copy this file or add this repo as a submodule to your dotfiles.
# 2. Add this line to your config.py, and point the path to this file:
# config.source('qutemacs/qutemacs.py')
#
# References:
# 1. https://www.reddit.com/r/qutebrowser/comments/eh10i7/config_share_qute_with_emacs_keybindings/
# 2. https://github.com/qutebrowser/qutebrowser/blob/main/doc/help/configuring.asciidoc#emacs-like-config

# Code:
config = config  # type: ConfigAPI # noqa: F821 pylint: disable=E0602,C0103
c = c  # type: ConfigContainer # noqa: F821 pylint: disable=E0602,C0103

c.tabs.background = True
# disable insert mode completely
c.input.insert_mode.auto_enter = False
c.input.insert_mode.auto_leave = False
c.input.insert_mode.plugins = False

# Forward unbound keys
c.input.forward_unbound_keys = "all"



ESC_BIND = 'clear-keychain ;; search ;; fullscreen --leave'


import string

c.bindings.default['normal'] = {}
c.bindings.default['insert'] = {}

c.bindings.commands['insert'] = {
    '<ctrl-space>': 'mode-leave',
    '<ctrl-g>': 'mode-leave;;fake-key <Left>;;fake-key <Right>',
    '<ctrl-f>': 'fake-key <Shift-Right>',
    '<ctrl-b>': 'fake-key <Shift-Left>',
    '<ctrl-e>': 'fake-key <Shift-End>',
    '<ctrl-a>': 'fake-key <Shift-Home>',
    '<ctrl-p>': 'fake-key <Shift-Up>',
    '<ctrl-n>': 'fake-key <Shift-Down>',
    '<Return>': 'mode-leave',
    '<ctrl-w>': 'fake-key <Ctrl-x>;;message-info "cut to clipboard";;mode-leave',
    '<alt-w>': 'fake-key <Ctrl-c>;;message-info "copy to clipboard";;mode-leave',
    '<backspace>': 'fake-key <backspace>;;mode-leave',
    '<alt-x>': 'mode-leave;;cmd-set-text :',
    '<alt-o>': 'mode-leave;;tab-focus last',
    '<Tab>': 'fake-key <f1>'
}




for char in list(string.ascii_lowercase):
    c.bindings.commands['insert'].update({char: 'fake-key ' + char + ';;mode-leave'})

for CHAR in list(string.ascii_uppercase):
    c.bindings.commands['insert'].update({CHAR: 'fake-key ' + char + ';;mode-leave'})

for num in list(map(lambda x : str(x), range(0, 10))):
    c.bindings.commands['insert'].update({num: 'fake-key ' + num + ';;mode-leave'})

for symb in [',', '.', '/', '\'', ';', '[', ']', '\\',
             '!', '@','#','$','%','^','&','*','(',')','-','_', '=', '+', '`', '~',
             ':', '\"', '<', '>', '?','{', '}', '|']:
    c.bindings.commands['insert'].update({symb: 'insert-text ' + symb + ' ;;mode-leave'})


# Bindings
c.bindings.commands['normal'] = {
    # Navigation
    '<ctrl-space>': 'enter-mode insert',
    '<ctrl-]>': 'fake-key <Ctrl-Shift-Right>',
    '<ctrl-[>': 'fake-key <Ctrl-Shift-Left>',
    '<ctrl-v>': 'scroll-page 0 0.5',
    '<alt-v>': 'scroll-page 0 -0.5',
    '<ctrl-shift-v>': 'scroll-page 0 1',
    '<alt-shift-v>': 'scroll-page 0 -1',

    '<alt-x>': 'cmd-set-text :',
    '<ctrl-x>b': 'cmd-set-text -s :buffer;;fake-key <Down><Down><Down>',
    '<ctrl-x>k': 'tab-close',
    '<ctrl-x>r': 'config-cycle',
    '<ctrl-x>1': 'tab-only;;message-info "cleared all other tabs"',
    '<ctrl-x><ctrl-c>': 'quit',

    # Navigation extra
    '<ctrl-c>r': 'reload',

    # searching
    '<ctrl-s>': 'cmd-set-text /',
    '<ctrl-r>': 'cmd-set-text ?',

    # hinting
    '<alt-s>': 'hint all',

    # tabs
    '<ctrl-t>': 'tab-clone',
    '<ctrl-tab>': 'tab-next',
    '<ctrl-shift-tab>': 'tab-prev',

    # open links
    '<ctrl-l>': 'cmd-set-text -s :open',
    '<alt-l>': 'cmd-set-text -s :open -t',

    # editing
    '<alt-[>': 'back',
    '<alt-]>': 'forward',
    '<ctrl-/>': 'fake-key <Ctrl-z>',
    '<ctrl-shift-?>': 'fake-key <Ctrl-Shift-z>',
    '<ctrl-k>': 'fake-key <Shift-End>;;fake-key <Backspace>',
    '<ctrl-f>': 'fake-key <Right>',
    '<ctrl-b>': 'fake-key <Left>',
    '<alt-o>': 'tab-focus last',
    '<ctrl-a>': 'fake-key <Home>',
    '<ctrl-x>h': 'fake-key <Ctrl-a>',
    '<ctrl-e>': 'fake-key <End>',
    '<ctrl-n>': 'fake-key <Down>',
    '<ctrl-p>': 'fake-key <Up>',
    '<alt-f>': 'fake-key <Ctrl-Right>',
    '<alt-b>': 'fake-key <Ctrl-Left>',
    '<ctrl-d>': 'fake-key <Delete>',
    '<alt-d>': 'fake-key <Ctrl-Delete>',
    '<alt-backspace>': 'fake-key <Ctrl-Backspace>',
    '<ctrl-w>': 'fake-key <Ctrl-x>;;message-info "cut to clipboard"',
    '<alt-w>': 'fake-key <Ctrl-c>;;message-info "copy to clipboard"',
    '<ctrl-y>': 'insert-text {primary}',

    '1': 'fake-key 1',
    '2': 'fake-key 2',
    '3': 'fake-key 3',
    '4': 'fake-key 4',
    '5': 'fake-key 5',
    '6': 'fake-key 6',
    '7': 'fake-key 7',
    '8': 'fake-key 8',
    '9': 'fake-key 9',
    '0': 'fake-key 0',

    # escape hatch
    '<ctrl-h>': 'cmd-set-text -s :help',
    '<ctrl-g>': ESC_BIND,

    # othrer extras
}

c.bindings.commands['command'] = {
    '<ctrl-s>': 'search-next',
    '<ctrl-r>': 'search-prev',

    '<ctrl-p>': 'completion-item-focus prev',
    '<ctrl-n>': 'completion-item-focus next',

    '<alt-p>': 'command-history-prev',
    '<alt-n>': 'command-history-next',

	# escape hatch
    '<ctrl-g>': 'mode-leave',
}

c.bindings.commands['hint'] = {
    # escape hatch
    '<ctrl-g>': 'mode-leave',
}


c.bindings.commands['caret'] = {
    # escape hatch
    '<ctrl-g>': 'mode-leave',
    '<ctrl-space>': 'toggle-selection'
}

# Search engines
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "g": "https://google.com/search?q={}",
}

# Set Emacs client to editor
c.editor.command = ["emacsclient", "-c", "{file}"]

# Reload config
c.bind("<Ctrl-x><Ctrl-l>", "config-source")
