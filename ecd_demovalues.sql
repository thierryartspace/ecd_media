INSERT INTO module (module_id, module_name, description) VALUES 
  (1,'Home', 'Dashboard and landing page');

INSERT INTO permission (module_id, permission_name, description) VALUES
(1, 'student.view.all',           'View all student records in the school'),
(1, 'student.view.assigned',      'View students in classes assigned to the logged-in teacher'),
(1, 'student.view.own_children',  'View only the logged-in parent''s own children'),

(1, 'student.create.all',         'Create a new student record'),

(1, 'student.edit.all',           'Edit any student record'),
(1, 'student.edit.assigned',      'Edit students in classes assigned to the teacher'),
(1, 'student.edit.own_children',  'Edit limited info on the parent''s own children'),

(1, 'student.delete.all',         'Delete any student record'),

(1, 'student.export.all',         'Export all student records'),
(1, 'student.export.assigned',    'Export students in the teacher''s assigned classes'),
(1, 'student.export.own_children','Export the parent''s own children records');
