CREATE TABLE person (
    person_id INT AUTO_INCREMENT PRIMARY KEY,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE student
    ADD COLUMN person_id INT NULL UNIQUE,
    ADD CONSTRAINT fk_student_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;

ALTER TABLE staff
    ADD COLUMN person_id INT NULL UNIQUE,
    ADD CONSTRAINT fk_staff_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;
ALTER TABLE parent
    ADD COLUMN person_id INT NULL UNIQUE,
    ADD CONSTRAINT fk_parent_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT;


-------------------
CREATE TABLE attendance (
    attendance_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    person_id INT NOT NULL,

    attendance_date DATE NOT NULL,

    expected BOOLEAN NOT NULL,

    status ENUM(
        'Present',
        'Absent',
        'Excused'
    ) NULL,

    notes TEXT NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY uq_person_attendance_date (
        person_id,
        attendance_date
    ),

    CONSTRAINT fk_attendance_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE attendance_log (
    attendance_log_id BIGINT AUTO_INCREMENT PRIMARY KEY,

    attendance_id BIGINT NOT NULL,

    event_type ENUM(
        'In',
        'Out'
    ) NOT NULL,

    event_time DATETIME NOT NULL,

    result ENUM(
        'Allowed',
        'Denied'
    ) NOT NULL,

    timing_status ENUM(
        'Early',
        'On Time',
        'Late'
    ) NULL,

    attendance_method ENUM(
        'Biometric',
        'Manual'
    ) NOT NULL,

    notes TEXT NULL,

    recorded_by_staff_id INT NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_attendance_log_attendance (
        attendance_id
    ),

    INDEX idx_attendance_log_time (
        event_time
    ),

    CONSTRAINT fk_attendance_log_attendance
        FOREIGN KEY (attendance_id)
        REFERENCES attendance(attendance_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_attendance_log_staff
        FOREIGN KEY (recorded_by_staff_id)
        REFERENCES staff(staff_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE visitor (
    visitor_id INT AUTO_INCREMENT PRIMARY KEY,

    person_id INT NOT NULL UNIQUE,

    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,

    identification_number VARCHAR(100) NULL,
    address TEXT NULL,
    notes TEXT NULL,

    status ENUM(
        'Active',
        'Inactive'
    ) NOT NULL DEFAULT 'Active',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_visitor_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-------------------------
CREATE TABLE student (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    reg_no VARCHAR(20) NOT NULL UNIQUE,
    person_id INT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NULL,
    date_of_birth DATE NULL,
    enrollment_date DATE NULL,
    photo_url VARCHAR(255) NULL,
    blood_group VARCHAR(5) NULL,
    medical_notes TEXT NULL,
    address TEXT NULL,
    status ENUM('Active','Inactive','Graduated','Withdrawn') NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_parent_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE parent (
    parent_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL UNIQUE,
    person_id INT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    relationship VARCHAR(20) NULL,
    phone VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    occupation VARCHAR(50) NULL,
    address TEXT NULL,
    CONSTRAINT fk_parent_user
        FOREIGN KEY (user_id) REFERENCES `user`(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_parent_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL UNIQUE,
    person_id INT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender ENUM('Male','Female','Other') NULL,
    date_of_birth DATE NULL,
    national_id VARCHAR(30) NULL,
    phone VARCHAR(20) NULL,
    address TEXT NULL,
    hire_date DATE NULL,
    position VARCHAR(50) NULL,
    department VARCHAR(50) NULL,
    photo_url VARCHAR(255) NULL,
    CONSTRAINT fk_staff_user
        FOREIGN KEY (user_id) REFERENCES `user`(user_id)
        ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT fk_parent_person
        FOREIGN KEY (person_id)
        REFERENCES person(person_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
