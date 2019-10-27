# DAX Mode for Emacs

Major mode that let's you edit the DAX language in your favourite editor.

Also included is a `dax-pretty-print` function that uses http://www.daxformatter.com/api/daxformatter/DaxFormat/ to beautify your code.

## Installation

### Manual installation
Just clone this repo to `emacs.d` and place the code below in your `init.el`:

``` emacs-lisp
(load "~/.emacs.d/dax-mode/dax-mode.el")
```

### Using [straight.el](https://github.com/raxod502/straight.el)
Place the code below in your `init.el`:

``` emacs-lisp
(straight-use-package
    '(dax-mode :type git :host github :repo "fpvmorais/dax-mode"))
```

