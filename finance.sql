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

-------------------------staff
CREATE TABLE salary_component_type (
    component_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE salary_component (
    component_id INT AUTO_INCREMENT PRIMARY KEY,
    component_type_id INT NOT NULL,
    component_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_salary_component_type
        FOREIGN KEY (component_type_id)
        REFERENCES salary_component_type(component_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE staff_salary_component (
    staff_salary_component_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    component_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL DEFAULT 0,

    CONSTRAINT fk_staff_salary_component_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_salary_component_component
        FOREIGN KEY (component_id)
        REFERENCES salary_component(component_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE payroll_period (
    payroll_period_id INT AUTO_INCREMENT PRIMARY KEY,
    period_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL, 
    end_date DATE NOT NULL,
    is_closed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE staff_account_name (
    staff_account_id INT AUTO_INCREMENT PRIMARY KEY,
    staff_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    account_name VARCHAR(100) NOT NULL,
    account_number VARCHAR(100) NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'RWF',
    notes TEXT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_staff_account_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_account_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_method(payment_method_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE staff_payroll (
    payroll_id INT AUTO_INCREMENT PRIMARY KEY,
    payroll_period_id INT NOT NULL,
    staff_id INT NOT NULL,

    total_earning DECIMAL(15,2) NOT NULL DEFAULT 0,
    total_deduction DECIMAL(15,2) NOT NULL DEFAULT 0,
    net_salary DECIMAL(15,2) NOT NULL DEFAULT 0,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_staff_payroll_period
        FOREIGN KEY (payroll_period_id)
        REFERENCES payroll_period(payroll_period_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_payroll_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE staff_payment (
    staff_payment_id INT AUTO_INCREMENT PRIMARY KEY,
    payroll_id INT NOT NULL,
    staff_account_id INT NOT NULL,
    school_account_id INT NOT NULL,
    recorded_by_staff_id INT NOT NULL,

    payment_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    notes TEXT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_staff_payment_payroll
        FOREIGN KEY (payroll_id)
        REFERENCES staff_payroll(payroll_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_payment_staff_account
        FOREIGN KEY (staff_account_id)
        REFERENCES staff_account_name(staff_account_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_payment_school_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_payment_recorded_by
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE staff_payroll_balance (
    balance_id INT AUTO_INCREMENT PRIMARY KEY,

    payroll_id INT NOT NULL,
    staff_id INT NOT NULL,

    balance_type ENUM('UNDERPAID', 'OVERPAID') NOT NULL,

    original_amount DECIMAL(15,2) NOT NULL,
    remaining_amount DECIMAL(15,2) NOT NULL,

    notes TEXT NULL,
    recorded_by_staff_id INT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_payroll_balance_amounts
        CHECK (
            original_amount > 0
            AND remaining_amount >= 0
            AND remaining_amount <= original_amount
        ),

    CONSTRAINT fk_payroll_balance_payroll
        FOREIGN KEY (payroll_id)
        REFERENCES staff_payroll(payroll_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_payroll_balance_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_payroll_balance_recorded_by
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE staff_refund (
    staff_refund_id INT AUTO_INCREMENT PRIMARY KEY,

    balance_id INT NOT NULL,
    staff_id INT NOT NULL,
    school_account_id INT NOT NULL,
    recorded_by_staff_id INT NOT NULL,

    refund_date DATE NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    notes TEXT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_staff_refund_balance
        FOREIGN KEY (balance_id)
        REFERENCES staff_payroll_balance(balance_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_refund_staff
        FOREIGN KEY (staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_refund_school_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_staff_refund_recorded_by
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
---------------------------fees

CREATE TABLE fee_component (
    fee_component_id INT AUTO_INCREMENT PRIMARY KEY,
    component_name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE fee_structure (
    fee_structure_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id INT NOT NULL,
    term_id INT NOT NULL,
    fee_component_id INT NOT NULL,

    amount DECIMAL(12,2) NOT NULL,
    due_date DATE NULL,

    CONSTRAINT chk_fee_structure_amount
        CHECK (amount >= 0),

    CONSTRAINT uq_fee_structure_component
        UNIQUE (class_id, term_id, fee_component_id),

    CONSTRAINT fk_fee_class
        FOREIGN KEY (class_id)
        REFERENCES class(class_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_fee_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_fee_structure_component
        FOREIGN KEY (fee_component_id)
        REFERENCES fee_component(fee_component_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE student_fee (
    student_fee_id INT AUTO_INCREMENT PRIMARY KEY,

    student_id INT NOT NULL,
    fee_structure_id INT NULL,
    fee_component_id INT NOT NULL,

    description VARCHAR(255) NULL,

    amount_due DECIMAL(12,2) NOT NULL,
    waived_amount DECIMAL(12,2) NOT NULL DEFAULT 0,

    status ENUM(
        'UNPAID',
        'PARTIALLY_PAID',
        'PAID',
        'WAIVED'
    ) NOT NULL DEFAULT 'UNPAID',

    due_date DATE NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT uq_student_standard_fee
        UNIQUE (student_id, fee_structure_id),

    CONSTRAINT fk_student_fee_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_student_fee_structure_component
        FOREIGN KEY (fee_structure_id, fee_component_id)
        REFERENCES fee_structure(fee_structure_id, fee_component_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_student_fee_component
        FOREIGN KEY (fee_component_id)
        REFERENCES fee_component(fee_component_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    parent_id INT NOT NULL,
    school_account_id INT NOT NULL,
    payment_method_id INT NOT NULL,
    received_by INT NULL,

    amount DECIMAL(12,2) NOT NULL,
    payment_date DATE NOT NULL,
    transaction_ref VARCHAR(100) NULL,
    notes TEXT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payment_parent
        FOREIGN KEY (parent_id)
        REFERENCES parent(parent_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_payment_school_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_payment_method
        FOREIGN KEY (payment_method_id)
        REFERENCES payment_method(payment_method_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_payment_received_by
        FOREIGN KEY (received_by)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE payment_allocation (
    allocation_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    student_fee_id INT NOT NULL,
    amount DECIMAL(12,2) NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_payment_allocation_amount
        CHECK (amount > 0),

    CONSTRAINT fk_allocation_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_allocation_student_fee
        FOREIGN KEY (student_fee_id)
        REFERENCES student_fee(student_fee_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE student_refund (
    refund_id INT AUTO_INCREMENT PRIMARY KEY,

    payment_id INT NOT NULL,
    school_account_id INT NOT NULL,
    recorded_by_staff_id INT NOT NULL,

    refund_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    reason TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_student_refund_amount
        CHECK (amount > 0),

    CONSTRAINT fk_student_refund_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_student_refund_school_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_student_refund_recorded_by
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

ALTER TABLE class_enrollment
ADD COLUMN withdrawal_date DATE NULL,
ADD COLUMN withdrawal_reason TEXT NULL;

----------------------transcation school other
CREATE TABLE finance_type (
    finance_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);


CREATE TABLE other_transaction_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    finance_type_id INT NOT NULL,
    description TEXT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_other_category_finance_type
        FOREIGN KEY (finance_type_id)
        REFERENCES finance_type(finance_type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);


CREATE TABLE other_transaction (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    school_account_id INT NOT NULL,
    recorded_by_staff_id INT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_date DATE NOT NULL,
    reference_number VARCHAR(100) NULL,
    description TEXT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_other_transaction_category
        FOREIGN KEY (category_id)
        REFERENCES other_transaction_category(category_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_other_transaction_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_other_transaction_staff
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE ON DELETE SET NULL
);
------------parent payment
CREATE TABLE payment_unallocated (
    payment_unallocated_id INT AUTO_INCREMENT PRIMARY KEY,

    payment_id INT NOT NULL,

    amount DECIMAL(12,2) NOT NULL,
    status ENUM('AVAILABLE','ALLOCATED','REFUNDED') NOT NULL DEFAULT 'AVAILABLE',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT chk_payment_unallocated_amount
        CHECK (amount > 0),

    CONSTRAINT uq_payment_unallocated_payment
        UNIQUE (payment_id),

    CONSTRAINT fk_payment_unallocated_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE parent_refund (
    parent_refund_id INT AUTO_INCREMENT PRIMARY KEY,

    payment_id INT NOT NULL,
    parent_id INT NOT NULL,

    school_account_id INT NOT NULL,
    recorded_by_staff_id INT NOT NULL,

    refund_date DATE NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    notes TEXT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_parent_refund_payment
        FOREIGN KEY (payment_id)
        REFERENCES payment(payment_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_parent_refund_parent
        FOREIGN KEY (parent_id)
        REFERENCES parent(parent_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_parent_refund_school_account
        FOREIGN KEY (school_account_id)
        REFERENCES account_name(account_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,

    CONSTRAINT fk_parent_refund_recorded_by
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE ON DELETE RESTRICT
);
