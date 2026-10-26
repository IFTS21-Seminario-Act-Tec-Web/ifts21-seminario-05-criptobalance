
USE criptobalance_db;

-- 1. CLIENTES (5 registros)
INSERT INTO Cliente (nombre, apellido, email, telefono) VALUES
('Lucas', 'Perez', 'lucas.perez@example.com', '1100000001'),
('Sofia', 'Gomez', 'sofia.gomez@example.com', '1100000002'),
('Mateo', 'Lopez', 'mateo.lopez@example.com', '1100000003'),
('Valentina', 'Diaz', 'valentina.diaz@example.com', '1100000004'),
('Tomas', 'Fernandez', 'tomas.fernandez@example.com', '1100000005');

-- 2. ESTADOS (5 registros)
INSERT INTO Estado (nombre, descripcion) VALUES
('Pendiente', 'Tramite recibido y pendiente de revision'),
('En proceso', 'Tramite en curso'),
('Documentacion requerida', 'Falta documentacion'),
('Aprobado', 'Tramite aprobado'),
('Finalizado', 'Tramite finalizado');

-- 3. LEGAJOS (5 registros)
INSERT INTO Legajo (id_cliente, fecha_apertura, observaciones) VALUES
(1, '2026-01-10', 'Legajo inicial'),
(2, '2026-01-15', 'Documentacion recibida'),
(3, '2026-02-01', 'Cliente de servicios contables'),
(4, '2026-02-12', 'Legajo actualizado'),
(5, '2026-03-05', 'Alta de cliente');

-- 4. PERFILES FISCALES (5 registros)
INSERT INTO PerfilFiscal (id_cliente, categoria, actividad) VALUES
(1, 'Monotributo H', 'Desarrollo de software'),
(2, 'Monotributo D', 'Servicios profesionales'),
(3, 'Responsable Inscripto', 'Consultoria IT'),
(4, 'Monotributo F', 'Diseno grafico'),
(5, 'Monotributo C', 'Servicios digitales');

-- 5. TRAMITES (5 registros)
INSERT INTO Tramite
(id_legajo, id_estado, nombre, descripcion, fecha_inicio) VALUES
(1, 1, 'Alta fiscal', 'Solicitud de alta fiscal', '2026-03-01'),
(2, 2, 'Actualizacion de datos', 'Actualizacion de datos fiscales', '2026-03-05'),
(3, 3, 'Revision documental', 'Revision de documentacion', '2026-03-10'),
(4, 4, 'Inscripcion tributaria', 'Inscripcion completada', '2026-03-12'),
(5, 5, 'Consulta impositiva', 'Gestion finalizada', '2026-03-15');

-- 6. HISTORIAL DE ESTADOS (10 registros)
INSERT INTO HistorialEstado
(id_tramite, id_estado, fecha_cambio, observacion) VALUES
(1, 1, '2026-03-01 09:00:00', 'Tramite recibido'),
(1, 2, '2026-03-02 10:00:00', 'Revision iniciada'),
(2, 1, '2026-03-05 09:30:00', 'Tramite recibido'),
(2, 2, '2026-03-06 11:00:00', 'En revision'),
(3, 1, '2026-03-10 08:30:00', 'Solicitud ingresada'),
(3, 3, '2026-03-11 12:00:00', 'Se solicita documentacion'),
(4, 1, '2026-03-12 10:00:00', 'Tramite recibido'),
(4, 4, '2026-03-13 15:00:00', 'Tramite aprobado'),
(5, 1, '2026-03-15 09:00:00', 'Consulta recibida'),
(5, 5, '2026-03-16 16:00:00', 'Gestion finalizada');

-- 7. CONSULTAS (5 registros)
INSERT INTO Consulta
(id_cliente, asunto, mensaje, fecha) VALUES
(1, 'Impuestos', 'Consulta sobre obligaciones fiscales', '2026-03-01 10:00:00'),
(2, 'Monotributo', 'Consulta sobre categoria fiscal', '2026-03-02 11:00:00'),
(3, 'Facturacion', 'Consulta sobre facturacion mensual', '2026-03-03 12:00:00'),
(4, 'Inscripcion', 'Consulta sobre inscripcion tributaria', '2026-03-04 13:00:00'),
(5, 'Servicios', 'Consulta sobre servicios contables', '2026-03-05 14:00:00');

-- 8. CONTACTOS (5 registros)
INSERT INTO contactos (nombre, email, asunto, mensaje) VALUES
('Ana Demo', 'ana.demo@example.com', 'Consulta general', 'Quisiera conocer los servicios'),
('Bruno Demo', 'bruno.demo@example.com', 'Simulador fiscal', 'Consulta sobre el simulador'),
('Carla Demo', 'carla.demo@example.com', 'Servicios contables', 'Quisiera recibir informacion'),
('Diego Demo', 'diego.demo@example.com', 'Facturacion', 'Necesito informacion sobre facturacion'),
('Eva Demo', 'eva.demo@example.com', 'Contacto', 'Quisiera coordinar una consulta');
