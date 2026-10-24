CREATE TABLE assessment_type (
    assessment_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL,
    description TEXT NULL,
    UNIQUE KEY uq_assessment_type_name (type_name)
);
CREATE TABLE assessment_component (
    assessment_component_id INT AUTO_INCREMENT PRIMARY KEY,
    assessment_type_id INT NOT NULL,
    component_name VARCHAR(100) NOT NULL,
    description TEXT NULL,

    UNIQUE KEY uq_component_type_name
        (assessment_type_id, component_name),

    CONSTRAINT fk_component_type
        FOREIGN KEY (assessment_type_id)
        REFERENCES assessment_type(assessment_type_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
CREATE TABLE assessment (
    assessment_id INT AUTO_INCREMENT PRIMARY KEY,

    assignment_id INT NOT NULL,
    assessment_component_id INT NOT NULL,

    assessment_name VARCHAR(100) NOT NULL,
    max_score DECIMAL(10,2) NOT NULL,
    assessment_date DATE NULL,
    notes TEXT NULL,

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_assessment_assignment
        FOREIGN KEY (assignment_id)
        REFERENCES teacher_assignment(assignment_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_assessment_component
        FOREIGN KEY (assessment_component_id)
        REFERENCES assessment_component(assessment_component_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);


CREATE TABLE assessment_result (
    result_id INT AUTO_INCREMENT PRIMARY KEY,

    assessment_id INT NOT NULL,
    student_id INT NOT NULL,

    score DECIMAL(10,2) NULL,
    UNIQUE KEY uq_assessment_student
        (assessment_id, student_id),

    CONSTRAINT fk_result_assessment
        FOREIGN KEY (assessment_id)
        REFERENCES assessment(assessment_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_result_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

------------------
CREATE TABLE class_subject_assessment_type_mark (
    class_subject_assessment_type_mark_id INT AUTO_INCREMENT PRIMARY KEY,

    class_subject_id INT NOT NULL,
    assessment_type_id INT NOT NULL,

    max_marks DECIMAL(10,2) NOT NULL,

    UNIQUE KEY uq_class_subject_assessment_type (
        class_subject_id,
        assessment_type_id
    ),

    CONSTRAINT fk_type_mark_class_subject
        FOREIGN KEY (class_subject_id)
        REFERENCES class_subject(class_subject_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_type_mark_type
        FOREIGN KEY (assessment_type_id)
        REFERENCES assessment_type(assessment_type_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_type_mark_max
        CHECK (max_marks >= 0)
);
CREATE TABLE student_assessment_type_result (
    student_assessment_type_result_id INT AUTO_INCREMENT PRIMARY KEY,

    student_id INT NOT NULL,
    class_subject_assessment_type_mark_id INT NOT NULL,
    term_id INT NOT NULL,

    earned_marks DECIMAL(10,2) NULL,

    calculated_at DATETIME NULL,

    UNIQUE KEY uq_student_assessment_type_term (
        student_id,
        class_subject_assessment_type_mark_id,
        term_id
    ),

    CONSTRAINT fk_student_type_result_student
        FOREIGN KEY (student_id)
        REFERENCES student(student_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_student_type_result_mark
        FOREIGN KEY (class_subject_assessment_type_mark_id)
        REFERENCES class_subject_assessment_type_mark(class_subject_assessment_type_mark_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_student_type_result_term
        FOREIGN KEY (term_id)
        REFERENCES term(term_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_student_type_earned
        CHECK (earned_marks IS NULL OR earned_marks >= 0)
);
