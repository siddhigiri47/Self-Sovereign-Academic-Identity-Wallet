;; -------------------------------------------------
;; Self-Sovereign Academic Identity Wallet
;; A minimal Clarity contract with 2 core functions
;; -------------------------------------------------

;; Map to store academic credentials
;; Key: principal (student's wallet address)
;; Value: (tuple (name string-ascii) (course string-ascii) (year uint))
(define-map credentials principal 
  { name: (string-ascii 50), course: (string-ascii 50), year: uint })

;; Error constants (for public functions)
(define-constant err-invalid-data (err u100))

;; -------------------------------------------------
;; Function 1: Add academic credential
;; -------------------------------------------------
(define-public (add-credential (student-name (string-ascii 50)) 
                              (course-name (string-ascii 50)) 
                              (year-of-completion uint))
  (begin
    ;; Validate data
    (asserts! (> (len student-name) u0) err-invalid-data)
    (asserts! (> (len course-name) u0) err-invalid-data)
    (asserts! (> year-of-completion u0) err-invalid-data)

    ;; Save the credential (tx-sender = student)
    (map-set credentials tx-sender 
      { name: student-name, course: course-name, year: year-of-completion })

    (ok true)
  )
)

;; -------------------------------------------------
;; Function 2: Get academic credential (type-safe)
;; -------------------------------------------------
(define-read-only (get-credential (student principal))
  (match (map-get? credentials student)
    stored
      (ok { status: "success", credential: (some stored) }) ;; always same type
    (ok { status: "error", credential: none })               ;; no record found
  )
)
