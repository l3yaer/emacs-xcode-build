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

(defun xcode-extract-schemes (project-info)
  (mapcar 'string-trim
          (split-string
           (substring project-info
                      (+ 9 (string-match (regexp-quote "Schemes:") project-info)))
           "\n")))

(defun xcode-print-schemes-list (schemes)
  (let* ((nums (number-sequence 0 (length schemes)))
         (schemes-pair (cl-mapcar 'cons nums schemes))
         (scheme-strings (mapconcat (lambda (x)
                                      (format "[%d] %s\n" (car x) (cdr x))) schemes-pair "")))
    (princ "Select scheme:\n")
    (princ scheme-strings)))

(defun xcode-get-nth-scheme (schemes)
  (interactive)
  (with-output-to-temp-buffer "*xcode*"
    (xcode-print-schemes-list schemes))
  (let (n)
    (setq n (read-number "Select scheme: " 0))
    (print (nth n schemes))))

(defun xcode-get-schemes (schemes)
  (xcode-get-nth-scheme (xcode-extract-schemes schemes)))
 
(xcode-get-schemes xcode-out)
