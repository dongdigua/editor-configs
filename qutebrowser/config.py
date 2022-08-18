config.load_autoconfig(False)
c.zoom.default = 125
c.scrolling.smooth = True
c.url.start_pages = "~/.config/qutebrowser/home.html"
c.content.javascript.can_access_clipboard = True
c.content.proxy = "http://localhost:20171/"
config.bind("<Ctrl-[>", "set -p content.proxy http://localhost:20171/", mode="normal")
config.bind("<Ctrl-]>", "set -p content.proxy none",                    mode="normal")

