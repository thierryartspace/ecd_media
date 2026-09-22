CREATE TABLE term_statistics (
    term_statistics_id INT AUTO_INCREMENT PRIMARY KEY,
    term_id INT NOT NULL,
    active_parents INT NOT NULL DEFAULT 0,
    active_students INT NOT NULL DEFAULT 0,
    active_staff INT NOT NULL DEFAULT 0,
    active_teachers INT NOT NULL DEFAULT 0,

    -- Gender
    male_parents INT NOT NULL DEFAULT 0,
    female_parents INT NOT NULL DEFAULT 0,
    male_students INT NOT NULL DEFAULT 0,
    female_students INT NOT NULL DEFAULT 0,
    male_staff INT NOT NULL DEFAULT 0,
    female_staff INT NOT NULL DEFAULT 0,
    male_teachers INT NOT NULL DEFAULT 0,
    female_teachers INT NOT NULL DEFAULT 0,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_term_statistics (term_id),
    CONSTRAINT fk_term_statistics_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE academic_term_finance_statistics (
    academic_term_finance_statistics_id INT AUTO_INCREMENT PRIMARY KEY,

    term_id INT NOT NULL,

    total_fees_expected DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_fees_paid DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_fees_outstanding DECIMAL(14,2) NOT NULL DEFAULT 0,

    total_payments INT NOT NULL DEFAULT 0,
    total_students_with_fees INT NOT NULL DEFAULT 0,

    students_fully_paid INT NOT NULL DEFAULT 0,
    students_partially_paid INT NOT NULL DEFAULT 0,
    students_unpaid INT NOT NULL DEFAULT 0,

    total_overpayments DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_credit_carried_forward DECIMAL(14,2) NOT NULL DEFAULT 0,
    total_refunded DECIMAL(14,2) NOT NULL DEFAULT 0,

    average_payment_amount DECIMAL(14,2) NOT NULL DEFAULT 0,
    average_fee_paid_per_student DECIMAL(14,2) NOT NULL DEFAULT 0,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_term_finance_statistics (term_id),

    CONSTRAINT fk_term_finance_statistics_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE academic_term_payment_statistics (
    academic_term_payment_statistics_id INT AUTO_INCREMENT PRIMARY KEY,
    term_id INT NOT NULL,
    account_id INT NOT NULL,
    transaction_count INT NOT NULL DEFAULT 0,
    total_amount DECIMAL(14) NOT NULL DEFAULT 0,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uq_term_account_statistics (term_id, account_id),
    CONSTRAINT fk_term_payment_statistics_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_term_payment_statistics_account
        FOREIGN KEY (account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE term_class_statistics (
    term_class_statistics_id INT AUTO_INCREMENT PRIMARY KEY,
    term_id INT NOT NULL,
    class_id INT NOT NULL,

    active_students INT NOT NULL DEFAULT 0,
    male_students INT NOT NULL DEFAULT 0,
    female_students INT NOT NULL DEFAULT 0,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_term_class_statistics (term_id, class_id),

    CONSTRAINT fk_term_class_statistics_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_term_class_statistics_class
        FOREIGN KEY (class_id)
        REFERENCES class(class_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
