# borrowed from:
# https://github.com/daviwil/dotfiles/blob/master/.files/.config/qutebrowser/config.py
c.auto_save.session = True
c.scrolling.smooth = True
c.session.lazy_restore = True
c.content.autoplay = False

# Better default fonts
c.fonts.web.family.standard = "JetBrains Mono"
c.fonts.web.family.serif = "JetBrains Mono"
c.fonts.web.family.sans_serif = "JetBrains Mono"
c.fonts.web.family.fixed = "JetBrains Mono"
c.fonts.statusbar = "JetBrains Mono"

# Use dark mode where possible
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "never"
c.colors.webpage.bg = "black"

# Make Ctrl+g quit everything like in Emacs
config.bind('<Ctrl-g>', 'leave-mode', mode='insert')
config.bind('<Ctrl-g>', 'leave-mode', mode='command')
config.bind('<Ctrl-g>', 'leave-mode', mode='prompt')
config.bind('<Ctrl-g>', 'leave-mode', mode='hint')
# config.bind('v', 'spawn ~/.dotfiles/bin/umpv {url}')
# config.bind('V', 'hint links spawn ~/.dotfiles/bin/umpv {hint-url}')

# Load the autoconfig file (quteconfig.py)
config.load_autoconfig()

# Load qutemacs file (qutemacs.py) for Emacs Keybindings.
#config.source('qutemacs.py')
