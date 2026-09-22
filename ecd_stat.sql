CREATE TABLE school_attendance_statistics (
    school_attendance_statistics_id INT AUTO_INCREMENT PRIMARY KEY,
    attendance_date DATE NOT NULL,

    present_count INT NOT NULL DEFAULT 0,
    absent_count INT NOT NULL DEFAULT 0,
    late_count INT NOT NULL DEFAULT 0,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_school_attendance_date (attendance_date)
);
CREATE TABLE class_attendance_statistics (
    class_attendance_statistics_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    attendance_date DATE NOT NULL,

    present_count INT NOT NULL DEFAULT 0,
    absent_count INT NOT NULL DEFAULT 0,
    late_count INT NOT NULL DEFAULT 0,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    UNIQUE KEY uq_class_attendance_date (class_id, attendance_date),

    CONSTRAINT fk_class_attendance_statistics_class
        FOREIGN KEY (class_id)
        REFERENCES class(class_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE payment_method (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(30) NOT NULL UNIQUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE account_name (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_method_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(100) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'RWF',
    notes TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_account_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_method(payment_method_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

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
