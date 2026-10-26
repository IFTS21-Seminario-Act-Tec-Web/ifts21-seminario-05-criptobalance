
CREATE DATABASE IF NOT EXISTS criptobalance_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE criptobalance_db;

-- =========================================
-- 1. CLIENTE
-- =========================================
CREATE TABLE IF NOT EXISTS Cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(30)
) ENGINE=InnoDB;

-- =========================================
-- 2. ESTADO
-- =========================================
CREATE TABLE IF NOT EXISTS Estado (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- =========================================
-- 3. LEGAJO
-- =========================================
CREATE TABLE IF NOT EXISTS Legajo (
    id_legajo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL UNIQUE,
    fecha_apertura DATE NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_legajo_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- 4. PERFIL FISCAL
-- =========================================
CREATE TABLE IF NOT EXISTS PerfilFiscal (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    actividad VARCHAR(100) NOT NULL,
    CONSTRAINT fk_perfil_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- 5. TRAMITE
-- =========================================
CREATE TABLE IF NOT EXISTS Tramite (
    id_tramite INT AUTO_INCREMENT PRIMARY KEY,
    id_legajo INT NOT NULL,
    id_estado INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    CONSTRAINT fk_tramite_legajo
        FOREIGN KEY (id_legajo)
        REFERENCES Legajo(id_legajo)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_tramite_estado
        FOREIGN KEY (id_estado)
        REFERENCES Estado(id_estado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- 6. HISTORIAL DE ESTADO
-- =========================================
CREATE TABLE IF NOT EXISTS HistorialEstado (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_tramite INT NOT NULL,
    id_estado INT NOT NULL,
    fecha_cambio DATETIME NOT NULL,
    observacion VARCHAR(255),
    CONSTRAINT fk_historial_tramite
        FOREIGN KEY (id_tramite)
        REFERENCES Tramite(id_tramite)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_historial_estado
        FOREIGN KEY (id_estado)
        REFERENCES Estado(id_estado)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- 7. CONSULTA
-- =========================================
CREATE TABLE IF NOT EXISTS Consulta (
    id_consulta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    asunto VARCHAR(150) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME NOT NULL,
    CONSTRAINT fk_consulta_cliente
        FOREIGN KEY (id_cliente)
        REFERENCES Cliente(id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =========================================
-- 8. CONTACTOS (FORMULARIO WEB)
-- =========================================
CREATE TABLE IF NOT EXISTS contactos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    asunto VARCHAR(150) NOT NULL,
    mensaje TEXT NOT NULL,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;
