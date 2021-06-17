(require 'subr-x)
(require 'cl-lib)

(setq-local xcode-out "Information about project \"MyProject\":
    Targets:
        iOS
        iOSTests
        iOSUITests
        watchOS App
        watchOS App Extension
        tvOS
        tvOSTests
        tvOSUITests
        macOS
        macOSTests
        macOSUITests
 
    Build Configurations:
        Debug
        Release
 
 If no build configuration is specified and -scheme is not passed then \"Debug\" is used.
 
    Schemes:
        iOS
        watchOS App
        tvOS
        macOS")

(defun xcode-extract (project-info keyword stopword)
  (cl-remove-if (apply-partially 'string= "")
                (mapcar 'string-trim
                        (split-string
                         (substring project-info
                                    (+ 9 (string-match (regexp-quote keyword) project-info))
                                    (when stopword (string-match (regexp-quote stopword) project-info)))
                         "\n"))))

(defun xcode-print-items-list (items name)
  (let* ((nums (number-sequence 0 (length items)))
         (items-pair (cl-mapcar 'cons nums items))
         (item-strings (mapconcat (lambda (x)
                                    (format "[%d] %s\n" (car x) (cdr x))) items-pair "")))
    (princ (format "Select %s:\n" name))
    (princ item-strings)))

(defun xcode-get-nth-item (items name)
  (interactive)
  (with-output-to-temp-buffer "*xcode*"
    (xcode-print-items-list items name))
  (let (n)
    (setq n (read-number "Select item: " 0))
    (print (nth n items))))

(defun xcode-get-items (project-info name)
  (xcode-get-nth-item (xcode-extract project-info "Targets:" "Build") name))

(xcode-get-items xcode-out "target")
