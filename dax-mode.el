;;; dax-mode.el --- major mode for editing DAX code. -*- coding: utf-8; lexical-binding: t; -*-

;; Copyright © 2019, by fpvmorais@gmail.com

;; Author: Pedro Morais ( fpvmorais@gmail.com )
;; Version: 1.0
;; Created: 2017 10 16
;; Keywords: languages
;; Homepage: TODO: github repo

;; This file is not part of GNU Emacs.

;;; License:

;; You can redistribute this program and/or modify it under the terms of the GNU General Public License version 2.

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.dax\\'" . dax-mode))

(defun dax-pretty-print ()
  "Pretty print the DAX buffer via DaxFormatter API."
  (interactive)
  (goto-char (point-min))
  (while (search-forward ";" nil t)
    (replace-match ","))
  (goto-char (point-min))
  (let* (
         (url-request-method "POST")
         (url-request-extra-headers '(("Content-Type" . "application/json")))
         (url-request-data (json-encode `(("Dax" ., (delete-and-extract-region (point-min) (point-max)) ))))
         (buf (current-buffer))
         (newbuff (url-retrieve-synchronously "http://www.daxformatter.com/api/daxformatter/DaxFormat/"))
         )
    (set-buffer newbuff)
    (goto-char (point-min))
    (re-search-forward "^$")
    (delete-region (point) (point-min))
    (setq noQuotes (substring (buffer-string) 2 -9))
    (setq noRN (replace-regexp-in-string "\\\\r\\\\n" "
" noQuotes))
    (setq noBars (replace-regexp-in-string "\\\\" "" noRN))
    (princ noBars buf)
    (kill-buffer newbuff)
    )
  )

;; each category of keyword is given a particular face
(setq dax-font-lock-keywords
      (let* (
            ;; define several category of keywords
            (x-keywords '("VAR" "RETURN"))
            ;(x-types '("float" "integer" "key" "list" "rotation" "string" "vector"))
            ;(x-constants '("ACTIVE" "AGENT" "ALL_SIDES" "ATTACH_BACK"))
            ;(x-events '("at_rot_target" "at_target" "attach"))
            (x-functions '("ABS"
                           "ACOS"
                           "ACOSH"
                           "ADDCOLUMNS"
                           "ADDMISSINGITEMS"
                           "ALL"
                           "ALLEXCEPT"
                           "ALLNOBLANKROW"
                           "ALLSELECTED"
                           "AND"
                           "ASIN"
                           "ASINH"
                           "ATAN"
                           "ATANH"
                           "AVERAGE"
                           "AVERAGEA"
                           "AVERAGEX"
                           "BETA.DIST"
                           "BETA.INV"
                           "BLANK"
                           "CALCULATE"
                           "CALCULATETABLE"
                           "CALENDAR"
                           "CALENDARAUTO"
                           "CEILING"
                           "CHISQ.INV"
                           "CHISQ.INV.RT"
                           "CLOSINGBALANCEMONTH"
                           "CLOSINGBALANCEQUARTER"
                           "CLOSINGBALANCEYEAR"
                           "CODE"
                           "COMBIN"
                           "COMBINA"
                           "COMBINEVALUES"
                           "CONCATENATE"
                           "CONCATENATEX"
                           "CONFIDENCE.NORM"
                           "CONFIDENCE.T"
                           "CONTAINS"
                           "CONTAINSROW"
                           "COS"
                           "COSH"
                           "COUNT"
                           "COUNTA"
                           "COUNTAX"
                           "COUNTBLANK"
                           "COUNTROWS"
                           "COUNTX"
                           "CROSSFILTER"
                           "Function"
                           "CROSSJOIN"
                           "CURRENCY"
                           "CUSTOMDATA"
                           "DATATABLE"
                           "DATE"
                           "DATEADD"
                           "DATEDIFF"
                           "DATESBETWEEN"
                           "DATESINPERIOD"
                           "DATESMTD"
                           "DATESQTD"
                           "DATESYTD"
                           "DATEVALUE"
                           "DAY"
                           "DEGREES"
                           "DISTINCT"
                           "DISTINCTCOUNT"
                           "DIVIDE"
                           "EARLIER"
                           "EARLIEST"
                           "EDATE"
                           "ENDOFMONTH"
                           "ENDOFQUARTER"
                           "ENDOFYEAR"
                           "EOMONTH"
                           "ERROR"
                           "EVEN"
                           "EXACT"
                           "EXCEPT"
                           "EXP"
                           "EXPON.DIST"
                           "FACT"
                           "FALSE"
                           "FILTER"
                           "FILTERS"
                           "FIND"
                           "FIRSTDATE"
                           "FIRSTNONBLANK"
                           "FIXED"
                           "FLOOR"
                           "FORMAT"
                           "GCD"
                           "GENERATE"
                           "GENERATEALL"
                           "GENERATESERIES"
                           "GEOMEAN"
                           "GEOMEANX"
                           "GROUPBY"
                           "HASONEFILTER"
                           "HASONEVALUE"
                           "HOUR"
                           "IF"
                           "IFERROR"
                           "IN"
                           "INT"
                           "INTERSECT"
                           "ISBLANK"
                           "ISCROSSFILTERED"
                           "ISEMPTY"
                           "ISERROR"
                           "ISEVEN"
                           "ISFILTERED"
                           "ISLOGICAL"
                           "ISNONTEXT"
                           "ISNUMBER"
                           "ISO.CEILING"
                           "ISODD"
                           "ISONORAFTER"
                           "ISTEXT"
                           "KEEPFILTERS"
                           "LASTDATE"
                           "LASTNONBLANK"
                           "LCM"
                           "LEFT"
                           "LEN"
                           "LN"
                           "LOG"
                           "LOG10"
                           "LOOKUPVALUE"
                           "LOWER"
                           "MAX"
                           "MAXA"
                           "MAXX"
                           "MEDIAN"
                           "MEDIANX"
                           "MID"
                           "MIN"
                           "MINA"
                           "MINUTE"
                           "MINX"
                           "MOD"
                           "MONTH"
                           "MROUND"
                           "NATURALINNERJOIN"
                           "NATURALLEFTOUTERJOIN"
                           "NEXTDAY"
                           "NEXTMONTH"
                           "NEXTQUARTER"
                           "NEXTYEAR"
                           "NOT"
                           "NOW"
                           "ODD"
                           "OPENINGBALANCEMONTH"
                           "OPENINGBALANCEQUARTER"
                           "OPENINGBALANCEYEAR"
                           "OR"
                           "PARALLELPERIOD"
                           "PATH"
                           "PATHCONTAINS"
                           "PATHITEM"
                           "PATHITEMREVERSE"
                           "PATHLENGTH"
                           "PERCENTILE.EXC"
                           "PERCENTILE.INC"
                           "PERCENTILEX.EXC"
                           "PERCENTILEX.INC"
                           "PERMUT"
                           "PI"
                           "POISSON.DIST"
                           "POWER"
                           "PREVIOUSDAY"
                           "PREVIOUSMONTH"
                           "PREVIOUSQUARTER"
                           "PREVIOUSYEAR"
                           "PRODUCT"
                           "PRODUCTX"
                           "QUOTIENT"
                           "RADIANS"
                           "RAND"
                           "RANDBETWEEN"
                           "RANK.EQ"
                           "RANKX"
                           "RELATED"
                           "RELATEDTABLE"
                           "REPLACE"
                           "REPT"
                           "RIGHT"
                           "ROUND"
                           "ROUNDDOWN"
                           "ROUNDUP"
                           "ROW"
                           "SAMEPERIODLASTYEAR"
                           "SAMPLE"
                           "SEARCH"
                           "SECOND"
                           "SELECTCOLUMNS"
                           "SELECTEDVALUE"
                           "SIGN"
                           "SIN"
                           "SINH"
                           "SQRT"
                           "SQRTPI"
                           "STARTOFMONTH"
                           "STARTOFQUARTER"
                           "STARTOFYEAR"
                           "STDEV.P"
                           "STDEV.S"
                           "STDEVX.P"
                           "STDEVX.S"
                           "SUBSTITUTE"
                           "SUBSTITUTEWITHINDEX"
                           "SUM"
                           "SUMMARIZE"
                           "SUMMARIZECOLUMNS"
                           "SUMX"
                           "SWITCH"
                           "Table"
                           "Constructor"
                           "TAN"
                           "TANH"
                           "TIME"
                           "TIMEVALUE"
                           "TODAY"
                           "TOPN"
                           "TOTALMTD"
                           "TOTALQTD"
                           "TOTALYTD"
                           "TREATAS"
                           "TRIM"
                           "TRUE"
                           "TRUNC"
                           "UNICHAR"
                           "UNION"
                           "UPPER"
                           "USERELATIONSHIP"
                           "USERNAME"
                           "UTCNOW"
                           "UTCTODAY"
                           "VALUE"
                           "VALUES"
                           "VAR"
                           "VAR.P"
                           "VAR.S"
                           "VARX.P"
                           "VARX.S"
                           "WEEKDAY"
                           "WEEKNUM"
                           "XIRR"
                           "XNPV"
                           "YEAR"
                           "YEARFRAC"
                           ))

            ;; generate regex string for each category of keywords
            (x-keywords-regexp (regexp-opt x-keywords 'words))
            ;(x-types-regexp (regexp-opt x-types 'words))
            ;(x-constants-regexp (regexp-opt x-constants 'words))
            ;(x-events-regexp (regexp-opt x-events 'words))
            (x-functions-regexp (regexp-opt x-functions 'words)))

        `(
          ;(,x-types-regexp . font-lock-type-face)
          ;(,x-constants-regexp . font-lock-constant-face)
          ;(,x-events-regexp . font-lock-builtin-face)
          (,x-functions-regexp . font-lock-function-name-face)
          (,x-keywords-regexp . font-lock-keyword-face)
          ;; note: order above matters, because once colored, that part won't change.
          ;; in general, put longer words first
          )))

;;;###autoload
(define-derived-mode dax-mode c-mode "dax mode"
  "Major mode for editing DAX ( Language)…"

  ;; code for syntax highlighting
  (setq font-lock-defaults '(dax-font-lock-keywords nil t))
  (set (make-local-variable 'indent-line-function) #'indent-relative)
  )

;; add the mode to the `features' list
(provide 'dax-mode)

;;; dax-mode.el ends here
