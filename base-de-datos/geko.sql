CREATE DATABASE geko;
USE geko;


CREATE TABLE rol (
id_rol INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
estado BOOL DEFAULT 0,
tipo_rol ENUM('Administrador', 'Usuario') NOT NULL
);


CREATE TABLE usuarios (
id_usuario INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nombre VARCHAR(50) NOT NULL,
apellido VARCHAR(50) NOT NULL,
correo VARCHAR(50) NOT NULL,
contrasena VARCHAR(50) NOT NULL,
numero VARCHAR(20) NOT NULL,
sexo enum ("F","M"),
fecha_nacimiento DATE,
nombre_usuario VARCHAR(50) unique
);


CREATE TABLE enfermedades (
id_enfermedades INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
Cardiovascular TINYINT(1) DEFAULT 0,
Asma TINYINT(1) DEFAULT 0,
Fractura TINYINT(1) DEFAULT 0,
Fumador TINYINT(1) DEFAULT 0,
Diabetes TINYINT(1) DEFAULT 0,
Cirugias TINYINT(1) DEFAULT 0,
Convulsiones TINYINT(1) DEFAULT 0,
Falta_Vitaminas TINYINT(1) DEFAULT 0,
Obesidad TINYINT(1) DEFAULT 0,
Colesterol TINYINT(1) DEFAULT 0,
Alteraciones_sanguineas TINYINT(1) DEFAULT 0,
Afeccion_auditiva TINYINT(1) DEFAULT 0,
Otras_Enfermedades VARCHAR(255) DEFAULT NULL
);


CREATE TABLE mediciones (
id_mediciones INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_usuario int,
nivel_fisico ENUM('Alto', 'Medio', 'Bajo') NOT NULL,
altura DECIMAL(5,2) NOT NULL,
peso DECIMAL(5,1) NOT NULL,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
fecha_actualizacion DATE
);


CREATE TABLE clientes (
id_cliente INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_rol INT,
id_usuario INT,
enfermedad VARCHAR(40) NULL,
objetivo VARCHAR(30) NULL,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
);

CREATE TABLE tipo_cirugia (
id_tipo_cirugia INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_enfermedades INT,
descripcion_cirugia VARCHAR(100) NOT NULL,
FOREIGN KEY (id_enfermedades) REFERENCES enfermedades(id_enfermedades)
);


CREATE TABLE planes (
id_plan INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_cliente INT,
tipo_plan ENUM('Premium', 'Basico') NOT NULL,
valor DECIMAL(10,2) NOT NULL,
fecha_inicio DATE,
fecha_termino DATE,
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE ingresos (
id_ingresos INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_usuario INT,
id_plan INT,
estado TINYINT(1) DEFAULT 0,
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
);

CREATE TABLE ficha_medica (
id_ficha INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_mediciones INT,
id_cliente INT,
id_enfermedades INT,
FOREIGN KEY (id_mediciones) REFERENCES mediciones(id_mediciones),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
FOREIGN KEY (id_enfermedades) REFERENCES enfermedades(id_enfermedades)
);


CREATE TABLE ejercicios (
id_ejercicio INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_ficha INT,
complejidad ENUM('Facil', 'Medio', 'Dificil') NOT NULL,
descripcion VARCHAR(30) NOT NULL,
observacion VARCHAR(50),
FOREIGN KEY (id_ficha) REFERENCES ficha_medica(id_ficha)
);

CREATE TABLE plan_entrenamiento (
id_plan_entrenamiento INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_ejercicio INT,
id_planes INT,
dias_entrenamiento INT NOT NULL,
tiempo TIME NOT NULL,
FOREIGN KEY (id_ejercicio) REFERENCES ejercicios(id_ejercicio),
FOREIGN KEY (id_planes) REFERENCES planes(id_plan)
);

CREATE TABLE detalle_plan_entrenamiento (
id_detalle_plan_entrenamiento INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
id_plan_entrenamiento INT,
id_cliente INT,
tipo_ejercicio VARCHAR(20) NOT NULL,
descanso TIME NOT NULL,
FOREIGN KEY (id_plan_entrenamiento) REFERENCES plan_entrenamiento(id_plan_entrenamiento),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);


SELECT 
u.nombre, u.apellido, u.correo,p.tipo_plan, p.valor, p.fecha_inicio, p.fecha_termino
FROM clientes c
INNER JOIN usuarios u ON c.id_usuario = u.id_usuario
INNER JOIN rol r ON c.id_rol = r.id_rol
INNER JOIN planes p ON c.id_cliente = p.id_cliente;

SELECT 
u.nombre, u.apellido, e.descripcion AS ejercicio,
e.complejidad, pe.dias_entrenamiento, pe.tiempo, dpe.tipo_ejercicio, dpe.descanso
FROM detalle_plan_entrenamiento dpe
INNER JOIN clientes c ON dpe.id_cliente = c.id_cliente
INNER JOIN usuarios u ON c.id_usuario = u.id_usuario
INNER JOIN plan_entrenamiento pe ON dpe.id_plan_entrenamiento = pe.id_plan_entrenamiento
INNER JOIN ejercicios e ON pe.id_ejercicio = e.id_ejercicio;

SELECT 
u.nombre, u.apellido,
tc.descripcion_cirugia
FROM ficha_medica f
INNER JOIN clientes c ON f.id_cliente = c.id_cliente
INNER JOIN usuarios u ON c.id_usuario = u.id_usuario
INNER JOIN enfermedades e ON f.id_enfermedades = e.id_enfermedades
INNER JOIN tipo_cirugia tc ON tc.id_enfermedades = e.id_enfermedades
WHERE e.Cirugias = 1;


SELECT nombre, apellido
FROM usuarios
WHERE id_usuario IN (
  SELECT c.id_usuario
  FROM clientes c
  INNER JOIN planes p ON c.id_cliente = p.id_cliente
  WHERE p.fecha_termino > CURDATE()
);

SELECT nombre, apellido
FROM usuarios
WHERE id_usuario IN (
  SELECT c.id_usuario
  FROM clientes c
  INNER JOIN planes p ON c.id_cliente = p.id_cliente
  WHERE p.fecha_termino < CURDATE()
);

